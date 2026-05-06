% mris_error_exit.m

function mris_error_exit(errstr)
%MRIS_ERROR_EXIT  displays error message and exits MATLAB (used in batch mode)
%
% mris_error_exit(errstr)
%
%
% see also MRIS_ERROR_EXIT_ALT.

% jonathan polimeni <jonp@nmr.mgh.harvard.edu>, 2013/mar/31
% $Id: mris_error_exit.m,v 1.1 2013/03/31 20:14:51 jonp Exp $
%**************************************************************************%

  VERSION = '$Revision: 1.1 $';
  if ( nargin == 0 ), help(mfilename); return; end;


  %==--------------------------------------------------------------------==%

  FLAG__exit = 1;

  if ( FLAG__exit ),
    dispstr = ['ERROR! ', errstr];

    fprintf(1, '\n\n\n');
    fprintf(1, [repmat('-', [1, length(dispstr)]), '\n']);
    fprintf(1, [dispstr, '\n']);
    fprintf(1, [repmat('-', [1, length(dispstr)]), '\n']);
    fprintf(1, '\n\n\n');

    exit;

  else,
    % to allow for dbstop'ing and catch'ing, add a mode where a normal error is thrown
    error(errstr);
  end;

  return;


  %************************************************************************%
  %%% $Source: /space/repo/1/dev/dev/gradient_nonlin_unwarp/mris_error_exit.m,v $
  %%% Local Variables:
  %%% mode: Matlab
  %%% fill-column: 76
  %%% comment-column: 0
  %%% End:
