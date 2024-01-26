# Start with Matlab's runtime container
FROM containers.mathworks.com/matlab-runtime:r2023a

# Modules
#   General:      wget unzip zip
#   Freesurfer:   bc ca-certificates curl libgomp1 libxmu6 libxt6 perl tcsh
#   ImageMagick:  ghostscript imagemagick
#   xvfb:         xvfb
RUN apt-get update -qq \
    && apt-get install -y -q --no-install-recommends \
        wget unzip zip \
        bc ca-certificates curl libgomp1 libxmu6 libxt6 perl tcsh \
        ghostscript imagemagick \
        xvfb \
    && rm -rf /var/lib/apt/lists/*

# Matlab env
ENV MATLAB_SHELL=/bin/bash
ENV AGREE_TO_MATLAB_RUNTIME_LICENSE=yes
ENV MATLAB_RUNTIME=/opt/matlabruntime/R2023a
ENV MCR_INHIBIT_CTF_LOCK=1
ENV MCR_CACHE_ROOT=/tmp

# Install Freesurfer (freeview only)
RUN wget -nv https://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/7.2.0/freesurfer-linux-centos7_x86_64-7.2.0.tar.gz \
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
 
# Freesurfer env
ENV OS=Linux
ENV PATH=/usr/local/freesurfer/bin:${PATH}
ENV FREESURFER_HOME=/usr/local/freesurfer
ENV FREESURFER=/usr/local/freesurfer
ENV SUBJECTS_DIR=/usr/local/freesurfer/subjects
ENV LOCAL_DIR=/usr/local/freesurfer/local
ENV FSF_OUTPUT_FORMAT=nii.gz
ENV XDG_RUNTIME_DIR=/tmp

# We need to make the ImageMagick security policy more permissive 
# to be able to write PDFs.
COPY ImageMagick-policy.xml /etc/ImageMagick-6/policy.xml

# Copy the pipeline code. Matlab must be compiled before building. 
COPY build /opt/conncalc/build
COPY bin /opt/conncalc/bin
COPY src /opt/conncalc/src
COPY rois /opt/conncalc/rois
COPY README.md /opt/conncalc

# Freesurfer needs sh to be bash not dash
#RUN ln -sf bash /bin/sh

# We need bash as the default shell
#ENV SHELL=/bin/bash

# Add pipeline to system path
ENV PATH=/opt/conncalc/src:/opt/conncalc/bin:${PATH}

# Extract CTF
RUN run_spm12.sh ${MATLAB_RUNTIME} function quit

# Entrypoint
ENTRYPOINT ["xwrapper.sh","conncalc.sh"]
