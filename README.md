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

## Participant labels

The scripts use the anonymized participant IDs stored in the MAT files. To identify an individual shown in the manuscript, read each row below in display order (left to right, then top to bottom).

| Manuscript panel | Labels in the manuscript | Corresponding MAT participant IDs |
| --- | --- | --- |
| Fig. 6c and Supplementary Fig. 15a–c | S1, S2, S3, S4, S5, S6, S7, S8 | S4, S8, S3, S2, S7, S1, S5, S6 |
| Supplementary Fig. 11b | S1, S2, S3, S4, S5, S6, S7, S8 | S5, S6, S7, S4, S1, S2, S3, S8 |
| Supplementary Fig. 12c | Sub1, Sub2, Sub3, Sub4 | S2, S5, S9, S10 |
| Supplementary Fig. 13b | S1 (upper), S2 (lower) | S2 (circular correlation 0.6363), S5 (0.7669) |

## Images in Supplementary Fig. 9a

`Source_Data/sfig9a_quadrant_components.mat` contains the 100 original real-object photographs used in the experiment. The script displays 16 of these photographs, four per quadrant. The published panel uses substitute photographs. Supplementary Table 1 provides credits for those substitutes.
