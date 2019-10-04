function GLM_1stLevel_CorrectChoices(data_dir,sessions, myHPF, CSFWM, ArtRepair)

% set SPM defaults
spm('defaults','fmri')
spm_jobman('initcfg');

% create an output directory
out_dir = [data_dir, filesep, ''];
if ~exist(out_dir, 'dir')
    mkdir(out_dir)
end
display(['save data to ' out_dir])
cd(out_dir)
jobs{1}.stats{1}.fmri_spec.dir = cellstr(fullfile(data_dir, name));

% Model Specification
% -------------------------------------------------------------------------
% condition names
condnames = {'High', 'Low'};

%% allocate the data per session
% load the participant log_file
logfile = spm_select('FPList', data_dir, '^fMRI_.*\.mat$');
load(logfile);
clear onsets;


for s = 1:sessions
    src_dir =  fullfile(data_dir, ['run0' num2str(s)]);
    
    if ArtRepair
        EPIs = spm_select('FPList',src_dir, '^ragf.*\.(nii|img)$');
    else
        EPIs = spm_select('FPList',src_dir, '^raf.*\.(nii|img)$');
    end
    
    jobs{1}.stats{1}.fmri_spec.sess(s).scans     = cellstr([EPIs, repmat(',1', size(EPIs,1),1)]);
    % timing parameters
    jobs{1}.stats{1}.fmri_spec.timing.units     = 'secs';
    jobs{1}.stats{1}.fmri_spec.timing.RT        = 2;
    jobs{1}.stats{1}.fmri_spec.timing.fmri_t    = 16;
    % changed t0 from something to 8... i think from 0?
    jobs{1}.stats{1}.fmri_spec.timing.fmri_t0   = 8;
    jobs{1}.stats{1}.fmri_spec.sess(s).hpf      = myHPF;
    
    
    %***************************************************************************************************************
    % find trials in which the comparison frequency was correctly evaluated as
    % 'higher', for f1 and f2 respectively.
    % f1
    f1high_idx  = mylog.design(5,:,s)==1 & mylog.flutter(s,:,1)>mylog.flutter(s,:,2) & mylog.perform_double(s,:)==1;
    % f2
    f2high_idx  = mylog.design(5,:,s)==2 & mylog.flutter(s,:,2)>mylog.flutter(s,:,1) & mylog.perform_double(s,:)==1;
    %****************************************************************************************************************
    % the same for correct 'lower' answers
    % f1
    f1low_idx  = mylog.design(5,:,s)==1 & mylog.flutter(s,:,1)<mylog.flutter(s,:,2) & mylog.perform_double(s,:)==1;
    % f2
    f2low_idx  = mylog.design(5,:,s)==2 & mylog.flutter(s,:,2)<mylog.flutter(s,:,1) & mylog.perform_double(s,:)==1;
    %****************************************************************************************************************
    incorrect_idx = mylog.perform_double(s,:) ~=1;
    
    % explanation for mylog.timing:
    % row1:     ITI onsets + 2 s
    % row2:     rule cue onsets (start of each trial)
    % row3:     f1 onsets
    % row4:     f2 onsets
    % row5:     decision phase onsets
    % row6:     matching cue onsets
    % row7:     targets onsets
    % row8:     end of the trial + additional time for saving and reloading the
    %           stimulator
    
    
    % determine the onsets of decision phase for "Higher"
    f1_high = mylog.timing(5,f1high_idx,s);
    f2_high = mylog.timing(5,f2high_idx,s);
    onsets = sort([f1_high f2_high]);
    jobs{1}.stats{1}.fmri_spec.sess(s).cond(1).name     = condnames{1};
    jobs{1}.stats{1}.fmri_spec.sess(s).cond(1).onset    = onsets;
    jobs{1}.stats{1}.fmri_spec.sess(s).cond(1).duration = 0;
    clear onsets f1_high f2_high;
    
    % determine the onsets of decision phase for "Lower"
    f1_low = mylog.timing(5,f1low_idx,s);
    f2_low = mylog.timing(5,f2low_idx,s);
    onsets = sort([f1_low f2_low]);
    jobs{1}.stats{1}.fmri_spec.sess(s).cond(2).name     = condnames{2};
    jobs{1}.stats{1}.fmri_spec.sess(s).cond(2).onset    = onsets;
    jobs{1}.stats{1}.fmri_spec.sess(s).cond(2).duration = 0;
    clear onsets f1_low f2_low;
    
    % Missing or incorrect trials
    if any(incorrect_idx)
        onsets = mylog.timing(5,incorrect_idx,s);
        jobs{1}.stats{1}.fmri_spec.sess(s).cond(3).name     = 'Incorrect';
        jobs{1}.stats{1}.fmri_spec.sess(s).cond(3).onset    = onsets;
        jobs{1}.stats{1}.fmri_spec.sess(s).cond(3).duration = 0;
        clear onsets;
    end
    
    %% add head motion (6) and/or CSF&WM (5+5) regressors
    
    if CSFWM
        CSF = spm_select('FPList', [data_dir '\Rdata_PCA_4mm9090'], ['^run0' num2str(s) '_csf.mat']);
        WM  = spm_select('FPList', [data_dir '\Rdata_PCA_4mm9090'], ['^run0' num2str(s) '_wm.mat']);
    end
    
    if ArtRepair
        mf = spm_select('FPList', src_dir, '^rp_agf.*\.txt$');
    else
        mf = spm_select('FPList', src_dir, '^rp_af.*\.txt$');
    end
    
    
    if CSFWM
        jobs{1}.stats{1}.fmri_spec.sess(s).multi_reg   = {CSF; WM; mf};
    else
        jobs{1}.stats{1}.fmri_spec.sess(s).multi_reg   = {mf};
    end
    
    
    
end
%% additional model parameters
% no factorial design
jobs{1}.stats{1}.fmri_spec.fact = struct('name', {}, 'levels', {});
% model hrf and first temporal derivative
jobs{1}.stats{1}.fmri_spec.bases.hrf.derivs     = [0 0];
% model interactions
jobs{1}.stats{1}.fmri_spec.volt                 = 1;
% global normalization
jobs{1}.stats{1}.fmri_spec.global               = 'None';
% masking
jobs{1}.stats{1}.fmri_spec.mask                 = {''};
% autocorrelation modelling (whitening filter)
jobs{1}.stats{1}.fmri_spec.cvi                  = 'AR(1)';

% create the model
fprintf('Creating GLM\n')
spm_jobman('run', jobs);

% clear job variable
clear jobs

% %  Model Estimation
% % -------------------------------------------------------------------------
load(fullfile(data_dir, name, filesep, 'SPM.mat'));
fprintf('Estimating GLM \n');
cd([data_dir, filesep, name, filesep]);
SPM = spm_spm(SPM);

clear SPM;
%cd(data_dir);

