%%% List of all subject ids
    subjects=['Sub01';'Sub01';'Sub01';'Sub01';'Sub01';'Sub01';'Sub01'];%'Sub02'];
%%% List of electrodes of interest
    options.electrodes=[1:61];                      % all
%%% Time-interval in ms
    sampling_rate = 200;                            % sampling rate in Hz
    t_start = -1500;                                % epoch start
    t_end = 2495;                                   % epoch end
    t=t_start:1000/sampling_rate:t_end;             %epoch datapoints
%%% Frequencies of interest in Hz
    options.freqs = 1:7;
%%% Baseline for relative scaling of rPLV
    baseline_start = -1500;                         % start of baseline in ms
    baseline_end = -1000;                           % end of baseline in ms
    options.baseline = find(t==baseline_start):find(t==baseline_end)-1;   %baseline intervall for relative scaling

%%% Optional settings
    options.multiple_conds = true;                 % analysis of multiple conditions requires trial selection

    options.switch_hands = true;    % flipping right to left hand
    %%% define old set of channels and their mapping to new ones ----------
    options.channels_new = [1,2,32,35,33,34,3,7,36,39,4,6,37,38,40,43,8,11,41,42,9,10,12,16,44,47,13,15,45,46,48,52,18,21,49,51,19,20,22,26,53,56,23,25,54,55,27,31,57,61,58,60,28,30];
    options.channels_old = [2,1,35,32,34,33,7,3,39,36,6,4,38,37,43,40,11,8,42,41,10,9,16,12,47,44,15,13,46,45,52,48,21,18,51,49,20,19,26,22,56,53,25,23,55,54,31,27,61,57,60,58,30,28];
    %----------------------------------------------------------------------

    options.contrast = true;        % contrasting two conditions
    %%% define pair of conditions to be contrasted ------------------------
    options.contrast_conds = [1, 2];
    %----------------------------------------------------------------------
    
    options.averaging = true;      % averaging over frequency band
    %%% define freuencies to be considered for averaging rPLV -------------
    options.avg_freqs = 2:7;         
    %----------------------------------------------------------------------

%%% Settings for rPLV statistics

    %%% define setting for multiple statistics ----------------------------
    % ---------------------------------------------------------------------
    % FDR correction ------------------------------------------------------
    % 'original' - FDR correction combined for all electrodes
    % 'individual' - FDR correction for each electrode separately
    % 'uncorr' - uncorrected p-values
        stats.pid = 'original';   
        stats.pID_fix = 0.05;     %fixed p-value for corrected stats: 0.05;
        stats.p_fix = 0.05;       %fixed p-value for uncorrected stats: 0.05;
        stats.q_FDR = 0.05;       %q-value for FDR-correction
    % ---------------------------------------------------------------------
    % define type of statistical comparison -----------------------------
    % 'baseline' - test rplv vs artificial baseline
    % 'zero' - test rplv vs zero
        stats.comp = 'baseline';
    % ---------------------------------------------------------------------
    % define test interval ----------------------------------------------
        stats.test_interval_start=0; % in ms relative to stimulus
        stats.test_interval_end=1000; % in ms relative to stimulus
    % define baseline interval ----------------------------------------------
        stats.baseline_start=-1300; % in ms relative to stimulus
        stats.baseline_end=-100; % in ms relative to stimulus
        
    %----------------------------------------------------------------------
    % define task condition id, contrast appears as last task -----------
        stats.task = 1;
    %----------------------------------------------------------------------
    
    stats.time = t;
    stats.sampling_rate = sampling_rate;    

%%% Settings for graph measures

    %%% define setting for graph theoretic measures------------------------
    % ---------------------------------------------------------------------
    graph.apply = true;     %apply optional graph measures
    graph.pen = inf;        %overall penalty for community detection
    graph.clust_size = 0.9; %cluster size parameter for Louvain clustering    