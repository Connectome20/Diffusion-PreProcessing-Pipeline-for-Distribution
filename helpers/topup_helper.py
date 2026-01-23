import os
def topup_commands(base_dir, subject, selected_flow, pa_volume_index, ap_volume_index):
    """
    Generate all the shell commands needed for TopUp, using user-specified volume indices
    for the PA and AP b0 volumes.
    """
    # Decide the input directory based on selected_flow
    input_dir = f"{base_dir}/{'s3_denoise_degibbs' if selected_flow == 'concat_denoise_degibbs' else 's3_degibbs'}"
    topup_dir_suffix = "s4_denoise_degibbs_topup" if selected_flow == "concat_denoise_degibbs" else "s4_topup"
    topup_dir = f"{base_dir}/{topup_dir_suffix}"
    os.makedirs(topup_dir, exist_ok=True)

    phase_encoding_file = f"{base_dir}/s1_concat/{subject}.phaseEncoding"
    dwi_file = f"{input_dir}/{subject}_dwi.nii.gz"
    pa_output_file = f"{topup_dir}/PA.nii.gz"
    ap_output_file = f"{topup_dir}/AP.nii.gz"
    b0s_output_file = f"{topup_dir}/b0s.nii.gz"

    # Example: retrieving the first AP index and last PA index from the phaseEncoding file
    # (You might or might not use this logic depending on your pipeline)
    cmd_get_indices = f"""
    encoding_values=$(cat {phase_encoding_file})
    index_for_firstAP=$(echo "$encoding_values" | tr ' ' '\\n' | grep -n -m 1 '1' | cut -d: -f1)
    index_for_lastPA=$(echo "$encoding_values" | tr ' ' '\\n' | tac | grep -n -m 1 '-1' | cut -d: -f1)
    echo $index_for_firstAP $index_for_lastPA
    """

    # Here is where we use pa_volume_index and ap_volume_index (passed from the GUI)
    cmd_pa = f"mrconvert {dwi_file} -coord 3 {pa_volume_index} {pa_output_file} -force"
    cmd_ap = f"mrconvert {dwi_file} -coord 3 {ap_volume_index} {ap_output_file} -force"

    # Combine AP and PA volumes into one 4D series
    cmd_mrcat = f"mrcat {ap_output_file} {pa_output_file} -axis 3 {b0s_output_file} -force"

    # Example paths for acqparams.txt and topup config
    acqparam_path = "/autofs/cluster/connectome2/Bay8_C2/TractCaliber_script/topup_eddy/acqparams.txt"
    config_path = "/autofs/cluster/connectome2/Bay8_C2/TractCaliber_script/topup_eddy/b02b0_yixin_421.cnf"
    imain_path = f"{topup_dir}/b0s.nii.gz"
    out_path = f"{topup_dir}/b0s_topup"
    iout_path = f"{topup_dir}/b0s_topup"
    fField_path = f"{topup_dir}/b0s_topup_field"
    fWarp_path = f"{topup_dir}/b0s_topup_warp"

    # TopUp command itself
    topup_cmd = (
        f"topup --imain={imain_path} "
        f"--datain={acqparam_path} "
        f"--config={config_path} "
        f"--out={out_path} "
        f"--iout={iout_path} "
        f"--fout={fField_path} "
        f"--dfout={fWarp_path}"
    )

    return [
        cmd_get_indices,
        cmd_pa,
        cmd_ap,
        cmd_mrcat,
        topup_cmd
    ]
