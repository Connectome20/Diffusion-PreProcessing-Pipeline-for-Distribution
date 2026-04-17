# Diffusion Pre-Processing Pipeline: Connectome 2.0
The script to generate the diffusion pre-processing GUI can be downloaded as the file *diff_preproc_c2external.py*. Users will need to replace every instance of '/your/project/directory/’ in the GUI script with the path to their desired directory. 

## Configuration File:

Users will need to replace every instance of ‘your project sequence’ in the config.json file with the specific or wild-carded names of sequences that they want to extract (e.g., *ep2d_diff_C2_D30_d6_64dirs*). Optionally, users can add custom labels (in the spot of ‘your custom label’) to differentiate diffusion sequences.

After editing the above, the *config.json* file must be saved to '/your/project/directory/bids/code/preprocessing_dwi/‘ (or another path of the user's choosing, which must be updated in the GUI script as well).

## Expert File (recon-all):

The *expertFile* file for recon-all must be saved to '/your/project/directory/bids/code/preprocessing_dwi/recon/‘ (or another path of the user's choosing, which must be updated in the GUI script as well).

## Rician Noise Correction File:

The file *rician_correct_mppca.sh* must be saved to '/your/project/directory/bids/code/preprocessing_dwi/‘ (or another path of the user's choosing, which must be updated in the GUI script as well).

## Sequence Specifications:
Users must enter the big delta (variable 'big_delta') and little delta (variable 'little_delta') values that correspond to their diffusion sequences. 

## Volume Indices for TopUp:

The PA- and AP-volume indices are set to 9 and 10, respectively, for TopUp processing. These fields can be edited within the script ("search for 'Default value is "9"') or at the bottom of the GUI itself by users.

## Gradient Non-Linearity Correction:

Users must save the gradient non-linearity correction scripts must save under ‘/your/project/directory/bids/code/preprocessing_dwi/hcps_gnc_c2.sh’ (or choose another path and edit accordingly). However, the Siemens gradient coil coefficients may not be shared publicly, so users must obtain and enter their own gradient files into the following files: (***). Users can circumvent gradient non-linearity correction by bypassing the button if pre-processing stepwise or by de-selecting the option at the bottom before running the entire script.
