# Decoding vibrotactile choice independent of stimulus order and saccade selection during sequential comparisons
Yuan-hao Wu, Lisa A. Velenosi, Pia Schröder, Simon Ludwig, Felix Blankenburg. 2019 Human Brain Mapping
# Abstract
Decision-making in the somatosensory domain has been intensively studied using vibrotactile frequency discrimination tasks. Results from human and monkey electrophysiological studies from this line of research suggest that perceptual choices are encoded within a sensorimotor network. These findings, however, rely on experimental settings in which perceptual choices are inextricably linked to sensory and motor components of the task. Here, we devised a novel version of the vibrotactile frequency discrimination task with saccade responses which has the crucial advantage of decoupling perceptual choices from sensory and motor processes. We recorded human fMRI data from 32 participants while they performed the task. Using a whole-brain searchlight multivariate classification technique, we identify the left lateral prefrontal cortex and the oculomotor system, including the bilateral frontal eye fields (FEF) and intraparietal sulci, as representing vibrotactile choices. Moreover, we show that the decoding accuracy of choice information in the right FEF correlates with behavioral performance. Not only are these findings in remarkable agreement with previous work, they also provide novel fMRI evidence for choice coding in human oculomotor regions, which is not limited to saccadic decisions, but pertains to contexts where choices are made in a more abstract form.

## Scripts
Matlab codes for the main analysis of an fMRI experiment on decoding abstract decisions during vibrotactile comparisons

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
