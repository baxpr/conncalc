FROM ubuntu:20.04

# Initial system
# wget unzip zip xvfb ghostscript imagemagick bc     # Misc tools
# openjdk-8-jre                                      # Matlab MCR
# libglu1-mesa language-pack-en                      # Freeview
RUN apt update -y && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
        wget unzip zip xvfb ghostscript imagemagick bc \
        openjdk-8-jre \
        libglu1-mesa language-pack-en \
    && apt clean && apt -y autoremove

# Install the MCR
RUN wget -nv https://ssd.mathworks.com/supportfiles/downloads/R2019b/Release/6/deployment_files/installer/complete/glnxa64/MATLAB_Runtime_R2019b_Update_6_glnxa64.zip \
    -O /opt/mcr_installer.zip && \
    unzip /opt/mcr_installer.zip -d /opt/mcr_installer && \
    /opt/mcr_installer/install -mode silent -agreeToLicense yes && \
    rm -r /opt/mcr_installer /opt/mcr_installer.zip

# Install Freesurfer. We just need freeview
RUN wget -nv https://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/7.3.2/freesurfer-linux-centos7_x86_64-7.3.2.tar.gz \
    -O /opt/freesurfer.tgz && \
    mkdir -p /usr/local/freesurfer/bin /usr/local/freesurfer/lib/vtk && \
    tar -zxf /opt/freesurfer.tgz -C /usr/local freesurfer/bin/freeview && \
    tar -zxf /opt/freesurfer.tgz -C /usr/local freesurfer/bin/qt.conf && \
    tar -zxf /opt/freesurfer.tgz -C /usr/local freesurfer/build-stamp.txt && \
    tar -zxf /opt/freesurfer.tgz -C /usr/local freesurfer/SetUpFreeSurfer.sh && \
    tar -zxf /opt/freesurfer.tgz -C /usr/local freesurfer/FreeSurferEnv.sh && \
    tar -zxf /opt/freesurfer.tgz -C /usr/local freesurfer/lib/qt && \
    tar -zxf /opt/freesurfer.tgz -C /usr/local freesurfer/lib/vtk && \
    rm /opt/freesurfer.tgz
  
# Freeview needs a machine id here
RUN dbus-uuidgen > /etc/machine-id

# Copy the pipeline code. Matlab must be compiled before building. We need to
# make the ImageMagick security policy more permissive to be able to write PDFs.
COPY build /opt/conncalc/build
COPY bin /opt/conncalc/bin
COPY src /opt/conncalc/src
COPY README.md /opt/conncalc
COPY ImageMagick-policy.xml /etc/ImageMagick-6/policy.xml

# Matlab env
ENV MATLAB_SHELL=/bin/bash
ENV MATLAB_RUNTIME=/usr/local/MATLAB/MATLAB_Runtime/v97

# Add pipeline to system path
ENV PATH=/opt/conncalc/src:/opt/conncalc/bin:${PATH}

# Matlab executable must be run at build to extract the CTF archive
RUN run_spm12.sh ${MATLAB_RUNTIME} function quit

# Entrypoint
ENTRYPOINT ["xwrapper.sh","conncalc.sh"]
