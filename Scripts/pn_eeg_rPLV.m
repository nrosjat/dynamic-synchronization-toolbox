function [rplv] = pn_eeg_rPLV(eegData, dataSelectArr,baseline)
% Computes the relative Phase Locking Value (rPLV) for an EEG dataset.
%
% Input parameters:
%   eegData is a 3D matrix numChannels x numTimePoints x numTrials
%   dataSelectArr (OPTIONAL) is a logical 2D matrix of size - numTrials x
%     numConditions. For example, if you have a 250 trials in your EEG
%     dataset and the first 125 correspond to the 'attend' condition and
%     the last 125 correspond to the 'ignore' condition, then use
%     dataSelectArr = [[true(125, 1); false(125, 1)],...
%       [false(125, 1); true(125, 1)]];
%   baseline is a vector numTimePoints x 1 defining the baseline period of
%     the trial
%
% Output parameters:
%   rplv is a 4D matrix - 
%     numTimePoints x numChannels x numChannels x numConditions
%   If 'dataSelectArr' is not specified, then it is assumed that there is
%   only one condition and all trials belong to that condition.
%
%--------------------------------------------------------------------------
% Example: Consider a 28 channel EEG data sampled @ 500 Hz with 231 trials,
% where each trial lasts for 2 seconds. You are required to plot the phase
% locking value in the gamma band between channels Fz (17) and Oz (20) for
% two conditions (say, attend and ignore). Below is an example of how to
% use this function.
%
%   eegData = rand(28, 1000, 231); 
%   dataSelectArr = rand(231, 1) >= 0.5; % attend trials
%   dataSelectArr(:, 2) = ~dataSelectArr(:, 1); % ignore trials
%   [rplv] = pn_eeg_rPLV(eegData, dataSelectArr, baseline);
%   figure; plot((0:size(eegData, 2)-1), squeeze(plv(:, 17, 20, :)));
%   xlabel('Time (s)'); ylabel('Plase Locking Value');
%
% Also note that in order to extract the PLV between channels 17 and 20, 
% use plv(:, 17, 20, :) and NOT plv(:, 20, 17, :). The smaller channel 
% number is to be used first.
%--------------------------------------------------------------------------
% 
% Reference:
%   Lachaux, J P, E Rodriguez, J Martinerie, and F J Varela. 
%   "Measuring phase synchrony in brain signals." 
%   Human brain mapping 8, no. 4 (January 1999): 194-208. 
%   http://www.ncbi.nlm.nih.gov/pubmed/10619414.
% 
%--------------------------------------------------------------------------
% 
% Written by:
% Nils Rosjat
% INM-3, FZJ
% 24. Nov 2016
% 

numChannels = size(eegData, 1);
numTrials = size(eegData, 4);
numFreqs = size(eegData,2);

if ~exist('dataSelectArr', 'var')
    dataSelectArr = true(numTrials, 1);
else
    if ~islogical(dataSelectArr)
        error('Data selection array must be a logical');
    end
end
numConditions = size(dataSelectArr, 2);

plv = zeros(size(eegData, 3), numFreqs, numChannels, numChannels, numConditions);
rplv = zeros(size(eegData, 3), numFreqs, numChannels, numChannels, numConditions);
for freqCount = 1:numFreqs
    for channelCount = 1:numChannels-1
        channelData = squeeze(eegData(channelCount,freqCount, :, :));
        for compareChannelCount = channelCount+1:numChannels
            compareChannelData = squeeze(eegData(compareChannelCount,freqCount, :, :));
            for conditionCount = 1:numConditions
                plv(:, freqCount, channelCount, compareChannelCount, conditionCount) = abs(mean(exp(1i*(channelData(:, dataSelectArr(:, conditionCount)) - compareChannelData(:, dataSelectArr(:, conditionCount)))), 2));
                rplv(:, freqCount, channelCount, compareChannelCount, conditionCount) = (squeeze(plv(:, freqCount, channelCount, compareChannelCount, conditionCount)) - mean(squeeze(plv(baseline, freqCount, channelCount, compareChannelCount, conditionCount)),1))/mean(squeeze(plv(baseline, freqCount, channelCount, compareChannelCount, conditionCount)),1);
            end
        end
    end
end

rplv = squeeze(rplv);
return;