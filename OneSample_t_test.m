clc; clear all;

% Participant identifier
SJs         = {'sj_01', 'sj_02', 'sj_03', 'sj_04', 'sj_05', 'sj_06', 'sj_07', 'sj_08', 'sj_09', 'sj_10',...
               'sj_11',          'sj_13',          'sj_15', 'sj_16', 'sj_17', 'sj_18', 'sj_19', 'sj_20',...
               'sj_21', 'sj_22'         , 'sj_24', 'sj_25', 'sj_26', 'sj_27', 'sj_28', 'sj_29', 'sj_30'};
           
%Set the fielpath of participants' decoding accuracy maps 
map_loc        = '';

%Set the group brain mask used for the analysis 
group_mask      = '';

%Set the output directory where data will be saved  
out_dir = '';
matlabbatch{1}.spm.stats.factorial_design.dir = {out_dir};

%%
fs_all=[];

for sj = 1:length(SJs)
    
    % Set the filter for normalized and smoothed daza
    filt    = '^sw';
    % select normalized and smoothed data
    f = spm_select('FPList', map_loc, filt);
    % create SPM style file list for model specification
    fs_all = [fs_all; cellstr(strcat(f, ',1'))];
   
end
% create SPM style file list for model specification
matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = cellstr(fs_all);
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 0;
matlabbatch{1}.spm.stats.factorial_design.masking.em = cellstr(group_mask);
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;

spm_jobman('run',matlabbatch);
clear matlabbatch

%% estimation
matlabbatch{1}.spm.stats.fmri_est.spmmat = {[out_dir filesep 'SPM.mat']};
matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;

spm_jobman('run',matlabbatch);
clear matlabbatch;

%% run the single contrast
matlabbatch{1}.spm.stats.con.spmmat(1)                  = {[out_dir filesep 'SPM.mat']};
matlabbatch{1}.spm.stats.con.consess{1}.tcon.name       = 'pos';
matlabbatch{1}.spm.stats.con.consess{1}.tcon.convec     = 1;
matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep    = 'none';
matlabbatch{1}.spm.stats.con.consess{2}.tcon.name       = 'neg';
matlabbatch{1}.spm.stats.con.consess{2}.tcon.convec     = -1;
matlabbatch{1}.spm.stats.con.consess{2}.tcon.sessrep    = 'none';
matlabbatch{1}.spm.stats.con.delete                     = 0;

spm_jobman('run',matlabbatch);
clear matlabbatch;
clear all; 