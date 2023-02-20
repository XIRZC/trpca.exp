# Tensor Robust Principal Component Analysis with Convex Optimization 

This is a repository of simple TRPCA experiments including image denoising and video background modeling, and most of codes are copied from [Lu Canyi's TRPCA Github Repo](https://github.com/canyilu/Tensor-Robust-Principal-Component-Analysis-TRPCA) with some adaptions.

![](./resources/banner.png)

## Usage

Open MATLAB and select the subfolder `./trpca` as root workspace, and run `./trpca/rgb_image_denoising_task.m`, `./trpca/video_background_modeling_task.m` for two applications, respectively.

And then you would see the logs printed on MATLAB command pane, and know where the visualization results are saved to.

## Applications

There are mainly two TRPCA applications leveraged in this repo:
- RGB image denoising
- RGB video background modeling

### RGB Image Denoising

![](./resources/image_denoising_example_2.png)

### RGB Video Background Modeling

![](./resources/background_modeling_example_1.png)

## References

There are mainly several related works about this repo:

1. Wright et al. - NeurIPS 2009 - Robust Principal Component Analysis: Exact Recovery of Corrupted Low-Rank Matrices via Convex Optimization
2. Candès et al. - JACM 2011 - Robust principal component analysis?
3. Lu et al. - CVPR 2016 - Tensor Robust Principal Component Analysis: Exact Recovery of Corrupted Low-Rank Tensors via Convex Optimization
4. Lu et al. - TPAMI 2020 - Tensor Robust Principal Component Analysis with A New Tensor Nuclear Norm

## Miscellaneous

You can refer to Lu Canyi's [personal homepage](https://canyilu.github.io/), [github homepage](https://github.com/canyilu) and [google scholar homepage](https://scholar.google.com/citations?user=EZcKJi4AAAAJ&hl=en) to find more related and interesting works about various mathematics theorm applied to Computer Science.