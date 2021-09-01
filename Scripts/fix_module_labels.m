
function fixed_labels = fix_module_labels(M,interv)

%--------------------------------------------------------------------------
%----- Script for optimizing community numbering to minimize switches -----
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Written by: 
%
% Nils Rosjat
% INM-3, FZJ
% Last edited: 30.01.2020
%--------------------------------------------------------------------------


M_orig = M;
pen=0;

if size(interv,2) > 3
    for time=3:size(interv,2)
        test = M(:,time);
        prev = M(:,time-1);
        pen(1,time)=penalty(test,prev);
        pen(2,time)=0;
        x = unique(test);
        y = unique(prev);
        x = 1:max(max(x),max(y));
        P = perms(x);
        nperms = size(P,1);
        for perm = 1:nperms
           permutation = P(perm,:);
           perm_test = permuter(test,permutation);
           new_pen = penalty(perm_test,prev);
           if new_pen < pen(1,time) % if current permutation is better than before -> replace
               pen(1,time) = new_pen;
               pen(2,time) = perm;
               M(:,time) = perm_test;
           end
        end

    end
end

fixed_labels = M;
