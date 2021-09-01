function clusters = community(graph, interv, elecs, con)
%--------------------------------------------------------------------------
%----- Script for doing community detection with louvain ------------------
%--------------------------------------------------------------------------
%
% calls fix_module labels
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

M = zeros(elecs,size(interv,2));    % cluster membership matrix young

for t = 1:size(interv,2)
    A = con{1,t};                   % load young connectivity matrix for time t
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