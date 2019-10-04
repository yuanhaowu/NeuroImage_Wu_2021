function Decoding(data_dir, labelnames, results_dir, radius)


% Path of the toolbox
addpath('d:\MATLAB\toolboxes\decoding_toolbox_v3.991\')
clear cfg
cfg = decoding_defaults;
cfg.software = 'SPM12';
% Specify where the results should be saved
cfg.results.overwrite     = 1;
cfg.results.dir           = results_dir;

% DATA SCALING
cfg.scale.method          = 'z';
cfg.scale.estimation      = 'all';

% SEARCHLIGHT SPECIFICATIONS
cfg.analysis              = 'searchlight';
cfg.searchlight.unit      = 'voxels';
cfg.searchlight.radius    = radius; 
cfg.searchlight.spherical = 0; %Ich hattes previously auf 1
cfg.verbose               = 1;  % (0: no output, 1: normal, output, 2: high output)

% Method and model parameters 
cfg.decoding.method = 'classification';
cfg.decoding.train.classification.model_parameters = '-s 0 -t 0 -c 1 -b 0 -q'; 

% OUTPUTS SPECIFICATION
cfg.results.output = {'accuracy', 'accuracy_minus_chance', 'sensitivity_minus_chance', ...
    'specificity_minus_chance', 'balanced_accuracy_minus_chance', 'confusion_matrix', 'AUC_minus_chance'};


%% DISPLAY:
cfg.plot_selected_voxels  = 0; % 0: no plotting, 1: every step, 2: every second step, 100: every hundredth step...

% This is by default set to 1, but if you repeat the same design again and again, it can get annoying...
cfg.plot_design           = 1;

% Subject specific Mask from Preprocessing
cfg.files.mask = fullfile(data_dir, 'mask.nii');


%% Decoding DESIGN


labels = [-1; 1];
regressor_names = design_from_spm(data_dir);

cfg = decoding_describe_data(cfg,labelnames,labels,regressor_names,data_dir);
% === Automatic Creation ===
% This creates the leave-one-run-out cross validation design:
cfg.design = make_design_cv(cfg);
display_design(cfg);

%% $ Run DECODING
results = decoding(cfg);
