function [xa, length] = check_intervals(sig_ti_FDR, elecs)

%%%%%%%%%% collect intervals of coupling %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xa = cell(elecs,elecs);   % cell with start, end, length of coupling
length = cell(elecs,elecs);  % cell with length of coupling
for a=1:elecs
    for b=a+1:elecs
        % try to convert significant datapoints to epochs of timepoints
        try
            xa{a,b}(1,1) = sig_ti_FDR{a,b}(1,1);
            xa{a,b}(1,2) = sig_ti_FDR{a,b}(1,1);
            j=1;

            if (size(sig_ti_FDR{a,b},2)>1)
                for i=2:size(sig_ti_FDR{a,b},2)
                    x = sig_ti_FDR{a,b}(1,i);
                    if x-xa{a,b}(j,2)<6%11%25
                        xa{a,b}(j,2) = x;
                        length{a,b}(j,1) = (xa{a,b}(j,2)-xa{a,b}(j,1));
                    else 
                        j=j+1;
                        xa{a,b}(j,1)=x;
                        xa{a,b}(j,2)=x;
                        xa{a,b}(j-1,3) = (x-xa{a,b}(j-1,2))/5;
                        length{a,b}(j-1,1) = (xa{a,b}(j-1,2)-xa{a,b}(j-1,1));
                    end

                end
            end
        end
    end
end

end
