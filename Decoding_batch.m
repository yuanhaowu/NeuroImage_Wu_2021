
% This Batch Script first specifies what features should be decoded and
% executes it. % The resulting ccuracy maps are normalized and smoothed

clc; close all; clear all;

%% specify source and output locations
use_CSFWM_params        = 1;
use_ArtRepair           = 0;
myHPF = 192;
GLMmodel = 'Choice';

% Directory
direct = 'd:\SFC_II\';
analysis_dir = fullfile(direct, 'DataAnalyses', 'SL_decoding');
addpath(analysis_dir);

% Specify searchlight radius (in voxel)
radius       = 4;

%specify the source folder
data_dir  = strcat( direct, 'data\');
if use_CSFWM_params == 1 && use_ArtRepair == 1
    GLM_name = fullfile([num2str(myHPF) 's'],'CSFWM_ArtRepair', GLMmodel);
elseif use_CSFWM_params == 1 && use_ArtRepair == 0
    GLM_name = fullfile([num2str(myHPF) 's'],'CSFWM_NoArtRepair', GLMmodel);
end

% Give a name for the deco
dec_name = fullfile('Searchlight', ['SVM_r' num2str(radius) 'vox'], GLM_name);

% subject identifiers
SJs         = {'sj_01', 'sj_02', 'sj_03', 'sj_04', 'sj_05', 'sj_06', 'sj_07', 'sj_08', 'sj_09', 'sj_10',...
               'sj_11',          'sj_13',          'sj_15', 'sj_16', 'sj_17', 'sj_18', 'sj_19', 'sj_20',...
               'sj_21', 'sj_22'         , 'sj_24', 'sj_25', 'sj_26', 'sj_27', 'sj_28', 'sj_29', 'sj_30'};

% name of the accuracy map resulting from the decoding analysis
name_map       = 'res_accuracy_minus_chance.nii';

%% ********************************************************************
%                       Searchlight Decoding
%**********************************************************************
% This part of the script locates beta images for for each choice ("higher"
% vs "lower") in each of the experimental run and then runs the decoding
% analysis


% cycle over subjects
for sj = 1:numel(SJs)
 
    sj_dir     = fullfile(data_dir, SJs{sj}, 'GLM_DecodingModels', GLM_name);
    results_dir = fullfile(data_dir, SJs{sj}, dec_name);
    if ~exist(results_dir, 'dir')
        mkdir(results_dir);
    end
    cd(results_dir)
    
    labelnames = {'higher', 'lower'};
    
    disp(['SUBJECT: ' SJs{sj}]);
    % Here the Searchlight Decoding is called and executed
    Decoding(sj_dir, labelnames, results_dir, radius);
    disp('Finished');
    close all
end



%% ****************************************************************
% %    Normalization (+ Smoothing) of the mean accuracy Maps to MNI
% % *****************************************************************
%
% Loop over subjects, images for visual trials
for sj = 1:numel(SJs)
    
    %     % Select Parameter files for Normalization
    struct_dir = fullfile(data_dir, SJs{sj}, 'T1');
    filt1    = '^y_.*\.nii$';
    f1 = spm_select('FPList', struct_dir, filt1);
    
    % Select accuracy maps
    fs_all = [];
    % realigned and slice time corrected EPI volum filter
    filt    = name_map;
    
    
    % Source directory for the 'mean'-images
    sj_dir =  fullfile(data_dir, SJs{sj}, dec_name);
    % select the files
    f = spm_select('FPList', sj_dir, filt);
    % create SPM style file list for model specification
    fs_all = strcat(f, ',1');
  
    
    %Assigne Normalization Parameter to job struct
    matlabbatch{1}.spm.spatial.normalise.write.subj.def = cellstr(f1);
    matlabbatch{1}.spm.spatial.normalise.write.subj.resample = cellstr(fs_all);
    matlabbatch{1}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -50
        78 76 85];
    matlabbatch{1}.spm.spatial.normalise.write.woptions.vox = [2 2 2];
    matlabbatch{1}.spm.spatial.normalise.write.woptions.interp = 4;
    matlabbatch{1}.spm.spatial.normalise.write.woptions.prefix = 'w';
    
    % Execute Normalization
    fprintf(['Normalizing ', SJs{sj}, '\n']);
    spm_jobman('run', matlabbatch)
    clear matlabbatch
end

clear fs_all f filt
% =========================================================================
for sj = 1:numel(SJs)
    % SMOoTHING  for visual trials
    fs_all = [];
    
    %for bin = bins
    % realigned and slice time corrected EPI volum filter
    filt    = ['^w' name_map];
    

        % Source directory for the 'mean'-images
        sj_dir =  fullfile(data_dir, SJs{sj}, dec_name);
        % select the files
        f = spm_select('FPList', sj_dir, filt);
        % number of volumes
        numVols = size(f,1);
        % create SPM style file list for model specification
        fs_all = [fs_all; cellstr([f repmat(',1', numVols, 1)])];
  
    
    % Specify smoothing parameter
    matlabbatch{1}.spm.spatial.smooth.data = cellstr(fs_all);
    matlabbatch{1}.spm.spatial.smooth.fwhm = [3 3 3];
    matlabbatch{1}.spm.spatial.smooth.dtype = 0;
    matlabbatch{1}.spm.spatial.smooth.im = 0;
    matlabbatch{1}.spm.spatial.smooth.prefix = 's';
    
    % Execute Smooting
    fprintf(['Smoothing ', SJs{sj}]);
    spm_jobman('run', matlabbatch)
    clear matlabbatch
end


clear all; clc;