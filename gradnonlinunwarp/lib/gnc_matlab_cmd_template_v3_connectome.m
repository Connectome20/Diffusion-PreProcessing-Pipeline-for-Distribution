% gnc_matlab_cmd_template_v3_connectome.m

% this is a template matlab script for hcps_preproc
% first created by Q.F. 11/21/2013 
% 2014/05/05: output gradient deviation (*_grad_dev.nii.gz) which can be later used
% to correct bvecs due to gradient nonlinearity effects.
% Qiuyun Fan <qfan@nmr.mgh.harvard.edu>, 
%

if isdeployed==0
    clear all; close all;

    fshome = getenv('FREESURFER_HOME');
    addpath(fullfile(fshome,'matlab'));   
    gnchome = getenv('GNC_HOME');
    addpath(fullfile(gnchome,'lib'));
	
	
end

infile_dir = '<infile_dir>';
infilename = '<infilename>';
outfile_dir = '<outfile_dir>';
outfilename = '<outfilename>';
gradfile_dir = '<gradfile_dir>';    % HHL, Feb 8, 2026
gradient_name = '<gradient_name>';   % HHL, Feb 8, 2026

fname_disco_in = strcat(infile_dir,filesep,infilename);
fname_disco_out = strcat(outfile_dir,filesep,outfilename);
gradient_name = strcat(gradfile_dir,filesep,gradient_name);


OPTION__polarity='UNDIS';
OPTION__calc_method='direct'; %%%%ALTERNATIVE: LOOKUP-> FASTER BUT LESS ACCURATE
OPTION__jacobian_correct='0';
OPTION__interp='cubic';
OPTION__JacDet_output='1';
OPTION__Displacement_output='1';
OPTION__grad_dev_output='1';

tic
mris_gradient_nonlin__unwarp_volume__batchmode_HCPS_v3(fname_disco_in,fname_disco_out,...
    gradient_name,OPTION__polarity,OPTION__calc_method,OPTION__jacobian_correct,...
    OPTION__interp,OPTION__JacDet_output,OPTION__Displacement_output,'',OPTION__grad_dev_output);	
disp('nonlinear correction finished.')
toc

exit;
