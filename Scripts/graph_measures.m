function [Agg, bet, hub, clusters, node_flex, deg] = graph_measures(xa, stats, graph)

%%% This function computes several graph theoretical measures of the 
%%% dynamic graph. It depends on scripts from the brain connectivity toolbox (ref)
% -------------------------------------------------------------------------
% Measures Aggregated graph, node degree, betweenness centrality, hub nodes
% ...
%
% -------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

elecs = size(xa,1);
connected = zeros(elecs);
  
BC_group = [];


t_step = 1000/stats.sampling_rate;
interv = 1+stats.test_interval_start:t_step:stats.test_interval_end;

deg = zeros(size(interv,2),elecs);
bet = zeros(size(interv,2),elecs);
Agg = zeros(elecs);
hub = 0;

for int = 1:size(interv,2)
    connected=zeros(elecs);
    for con1=1:elecs
        for con2=con1+1:elecs
            test = xa{con1,con2};
            for i = 1:size(test,1)
                if (test(i,1) <= interv(int) && test(i,2) >= interv(int))
                    connected(con1,con2) = 1;
                end
            end
            
        end
    end
    
    connected=connected+transpose(connected);
    %%% Remove edge electrodes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %        connected(:,[1 32 3 40 12 48 22 27 28 29 30 31 26 52 16 43 7 35 2]) = 0;
    %        connected([1 32 3 40 12 48 22 27 28 29 30 31 26 52 16 43 7 35 2],:) = 0;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    BC = betweenness_bin(connected); 
    BC_group = [BC_group; BC];
    
    try
        if max(BC) > 0
            hub(int,1) = find(BC == max(BC),1,'first');
            hub(int,2) =  max(BC);
        end
    end
    Agg = Agg + connected;
    con{int} = connected;
    deg(int,:) = degrees_und(connected);
    bet(int,:) = betweenness_bin(connected);
    
end

clusters = community(graph,interv,elecs,con);
node_flex = node_flexibility(interv,stats,elecs,clusters);

end