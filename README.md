# Response modality-dependent categorical choice representations for vibrotactile comparisons
Authors:        Yuan-hao Wu, Lisa A. Velenosi, Felix Blankenburg

Published in:   NeuroImage Volume 226, Feb.1., 2021 

https://doi.org/10.1016/j.neuroimage.2020.117592

## Abstract
Previous electrophysiological studies in monkeys and humans suggest that premotor regions are the primary loci for the encoding of perceptual choices during vibrotactile comparisons. However, these studies employed paradigms wherein choices were inextricably linked with the stimulus order and selection of manual movements. It remains largely unknown how vibrotactile choices are represented when they are decoupled from these sensorimotor components of the task. To address this question, we used fMRI-MVPA and a variant of the vibrotactile frequency discrimination task which enabled the isolation of choice-related signals from those related to stimulus order and selection of the manual decision reports. We identified the left contralateral dorsal premotor cortex (PMd) and intraparietal sulcus (IPS) as carrying information about vibrotactile choices. Our finding provides empirical evidence for an involvement of the PMd and IPS in vibrotactile decisions that goes above and beyond the coding of stimulus order and specific action selection. Considering findings from recent studies in animals, we speculate that the premotor region likely serves as a temporary storage site for information necessary for the specification of concrete manual movements, while the IPS might be more directly involved in the computation of choice. Moreover, this finding replicates results from our previous work using an oculomotor variant of the task, with the important difference that the informative premotor cluster identified in the previous work was centered in the bilateral frontal eye fields rather than in the PMd. Evidence from these two studies indicates that categorical choices in human vibrotactile comparisons are represented in a response modality-dependent manner.

## Scripts
Matlab codes for the main analysis of an fMRI experiment on decoding abstract decisions during vibrotactile comparisons using manual responses

Required software packages and toolboxes:
    SPM12 https://www.fil.ion.ucl.ac.uk/spm/software/spm12/
    The Decoding Toolbox (TDT) https://sites.google.com/site/tdtdecodingtoolbox/

Data availability
Subject-specific decoding accuracy maps are available at https://doi.org/10.6084/m9.figshare.9920111.v2, while the unthresholded statistical map derived from the group-level analysis can be inspected at https://www.neurovault.org/collections/5936/

### 1-level GLM:
GLM_1stLeve_batch.m

GLM_1stLevel_CorrectChoices.m

### Searchlight choice decoding  
Decoding_batch.m

Decoding.m

### Group-level one-sample t-test
OneSampe_t_test.m
