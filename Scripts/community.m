function clusters = community(graph, interv, elecs, con)
%--------------------------------------------------------------------------
%----- Script for doing community detection with louvain ------------------
%--------------------------------------------------------------------------
%
% Inputs:
%   graph - graph settings
%   interv - intervall for community detection
%   elecs - number of electrodes
%   con - dynamic connectivity matrix stored in cell {1,T}, T number of
%   timepoints
%
% Outputs:
%   clusters - [channel, timepoints] cluster assignment for each
%         channel and timepoint
%
% Calls fix_module labels for reducing artificial cluster changes.
%--------------------------------------------------------------------------
% Written by: 
%
% Nils Rosjat
% INM-3, FZJ
% Last edited: 30.01.2020
%--------------------------------------------------------------------------

% close all

ovr_pen = graph.pen;                %overall penalty for clusterlabel switches

q = graph.clust_size;               % cluster size parameter (optimized for 0.9)

M = zeros(elecs,size(interv,2));    % cluster membership matrix

for t = 1:size(interv,2)
    A = con{1,t};                   % load connectivity matrix for time t
    if t>1
        [M(:,t),Q] = community_louvain(A,q,M(:,t-1)); % Louvain clustering: use previous clusters as prior
    else
        [M(:,t),Q] = community_louvain(A,q);            % Louvain clustering: first cluster
    end
    deg = degrees_und(A);           % matrix degree
    M(find(deg==0),t) = 0;          % set all clusters of zero degree nodes to 0
    
   
end

M = fix_module_labels(M,interv);    % fix module labels for consistency in labels

clusters = M;