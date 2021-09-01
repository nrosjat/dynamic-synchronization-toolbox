function [sig_ti_FDR,xa,lengths] = stats_rplv(rplv,stats,rnd)

%--------------------------------------------------------------------------
%------------- Script for statistical analysis of (r)PLV ------------------
%--------------------------------------------------------------------------
% 
% Inputs:
%   subjects - list of ids
%   options -multiple_conds, baseline, freqs, switch_hands, channels_new,
%   channels_old, contrast, contrast_conds, averaging, avg_freqs
%
%   data - dimensions (elecs, freqs, time, conditions)
%--------------------------------------------------------------------------
% Written by: 
%
% Nils Rosjat
% INM-3, FZJ
% Last edited: 03.04.2020
%--------------------------------------------------------------------------

% load('channels.mat')
% channels_used = channels(1,1:61);

if nargin<3
  rnd = 1;
end

rng(rnd) % random number generator state 1 (for figure reproducibility)


elecs = size(rplv{1,1},2);       % # of electrodes

subs = size(rplv,1);                     % # of young subjects


%%%% Script for PLV significance tests %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pp = [];                % empty vector of p-values (for FDR-correction)
time= stats.time;       % Define timepoints of whole cued interval
task = stats.task;      % Task selected for statistics

% Select start and end of the epoch of interest (EOI) in ms
baseline_start=stats.baseline_start;                       % start of baseline in ms
baseline_end=stats.baseline_end;                          % end of baseline in ms
time_base_start=find(time==baseline_start); % find timepoint corr. to base
time_base_end=find(time==baseline_end);     % find timepoint corr. to end
baseline_int=(time_base_start:time_base_end);   % define baseline timepoints

% Select start and end of the epoch of interest (EOI) in ms
interval_start=stats.test_interval_start;         % start of testinterval
interval_end=stats.test_interval_end;             % end of testinterval
time_int_start=find(time==interval_start);  % find timepoint test start
time_int_end=find(time==interval_end);      % find timepoint test end
interval=(time_int_start:time_int_end);     % define test timepoints

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% baseline matrix %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% first extract baseline values%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
baseline_mat=cell(subs,1);
for i=1:subs;
baseline_mat{i,1}=squeeze(rplv{i,1}(baseline_int,:,:,task));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% then calculate noise with baseline signature %%%%%%%%%%%%%%%%%%%%%%%%%%
baseline_electrode=cell(elecs,elecs,1);
for j=1:elecs;
for k=j+1:elecs;
    for i=1:subs
        aa=baseline_mat{i,1};
        bb=aa(:,j,k);
        cc=mean(bb,1);
        dd=std(bb);
        A=random('norm',cc,dd,1,size(interval,2));
        baseline_matrix(i,:)=A;
    end
    baseline_electrode{j,k,:}=baseline_matrix;
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% test matrix %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% first extract test values %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:subs
data{i,1}=squeeze(rplv{i,1}(interval,:,:,task));
end

mm=cell(elecs,elecs,1);
for j=1:elecs
    for k=j+1:elecs
    for i=1:subs
        kk=data{i,1}(:,j,k);
        ee(i,:)=transpose(kk);
    end
         mm{j,k,:}=ee;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% ttest cued comparing to baseline
pps=cell(elecs,elecs);
hh=cell(elecs,elecs);
for j=1:elecs
    for k=j+1:elecs
        aaa=baseline_electrode{j,k,1};
        bbb=mm{j,k,1};
        h_13=[];
        p_13=[];
        for i=1:size(interval,2)
            aa=aaa(:,i);
            bb=bbb(:,i);
            %%% optional switch between test against baseline or zero %%%%%
            switch stats.comp
                case 'baseline'
                    [h,p]=ttest(aa,bb);
                case 'zero'
                    [h,p]=ttest(bb,0);
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            h_13(1,i)=h;
            p_13(1,i)=p;
        end
        pp =[pp p_13];              % collect all p-values for FDR-correction
        pps{j,k}(1,:)=p_13;
        hhs{j,k}(1,:)=h_13;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%% False discovery rate correction %%%%%%%%%%%%%%%%%%
pID_fix = FDR_correct(pp,stats.q_FDR);

sig_ti_FDR = cell(elecs,elecs);
aa=cell(elecs,elecs);
pID=cell(elecs,elecs);
pN=cell(elecs,elecs);
for j=1:elecs
    for k=j+1:elecs
        switch stats.pid
            case 'original'
                aa{j,k}=find(pps{j,k}<pID_fix); % original
            case 'individual'
                try
                    [pID{j,k},pN{j,k}]=FDR_correct(pps{j,k},q_FDR);
                end
                aa{j,k}=find(pps{j,k}<pID{j,k}); % test
            case 'uncorr'
                aa{j,k}=find(pps{j,k}<p_fix); % test
        end
        sig_ti_FDR{j,k}=aa{j,k}*1000/stats.sampling_rate+time(interval(1)); 
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[xa, lengths] = check_intervals(sig_ti_FDR,elecs);



end