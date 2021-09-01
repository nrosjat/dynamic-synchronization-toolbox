function p_FDR = FDR_correct(p,q)

%--------------------------------------------------------------------------
% This function computes corrected p-values based on False Discovery Rate 
% (FDR) procedure.
%
%
% Syntax: function p_correct = FDR_correct(p,q)
% 
% Inputs:
%        p:
%           Vector of p-values.
%        q:
%           False Discovery Rate level.
%
% Outputs:
%        p_FDR:
%           P-value threshold based on independence or positive dependence
%           at FDR level of q.
%
%--------------------------------------------------------------------------
% Written by: 
%
% Nils Rosjat
% INM-3, FZJ
% Last edited: 31.03.2020
%--------------------------------------------------------------------------


p = sort(p(:));
N = length(p);
I = (1:N)';

p_FDR = p(find(p<=I/N*q, 1, 'last' ));

return

