# gnc_anat_helper.py

import os

def gnc_anat_commands(subject, anat_process_dir, image_to_run_gnc_dir, gnc_anat_option):
    input_file = image_to_run_gnc_dir
    output_dir = f"{anat_process_dir}/s1_gnc"
    os.makedirs(output_dir, exist_ok=True)
    output_file = f"{output_dir}/{subject}_T1w.nii.gz"
    
    path = '/your/project/directory/bids/code/preprocessing_dwi/'
    script_name = "your_gnc_script_A.sh" if gnc_option == "A" else "your_gnc_script_B.sh"
    
    cmd = (
        f"{path}/{script_name} -i {input_file} -o {output_file} "
        "-interp spline"
    )
    return cmd
