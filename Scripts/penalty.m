function [pens] = penalty(test, prev) % define penalty as number of switches

pens = 0;
       for el = 1:42
        test_clust_el = test(el,1);
        prev_clust_el = prev(el,1);
        
        if test_clust_el ~= 0
            if prev_clust_el ~= 0
                if test_clust_el ~= prev_clust_el
                    pens = pens+1;
                end
            end
            pens = pens + test_clust_el;
        end
    end 
end