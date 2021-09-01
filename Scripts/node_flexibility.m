function [node_flex] = node_flexibility(interv,stats,elecs,clusters)

%--------------------------------------------------------------------------
% calculate the node flexibility f_i = \frac{m}{T-1}
%--------------------------------------------------------------------------
% Written by: 
%
% Nils Rosjat
% INM-3, FZJ
% Last edited: 30.01.2020
%--------------------------------------------------------------------------

clear node_flex

t_step = 1000/stats.sampling_rate;

t = interv;
t_range = size(interv,2);

for elec = 1:elecs % loop over all electrodes
    cluster = clusters(elec,t(1)); % cluster at time t
    node_flex(elec) = 0;
    for time = 2:t_range
        if clusters(elec,time) ~= cluster    % if cluster changed
            cluster = clusters(elec,time);   % replace with new cluster
            node_flex(elec) = node_flex(elec)+1; % increase flexibility by 1
        end
    end
end

node_flex = (node_flex)/t_range; % divide flexibility by length of interval

node_flex(2,:)=1;

end