function [avg_rplv] = average_rplv(rplv,avg_freqs)
%average_rplv Computing the average of rplv over predefined frequency band
%
% Inputs:
%   rplv - relative phase-locking value [timepoints, frequencies, channels,
%   channels, conditions]
%   avg_freqs - list of frequencies used for averaging
%
% Outputs:
%   avg_rplv - relative phase-locking value averaged over frequency band
%   [timepoints, channels, channels, conditions]
%
%--------------------------------------------------------------------------   
try
rplv_freqs = rplv(:,avg_freqs,:,:,:);
avg_rplv = squeeze(mean(rplv_freqs,2));
catch
    disp('Interval of frequencies out of bounds')
end

end

