# Dynamic Connectivity Toolbox (DCT) 

This manual describes the usage of the Dynamic Connectivit Toolbox (DCT). 

The toolbox presented here provides a MATLAB implementation of the pipeline for creating and graph theoretically analyzing dynamic networks as has been introduced in (Rosjat et al. (2021)).
The pipeline consists of three major steps: First, phase-locking values between two measuring sites, e.g. electrodes, are computed relative to a defined baseline period, 
second, the calculated connectivities are used to define dynamic graphs at the group level by testing for significant increase compared to baseline using t-tests and last, 
the dynamic graphs are analyzed using graph-theoretic measures from the BCT (Rubinov et al. 2010).

## BCT Pipeline

### Sample Data

To ensure sufficient quality control, a sample dataset of artificial data was added to the scripts, which has a high degree of connectivity in one condition and a low degree of connectivity in another condition. The script for creating the artificial subject data are located in the "Data" subfolder.

### Compute rPLV

In the first step, the input data, that has been epoched and transformed to phase space prior application, undergoes a connectivity analysis based on the relative phase-locking value (rPLV).
Example data is provided in the subjects folder.

### Switch hands

Optionally, the scripts provide the possibility to switch recording channels in one condition. This might be useful in the case of bi-manual experimental settings that are highly lateralized, but should
be merged for the following steps. To use this option select options.switch_hands = true in the main file and provide information about mapping of the recording channels via options.channels_old and options.channels_new. 

### Contrasting

Optionally, two conditions might be contrastet (subtracted) against each other. To use this option select options.contrast = true in the main file and provide contrast condition information via options.contrast_conds.

### Average rPLVs

Compute the mean rPLV per frequency band. Frequencies to be averaged are selected by options.avg_freqs.

## Statistical differences to baseline

In the next step significant differences of the rPLV are calculated.

Parameters / options to be defined in this script:

-   stats.pid: 'original' (FDR correction combined for all electrodes), 'individual' (FDR correction for single electrodes), 'uncorr' (uncorrected statistics)
-   stats.pID_fix: 0.05 (fixed p-value for corrected stats)
-   stats.p_fix: 0.05 (fixed p-value for uncorrected stats)
-   stats.q_FDR: 0.05 (q-value for FDR-correction)
-   stats.comp: 'baseline' (sig. differences compared to baseline), 'zero' (sig. differences compared to zero)
-   stats.test_interval_start/end: Definition of test-interval in ms
-   stats.baseline_interval_start/end: Definition of baseline-interval in ms
-   stats.task: Selection of experimental task for statistics

## Graph Measures (optional: Brain-Connectivity-Toolbox)

In the last step the toolbox (optionally) computes a selection of graph theoretical measures provided by the Brain-Connectivity-Toolbox (Rubinov et al. 2010). Those measures are:

-  Aggregated graph
-  Betweennesse centrlaity
-  HUB nodes
-  Cluster detection (Louvain clustering)
-  Node flexibility
-  Node degree

Required options:

-  graph.pen: inf (overall penalty for community detection algorithm)
-  graph.clust_size: 0.9 (cluster size parameter for Louvain clustering)




