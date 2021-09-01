function [rplv_flip] = switch_hands_function(rplv,conds,channels_new, channels_old)

%--------------------------------------------------------------------------
%----- Script for flipping right hand channels to left hand ---------------
%--------------------------------------------------------------------------
%
% First step: Flipping right hand electrodes to left hand electrodes
% electrode pairs to be switched defined in channels_new and channels_old
% Second step: Averaging between left and right hand
% Third step (optional): Contrasting between conditions defined in contrast
%
%--------------------------------------------------------------------------
        
        try   
            rplv_flip = zeros(size(rplv,1),size(rplv,2),size(rplv,3),size(rplv,4),conds/2);
        catch
            disp('Number of conditions needs to be even for mapping hands!')
        end

        

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%% Switch hands %%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        for cond = 1: conds/2
            disp(['Condition ' num2str(cond)])

            rplv_left = squeeze(rplv(:,:,:,:,2*cond-1));
            rplv_right = squeeze(rplv(:,:,:,:,2*cond));
            rplv_right_flip = rplv_right + permute(rplv_right,[1 2 4 3]);    % permute conditions
            try
                rplv_right_flip(:,:,channels_new,:) = rplv_right_flip(:,:,channels_old,:); % flip channels rows
                rplv_right_flip(:,:,:,channels_new) = rplv_right_flip(:,:,:,channels_old); % flip channels columns

                rplv_flip(:,:,:,:,cond) = (rplv_left + rplv_right_flip)/2;
            catch
                disp('You need to specify channels for switching hands!')
            end
        end
        
        rplv_flip = squeeze(rplv_flip);
end
