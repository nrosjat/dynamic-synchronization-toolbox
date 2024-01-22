function [rplv] = pn_eeg_rPLV_single_trial(eegData, windowWidth, stepSize)
% Computes the relative Phase Locking Value (rPLV) for single-trial EEG data using a sliding window approach.
%
% Input parameters:
%   eegData is a 4D matrix numChannels x numTimePoints x numFreqs x numTrials
%   windowWidth is the width of the sliding window in number of time points.
%   stepSize is the step size for the sliding window in number of time points.
%
% Output parameters:
%   rplv is a 5D matrix - 
%     numWindows x numFreqs x numChannels x numChannels x numTrials
%
% Modifications for single trial and sliding window approach:
% - The function calculates PLV for each window separately for each trial.
%--------------------------------------------------------------------------
% 
% Written by:
% Nils Rosjat
% 19. Jan 2024

% Check for windowWidth and stepSize, set defaults if not provided
if ~exist('windowWidth', 'var')
    windowWidth = 50; % Default value for windowWidth
end

if ~exist('stepSize', 'var')
    stepSize = 10; % Default value for stepSize
end

% Validating the new parameters
if windowWidth <= 0 || stepSize <= 0
    error('Window width and step size must be positive integers');
end

numChannels = size(eegData, 1);
numTimePoints = size(eegData, 2);
numFreqs = size(eegData, 3);
numTrials = size(eegData, 4);

numWindows = ceil((numTimePoints - windowWidth + 1) / stepSize);
rplv = zeros(numWindows, numFreqs, numChannels, numChannels, numTrials);

for trialCount = 1:numTrials
    for freqCount = 1:numFreqs
        for channelCount = 1:numChannels-1
            channelData = squeeze(eegData(channelCount, :, freqCount, trialCount));
            for compareChannelCount = channelCount+1:numChannels
                compareChannelData = squeeze(eegData(compareChannelCount, :, freqCount, trialCount));
                windowIndex = 1;
                for windowStart = 1:stepSize:(numTimePoints - windowWidth + 1)
                    windowEnd = windowStart + windowWidth - 1;
                    windowPhaseDifference = channelData(windowStart:windowEnd) - compareChannelData(windowStart:windowEnd);
                    plv = abs(mean(exp(1i * windowPhaseDifference), 2));
                    rplv(windowIndex, freqCount, channelCount, compareChannelCount, trialCount) = plv;
                    windowIndex = windowIndex + 1;
                end
            end
        end
    end
end

return;
