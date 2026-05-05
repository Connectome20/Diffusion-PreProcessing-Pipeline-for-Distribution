#gncunwarp.sh
#
#!/bin/bash

Usage ()
{
    echo ""
    echo "Gradient nonlinearity correction for real data collected from Connectom A scanner. Expects to find input/output image in working directory if absolute path not specified."
    echo ""
    echo ""
    echo "Usage: gncunwarp.sh -i <infile> -o <outfile> -g <gradfile>[OPTION]"
    echo ""
    echo "Example:"
    echo "		gncunwarp.sh -i /data/T1.nii.gz -o /unwarp/T1_unwarp -g /gradcoil/coeff.grad"
    echo ""
    echo ""
    echo "REQUIRED ARGUMENTS"
    echo "  -i:       input <path>/<filename>; if <path> is not specified, it'll use the current directory."
    echo "  -o:       output <path>/<filename>; if <path> is not specified, it'll use the current directory."
    echo "  -g:       gradient coil coefficient <path>/<filename>; if <path> is not specified, it'll use the current directory."
    echo ""
    echo "OPTIONAL ARGUMENTS"
    echo "  -sd:      scripts_dir, path to write the generated matlab script of gnc. (default same as output file)"
    echo "  -interp:  interpolation method (nn,trilinear,sinc,spline; default spline )"
    echo ""
    echo ""
    exit 1
}

[ "$1" = "" ] && Usage

#parse option arguments
infilename="";
outfilename="";
gradient_name="";
gradfile_dir="";
scripts_dir="";
interpolation="spline";
datatype="";

while [ ! -z "$1" ]; do
	case "$1" in
		-i) file=$2;                       # infile_name
			infilename=`basename ${file} .gz`;
			infilename=`basename ${infilename} .nii`;
			infile_dir=`dirname ${file}`;
			shift;;    

		-o) file=$2;                       # outfile_name
			outfilename=`basename ${file} .gz`;
			outfilename=`basename ${outfilename} .nii`;
			outfile_dir=`dirname ${file}`;
			shift;;      

        -g) file=$2;                       # gradient_name
            gradient_name=`basename ${file} .grad`;
            gradfile_dir=`dirname ${file}`;
            shift;;
			
		-sd) scripts_dir=$2;               # scripts_dir
			shift;;
			
		-d) datatype="-d $2";
			shift;;
					
		-interp) interpolation=$2;         # interpolation: 
			shift;;  
		
		*) other=$other" "$1;;
	esac
	shift
	
done

[ "${scripts_dir}" = "" ] && scripts_dir=${outfile_dir};

# Fixed:
SCRIPT_TEMPLATE_DIR=$GNC_HOME; # path to template scripts
FSL507_DIR=$FSL_DIR;           # path to FSL 5.0.7

im=${outfilename};

if [ "${infilename}" = "" ] || [ "${outfilename}" = "" ] || [ "${gradient_name}" = "" ]; then
	Usage;
	
else
	
	nvols=`fslnvols ${infile_dir}/${infilename}`;
	
	if [ ${nvols} -eq 1 ]; then # single volume, such as T1, T2
		
		if [ ! -d ${scripts_dir} ]; then
			echo "\'${scripts_dir}\' does\'nt exist. Try to force make directory."; echo "";
			mkdir -p ${scripts_dir}
		fi
		echo scripts_dir: ${scripts_dir}; echo "";
		
		
		cmd="cat ${SCRIPT_TEMPLATE_DIR}/lib/gnc_matlab_cmd_template_v3_connectome2.m | sed s%'<infile_dir>'%${infile_dir}%g | sed s%'<outfile_dir>'%${outfile_dir}%g | sed s%'<gradfile_dir>'%${gradfile_dir}%g | sed s%'<infilename>'%${infilename}.nii.gz%g | sed s%'<outfilename>'%${outfilename}.nii.gz%g | sed s%'<gradient_name>'%${gradient_name}.grad%g > ${scripts_dir}/gnc_matlab_cmd_${im}.m";
		echo ${cmd}; echo ""; eval ${cmd};
		
		
		cmd="matlab -nojvm -nodisplay -nosplash < ${scripts_dir}/gnc_matlab_cmd_${im}.m";
		echo ${cmd}; echo ""; eval ${cmd};
		
		
		cmd="$FSL507_DIR/bin/applywarp -i ${infile_dir}/${infilename} -r ${infile_dir}/${infilename} -o ${outfile_dir}/${outfilename} -w ${outfile_dir}/${infilename}_deform_grad_rel.nii.gz --interp=${interpolation} ${datatype}";
		echo ${cmd}; echo ""; eval ${cmd};
		
	elif [ ${nvols} -gt 1 ]; then # multiple volumes, such as dwi, resting state
		
		
		if [ ! -d ${scripts_dir} ]; then
			echo "\'${scripts_dir}\' does\'nt exist. Try to force make directory."; echo "";
			mkdir -p ${scripts_dir}
		fi
		
		echo "Input is a 4D image, nvols = ${nvols}. Splitting the 1st volume..."
		cmd="fslroi ${infile_dir}/${infilename} ${outfile_dir}/${infilename}_1 0 1";
		echo "${cmd}"; echo ""; eval ${cmd};
		
		echo scripts_dir: ${scripts_dir}; echo "";
		
		
		cmd="cat ${SCRIPT_TEMPLATE_DIR}/lib/gnc_matlab_cmd_template_v3_connectome2.m | sed s%'<infile_dir>'%${outfile_dir}%g | sed s%'<outfile_dir>'%${outfile_dir}%g | sed s%'<gradfile_dir>'%${gradfile_dir}%g | sed s%'<infilename>'%${infilename}_1.nii.gz%g | sed s%'<outfilename>'%${outfilename}.nii.gz%g | sed s%'<gradient_name>'%${gradient_name}.grad%g > ${scripts_dir}/gnc_matlab_cmd_${im}.m";
		echo ${cmd}; echo ""; eval ${cmd};
		
		cmd="matlab -nojvm -nodisplay -nosplash < ${scripts_dir}/gnc_matlab_cmd_${im}.m";
		echo ${cmd}; echo ""; eval ${cmd};
		
		cmd="$FSL507_DIR/bin/applywarp -i ${infile_dir}/${infilename} -r ${outfile_dir}/${infilename}_1 -o ${outfile_dir}/${outfilename} -w ${outfile_dir}/${infilename}_1_deform_grad_rel.nii.gz --interp=${interpolation} ${datatype}";
		echo ${cmd}; echo ""; eval ${cmd};
		
		rm ${outfile_dir}/${infilename}_1.nii.gz
		
	fi
fi
