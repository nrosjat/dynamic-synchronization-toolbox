function [Agg, bet, hub, clusters, node_flex, deg] = graph_measures(xa, stats, graph)

%%% This function computes several graph theoretical measures of the 
%%% dynamic graph. It depends on scripts from the brain connectivity toolbox
%%% (Rubinov M, Sporns O (2010) NeuroImage 52:1059:69.)
% -------------------------------------------------------------------------
% Measures Aggregated graph, node degree, betweenness centrality, hub nodes
% For detailed information about graph measures see:
% brain-connectivity-toolbox.net
%
% Inputs:
%
%   xa - cell [channel, channel], each channel pair contains a
%         list of significant intervals [#intervals, 3] - start, stop,
%         timepoints gap to next interval
%   stats - options for statistics 
%   graph - options for graph measures
% (see dynamic_synchronization_toolbox.m for specifications)
%
% Outputs:
%
%   Agg - aggregated graph showing frequency of all connections
%         over the whole interval [channel, channel]
%   bet - temporal betweenness centrality [timepoint, channel]
%   hub - temporal hub nodes [timepoint, 2]
%   clusters - [channel, timepoints] cluster assignment for each
%         channel and timepoint
%   node_flex - [2, channels] node flexibility for each channel
%   deg - [timepoints, channel] node degree over time for each channel
%
% -------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

elecs = size(xa,1);         % number of electrodes / channels
connected = zeros(elecs);   
  
BC_group = [];                      % Betweenness centrality


t_step = 1000/stats.sampling_rate;  % time-step
interv = 1+stats.test_interval_start:t_step:stats.test_interval_end;

deg = zeros(size(interv,2),elecs);  % node degree over time
bet = zeros(size(interv,2),elecs);  % betweenness centrality over time
Agg = zeros(elecs);                 % aggregated graph
hub = 0;                            % HUB node

for int = 1:size(interv,2)          
    connected=zeros(elecs);
    for con1=1:elecs                % loop over first channel of pair
        for con2=con1+1:elecs       % loop over second channel of each pair
            test = xa{con1,con2};
            for i = 1:size(test,1)
                if (test(i,1) <= interv(int) && test(i,2) >= interv(int))
                    connected(con1,con2) = 1;
                end
            end
            
        end
    end
    
    connected=connected+transpose(connected);
    
    BC = betweenness_bin(connected); % calcluate betweenness centrality for connectivity matrix
    BC_group = [BC_group; BC];       % append BC to previous values
    
    % identify two highest BC values as HUB nodes
    try
        if max(BC) > 0
            hub(int,1) = find(BC == max(BC),1,'first');
            hub(int,2) =  max(BC);
        end
    end
    
    Agg = Agg + connected;          % accumulate aggregated graph
    con{int} = connected;           % store connectivity matrix for interval
    deg(int,:) = degrees_und(connected);    % calculate undirected node degree
    bet(int,:) = betweenness_bin(connected); % store betweenness centrality
    
end

clusters = community(graph,interv,elecs,con);   % calculate clusters in respect of time
node_flex = node_flexibility(interv,stats,elecs,clusters); % calculate node flexibility

end