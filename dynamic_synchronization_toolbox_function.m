function [rplv, trials, rplv_mean, sig_ti, xa, length, Agg, bet, hub, clusters, node_flex, deg] = dynamic_synchronization_toolbox_function(subjects,options, stats, graph)

%--------------------------------------------------------------------------
%
%     Main procedure of the dynamic plv toolbox
%
%--------------------------------------------------------------------------
%
% This toolbox provides a MATLAB implementation of the pipeline for
% creating and graph theoretically analyzing dynamic networks as has been
% introduced by (Rosjat et al. (2021)). The pipeline consists of three
% major steps:
%
% 1. Phase-locking value calculation between pairs of measurement sites.
% This step is performed by func_rplv(subjects,options). 
%
% Inputs: - subjects: List of subject IDs / subfolders of the Data folder
%            - data is expected for each subject with ID sub_id as sub_id.mat located in Data/sub_id
%            - data should be pre-processed and transformed to time-frequency domain
%            - dimensions: (electrodes, frequencies, time, conditions)
%
%         - options: structure defining the options for rPLV calculation.
%            - electrodes: (sub)set of electrodes to consider for analysis (default: [1:61])
%            - freqs: frequency range for analysis (default: 1:7)
%            - baseline: baseline used for relative scaling of PLV (default: -1500:-1000 ms)
%            - multiple_conds: Option for experimental tasks with multiple
%            (i.e. >1) conditions (default: True)
%            - switch_hands: Option to map electrodes of second condition,
%            e.g. for switching hemispheres in motor tasks, (default: True)
%            - channels_new: In case of switching hands, definition of new
%            order of channel ids (default:
%            [1,2,32,35,33,34,3,7,36,39,4,6,37,38,40,43,8,11,41,42,9,10,12,16,44,47,13,15,45,46,48,52,18,21,49,51,19,20,22,26,53,56,23,25,54,55,27,31,57,61,58,60,28,30];)
%            - channels_old: In case of swtiching hands, original set of
%            channel ids (default: [2,1,35,32,34,33,7,3,39,36,6,4,38,37,43,40,11,8,42,41,10,9,16,12,47,44,15,13,46,45,52,48,21,18,51,49,20,19,26,22,56,53,25,23,55,54,31,27,61,57,60,58,30,28];
%            - contrast: Option for contrasting two conditions, (default:
%            True)
%            - contrast_conds: Selection of contrasting conditions in the
%            form [a, b] representing a - b, (default: [1,2])
%            - averaging: Option for averaging rPLV across frequencies
%            (default: True)
%            - avg_freqs: Set of frequencies for rPLV averaging (default:
%            [2:7])
%
% 2. Define Dynamic Graph based on rPLV statistics
% This step is performed by stats_rplv(rplv,stats)
%
% Inputs:   - Computed rPLV from Step 1
%            - stats: structure defining the options for statistics
%               - FDR correction ----------------------------------------
%                - pid:
%                   - 'original' - FDR correction combined for all electrodes
%                   - 'individual' - FDR correction for each electrode separately
%                   - 'uncorr' - uncorrected p-values
%                   - pID_fix -fixed p-value for corrected stats: 0.05;
%                   - p_fix - fixed p-value for uncorrected stats: 0.05;
%                   - q_FDR - q-value for FDR-correction
%               - comp:
%                   - 'baseline' - test rplv vs artificial baseline
%                   - 'zero' - test rplv vs zero
%               - test_interval_start: onset intervall of intereset
%               - test_interval_end: offset intervall of intereset
%               - baseline_start: onset baseline
%               - baseline_end: offset baseline
%               - task: task id for stats
%               - time: time intervall of epoch
%               - sampling_tate: sampling rate of data
%
% 3. Computer dynamic graph metrics
% This step is performed by graph_measures(xa,stats,graph)
%
% Inputs: Dynamic graphs from step 2
%             - graphs: structure defining the options for graph measures 
%               -apply: boolean for optional use of graph measures
%               -pen: overall penalty for community detection
%               - clust_size: cluster size parameter for Louvain clustering    
% 
%
% Output variables: 
%         -   rplv - relative phase-locking value for each subject in a cell
%         {num. subjects,1}, each cell stores the rplv with [time, channel, channel, conditions] 
%         -   trials - number of trials in each condition for each subject
%         -   rplv_mean - group average of rPLV [time, channel, channel, conditions]
%         -   sig_ti_FDR  - significant timepoints after statistics - cell [channel, channel]
%         -   xa - cell [channel, channel], each channel pair contains a
%         list of significant intervals [#intervals, 3] - start, stop,
%         timepoints gap to next interval
%         -   length - cell [channel, channel], each channel pair contains a
%         list of length of intervals
%
%         Optional: Graph metrics (see Rubinov M, Sporns O (2010)
%         NeuroImage 52:1059-69)
%
%         -   Agg - aggregated graph showing frequency of all connections
%         over the whole interval [channel, channel]
%         -   bet - temporal betweenness centrality [timepoint, channel]
%         -   hub - temporal hub nodes [timepoint, 2]
%         -   clusters - [channel, timepoints] cluster assignment for each
%         channel and timepoint
%         -   node_flex - [2, channels] node flexibility for each channel
%         -   deg - [timepoints, channel] node degree over time for each channel
%

%--------------------------------------------------------------------------
%
% Written by:
% Nils Rosjat
% Forschungszentrum Juelich (INM-3)
% 06.05.2022
%
%--------------------------------------------------------------------------


    
main_path = pwd;

if(isunix)   %just to use the right symbol for the path                                                                           
    symb='/';
    options.symb = symb;
else
    symb='\'; 
    options.symb = symb;
end 


data_path = ([main_path symb 'Data' symb]);
script_path = ([main_path symb 'Scripts' symb]);
addpath(genpath(script_path));    
    
[rplv, trials,rplv_mean] = func_rplv(subjects,options);



[sig_ti,xa,length] = stats_rplv(rplv,stats);

if graph.apply
    [Agg, bet, hub, clusters, node_flex, deg] = graph_measures(xa,stats,graph);
end

end %clearvars -except rplv trials rplv_mean sig_ti xa length Agg bet hub clusters node_flex deg
