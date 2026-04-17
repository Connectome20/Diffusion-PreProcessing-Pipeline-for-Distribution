# Diffusion Pre-Processing Pipeline: Connectome 2.0
The script to generate the diffusion pre-processing GUI can be downloaded as the file *diff_preproc_c2external.py*. Users will need to replace every instance of '/your/project/directory/’ in the GUI script with the path to their desired directory. 
'''
## Configuration File:

Users will need to replace every instance of ‘your project sequence’ in the config.json file with the specific or wild-carded names of sequences that they want to extract (e.g., *ep2d_diff_C2_D30_d6_64dirs*). Optionally, users can add custom labels (in the spot of ‘your custom label’) to differentiate diffusion sequences.

After editing the above, the *config.json* file must be saved to '/your/project/directory/bids/code/preprocessing_dwi/‘ (or another path of the user's choosing, which must be updated in the GUI script as well).

## Expert File (recon-all):

The *expertFile* file for recon-all must be saved to '/your/project/directory/bids/code/preprocessing_dwi/recon/‘ (or another path of the user's choosing, which must be updated in the GUI script as well).

## Rician Noise Correction File:

The file *rician_correct_mppca.sh* must be saved to '/your/project/directory/bids/code/preprocessing_dwi/‘ (or another path of the user's choosing, which must be updated in the GUI script as well).

## Sequence Specifications:

The GUI script uses the BIDS path input at the top to determine the sequence type. If “seqA” is in the path, then the sequence type will be set to A; the same follows for “seqB” and B. Users can edit the function 'get_sequence_type()' to determine the sequence type using an alternate method. 

Sequences A and B have arbitrarily set diffusion times (A: D33 d22, B: D11 d00). These should be updated to match the user's parameters. Users can search for the comment 'Replace with the D specific to your sequence' to locate this in the script.

## Volume Indices (topup):

The PA and AP volumes indices are set to 9 and 10, respectively. These fields can be edited within the script or in the GUI itself by users.

## Gradient Non-Linearity Correction:

The gradient non-linearity correction scripts are unable to be shared, so users must develop their own or skip this step. To input, save the script(s) under ‘/your/project/directory/bids/code/preprocessing_dwi/your_gnc_script.sh’ (or choose another path and edit accordingly). Then, replace ‘/your_gnc_script_A.sh’ and ‘/your_gnc_script_B.sh’ in the GUI script and in gnc_helper.py with the appropriate file path(s). Alternatively, users can circumvent gradient non-linearity correction by bypassing the button if pre-processing stepwise or by de-selecting the option at the bottom before running the entire script.
