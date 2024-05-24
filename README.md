# Manifold-reconstruction-via-Gaussian-processes

These are the codes of the Manifold reconstruction via Gaussian processes(MrGap) algorithm and the datasets in the paper "INFERRING MANIFOLDS FROM NOISY DATA USING GAUSSIAN PROCESSES" by David B Dunson and Nan Wu

https://arxiv.org/abs/2110.07478

Explanation to files

1 Mfit1.m 

The denoising part of the algorithm corresponding to Algorithm 1 in the paper.

2 Mfit2.m

The interpolation part of the algorithmc orresponding to Algorithm 2 in the paper.

3 Cassini oval.mat

The Cassini Oval dataset in the Appendix. X is the noisy dataset. M11 is a large clean dataset on the curve in order to check the GRMSE defined in the paper.

4 RP3.mat

The RP3 dataset in the paper. X is the noisy dataset. M11 is a large clean dataset on the torus in order to check the GRMSE defined in the paper.

5 Spectrum.mat

The reflecatance spectra of the 86 wheat samples discussed in the paper.

