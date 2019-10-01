%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GLM specification and estimation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc; close all; clear all

% define data and analysis directory
anal_dir     = 'd:\SFC_II\DataAnalyses\GLM\Decoding';
data_dir     = 'd:\SFC_II\data';
addpath(anal_dir);
cd(anal_dir)

% What should be decoded?

models = {'CorrectChoices'};                              
selected = 1;
% regressors to account for CSF and WM noise?
use_CSFWM_params = 1;
% ArtRepair toolbox used?
use_ArtRepair = 0;
% determine the cut-off value for high-pass filter
myHPF = 192;

SJs         = {'sj_01', 'sj_02', 'sj_03', 'sj_04', 'sj_05', 'sj_06', 'sj_07', 'sj_08', 'sj_09', 'sj_10',...
               'sj_11',          'sj_13',          'sj_15', 'sj_16', 'sj_17', 'sj_18', 'sj_19', 'sj_20',...
               'sj_21', 'sj_22',          'sj_24', 'sj_25', 'sj_26', 'sj_27', 'sj_28', 'sj_29', 'sj_30'};
                     

if use_CSFWM_params == 1 && use_ArtRepair == 1
    analysis_name   = fullfile('GLM_DecodingModels', [num2str(myHPF) 's'], 'CSFWM_ArtRepair', models{selected});
elseif use_CSFWM_params == 1 && use_ArtRepair == 0
    analysis_name   = fullfile('GLM_DecodingModels', [num2str(myHPF) 's'], 'CSFWM_NoArtRepair', models{selected});
elseif use_CSFWM_params  == 0 && use_ArtRepair == 1
    analysis_name   = fullfile('GLM_DecodingModels', [num2str(myHPF) 's'], 'NoCSFWM_ArtRepair', models{selected});
elseif use_CSFWM_params  == 0 && use_ArtRepair == 0
    analysis_name   = fullfile('GLM_DecodingModels', [num2str(myHPF) 's'], 'NoCSFWM_NoArtRepair', models{selected});
end

% subject specific number of sessions
runs        = 6*ones(1,length(SJs)); %runs(31)    = 5;
%% =======================================================================
for sj = 1:numel(SJs)
    display(['Model specification and modification for ' SJs{sj}])
    GLM_1stLevel_choices(fullfile(data_dir, SJs{sj}),runs(sj), analysis_name, myHPF, use_CSFWM_params, use_ArtRepair);  
end
