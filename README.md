# Dynamic Synchronization Toolbox (DST) 

This manual describes the usage of the Dynamic Synchronization Toolbox (DST). 

The toolbox presented here provides a MATLAB implementation of the pipeline for creating and graph theoretically analyzing dynamic networks as has been introduced in (Rosjat et al. (2021)).
The pipeline consists of three major steps: First, phase-locking values between two measuring sites, e.g. electrodes, are computed relative to a defined baseline period, 
second, the calculated connectivities are used to define dynamic graphs at the group level by testing for significant increase compared to baseline using t-tests and last, 
the dynamic graphs are analyzed using graph-theoretic measures from the BCT (Rubinov et al. 2010).

## Main Function

The main function of the DST is the `dynamic_synchronization_toolbox_function.m` located in the root directory. To access the functions of this toolbox you need to add this function and the `Scripts` subfolder to your MATLAB path. This function requires a set of options to be defined beforehand. A file `sample_settings.m` provides the standard settings needed to run the scripts.

## BST Pipeline

### Sample Data

To ensure sufficient quality control, a sample dataset of artificial data was added to the scripts, which has a high degree of connectivity in one condition and a low degree of connectivity in another condition. The script for creating the artificial subject data are located in the "Data" subfolder. Execution of this file will create a sample subject suitable to run the full pipeline.

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

-  graph.apply: False (Boolean for optional Graph Measures)
-  graph.pen: inf (overall penalty for community detection algorithm)
-  graph.clust_size: 0.9 (cluster size parameter for Louvain clustering)

## Support

For support, please open up an issue on github or get in contact with the authors via e-mail n.rosjat@fz-juelich.de.

## Licensing

DST is **BSD-licenced** (3 clause):

    This software is OSI Certified Open Source Software.
    OSI Certified is a certification mark of the Open Source Initiative.

    Copyright (c) 2022, Nils Rosjat.
    All rights reserved.

    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice,
      this list of conditions and the following disclaimer.

    * Redistributions in binary form must reproduce the above copyright notice,
      this list of conditions and the following disclaimer in the documentation
      and/or other materials provided with the distribution.

    * Neither the names of MNE-Python authors nor the names of any
      contributors may be used to endorse or promote products derived from
      this software without specific prior written permission.

    **This software is provided by the copyright holders and contributors
    "as is" and any express or implied warranties, including, but not
    limited to, the implied warranties of merchantability and fitness for
    a particular purpose are disclaimed. In no event shall the copyright
    owner or contributors be liable for any direct, indirect, incidental,
    special, exemplary, or consequential damages (including, but not
    limited to, procurement of substitute goods or services; loss of use,
    data, or profits; or business interruption) however caused and on any
    theory of liability, whether in contract, strict liability, or tort
    (including negligence or otherwise) arising in any way out of the use
    of this software, even if advised of the possibility of such
    damage.**


