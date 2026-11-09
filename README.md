# Neural-Representation-of-Synthetic-Objects

This repository contains MATLAB scripts and source data for the manuscript figures. Each script in `Analysis` loads the matching MAT file from `Source_Data`. Shared functions and their third-party license notices are in `function`.

## Run a figure

With Git LFS installed, clone the repository and download the Fig. 2f data:

```sh
git clone https://github.com/XieyiLiu/Neural-Representation-of-Synthetic-Objects.git
cd Neural-Representation-of-Synthetic-Objects
git lfs pull
```

From the repository root in MATLAB, run an individual figure script, for example:

```matlab
run(fullfile('Analysis', 'fig1d_naming_consistency.m'))
```

All 56 scripts were run in MATLAB R2024b. Fifty-three generate plots and three report statistics. Some manuscript panels also contain externally rendered brain surfaces, schematics, or manually assembled layouts.
