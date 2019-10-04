%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GLM specification and estimation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc; close all; clear all

% Set the filepath of analysis scripts
anal_dir     = '';
% Set the filepath of your pre-precessed fMRI data
data_dir     = '';

% Participants identifier 
SJs         = {'sj_01', 'sj_02', 'sj_03', 'sj_04', 'sj_05', 'sj_06', 'sj_07', 'sj_08', 'sj_09', 'sj_10',...
               'sj_11',          'sj_13',          'sj_15', 'sj_16', 'sj_17', 'sj_18', 'sj_19', 'sj_20',...
               'sj_21', 'sj_22',          'sj_24', 'sj_25', 'sj_26', 'sj_27', 'sj_28', 'sj_29', 'sj_30'};

% What conditions will be modelled?
model = 'CorrectChoices';                              
% regressors to account for CSF and WM noise?
use_CSFWM_params = 1;
% ArtRepair toolbox used?
use_ArtRepair = 0;
% determine the cut-off value for high-pass filter
myHPF = 192;

% subject specific number of sessions
runs        = 6*ones(1,length(SJs));
%% =======================================================================
for sj = 1:numel(SJs)
    display(['Model specification and modification for ' SJs{sj}])
    GLM_1stLevel_CorrectChoices(fullfile(data_dir, SJs{sj}),runs(sj), myHPF, use_CSFWM_params, use_ArtRepair);  
end
