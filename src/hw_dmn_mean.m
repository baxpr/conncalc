%% Study specific computation of mean network connectivity
% For HW_DMN_1 ROI set

% MATRIX output
matrix_file = '~/Downloads/conncalc/RMATRIX/R_removegm.csv';
C = readtable(matrix_file,'ReadRowNames',true);

% We will average over the list of DMN ROIs. First extract just this part
% of the matrix
dmnlist = { ...
    'r0005_DMN_PCC', ...
    'r0006_DMN_MPFC', ...
    'r0007_DMN_PAR_L', ...
    'r0008_DMN_PAR_R', ...
    'r0009_DMN_INFTEMP_L', ...
    'r0010_DMN_INFTEMP_R' ...
    };
Cdmn = table2array(C(dmnlist,dmnlist));

% Then extract just the upper triangle so we don't include the
% self-connections or duplicate values.
Clist = [];
for k1 = 1:size(Cdmn,1)-1
    for k2 = k1+1:size(Cdmn,2)
        Clist = [Clist Cdmn(k1,k2)];
    end
end

% And compute the mean of the extracted edges
mean_connectivity_dmn = mean(Clist);

