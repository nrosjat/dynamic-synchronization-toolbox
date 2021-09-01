function [perm_test] = permuter(test,permutation) % permutations for certain number of clusters


perm_test = test;

for electrodes=1:42
    if perm_test(electrodes,1) >0
        perm_test(electrodes,1) = permutation(perm_test(electrodes,1));
    end
end

end