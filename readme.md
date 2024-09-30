
This is the code for our paper “Simple Alternating Minimization Provably Solves Complete Dictionary Learning” by Geyu Liang, Gavin Zhang, Solar Fattahi and Richard Y. Zhang. 

We focus on the noiseless complete dictionary learning problem, where our goal is to represent a set of given signals as linear combinations of a small number of atoms from a learned dictionary. Our proposed algorithm solves this problem using alternating minimization. The version implemented in this repo is Algorithm 2.3 in our paper. Roughly speaking, at each iteration we sample new samples and update our dictionary based not the new samples. Each iteration consists mainly of an SVD step and a hard thresholding step.

## Synthetic Dataset

To run the comparison between our method and other methods like l1 gradient based method and l4 maximization method, run comparison.m in the Synthetic Dataset folder in Matlab. Without clearing the workspace, one can draw Figure 3 in the paper by running drawplot_comparison.m. As for the Figure 4, one can run alg_minibatch and merge results from different p_total values.


## Real Dataset

The dataset we use in the [Landscape images dataset] (TheBlackMamba31, Landscape image colorization. https://www.kaggle.com/datasets/ theblackmamba31/landscape-image-colorization, accessed 2023.) To gauge the quality of our learned dictionary, we use our dictionary to perform a denoising and impainting task on our images. The precise experimental setup can be found in section 4.2 of our paper.

To use our method on the above dataset, simply run main.m in the Real Dataset folder in Matlab. The only extra dependency we require in SPAMS-2.6 for Matlab, which can be downloaded directly from this repo. The code will automatically output a montage of image denoising and image reconstruction examples. 

