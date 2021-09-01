%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Script for creating dynamic graph movies %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% and calculate dynamic graph measures %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% load channels and their positions for plotting %%%%%%%%%%%%%%%%%%%%%%%%
load('channels.mat')                % mat file containing information on EEG channels
channels_used = channels(1,1:61);   % define a subset of used channels

pos = zeros(elecs,2);
for i=1:elecs
    pos(i,1) = ((channels_used(1,i).X_plot2D-0.498)*10+5)*47-25;
    pos(i,2) = 542-((channels_used(1,i).Y_plot2D-0.4661)*10+5)*55;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% categorization of channels %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% interhemispheric motor edges %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% ipsilateral motor edges %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% contralateral motor edges %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
interhemispheric_con = [4,6;4,42;4,15;4,51;6,41;6,13;6,49;41,42;15,41;41,51;
    13,42;42,49;13,15;13,51;15,49;49,51];
ipsilateral_con = [4,5;4,17;4,14;4,50;4,41;4,13;4,49;5,41;5,17;5,13;5,14;
    5,49;5,50;17,41;13,41;14,41;41,49;41,50;13,17;14,17;17,49;17,50;13,14;
    13,49;13,50;14,49;14,50;49,50];
contralateral_con = [5,6;5,42;5,15;5,51;6,17;6,42;6,14;6,15;6,50;6,51;
    17,42;15,17;17,51;14,42;15,42;42,50;42,51;14,15;14,51;15,50;15,51;
    50,51];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

connected_o = zeros(elecs);
connected_y = zeros(elecs);
  
BC_young = [];
BC_old = [];

rgb = imread('/data/KogNeuro04/ComputationalNeurology/Rosjat/MATLAB/Dynamic_PLV_Analysis/Figures/brain.png');
smaller_rgb = imresize(rgb,[534,424]);

deg_o = zeros(200,elecs);
deg_y = zeros(200,elecs);
bet_o = zeros(200,elecs);
bet_y = zeros(200,elecs);
A_y = zeros(61);
A_o = zeros(61);
hub_o = {};
hub_y = {};

subplot(1,2,1)
        imshow(smaller_rgb)
        hold on
        gplot(connected_y,pos,'.-');
        childs=get(gca,'children');
        set(intersect(findall(gcf,'type','line'),childs),'LineWidth',2)
        axis([-100 534 -60 550],'off')
        title(('Younger Subjects'),'FontSize',12)
set(gca,'nextplot','replacechildren'); 
subplot(1,2,2)
        imshow(smaller_rgb)
        hold on
        gplot(connected_o,pos,'.-');
        childs=get(gca,'children');
        set(intersect(findall(gcf,'type','line'),childs),'LineWidth',2)
        axis([-100 534 -60 550],'off')
        title(('Older Subjects'),'FontSize',12)
        set(gcf,'color','w');
        set(gca,'nextplot','replacechildren'); 
        

v = VideoWriter('rplv_connected_cued_slow.avi');
v.FrameRate = 2;
open(v);

interv = 1:5:1000;
for int = 1:size(interv,2)
    connected_o=zeros(elecs);
    connected_y=zeros(elecs);
    for con1=1:elecs
        for con2=con1+1:elecs
            test_o = xa_o{con1,con2};
            test_y = xa_y{con1,con2};
            for i = 1:size(test_o,1)
                if (test_o(i,1) <= interv(int) && test_o(i,2) >= interv(int))
                    connected_o(con1,con2) = 1;
                end
            end
            for i = 1:size(test_y,1)
                if (test_y(i,1) <= interv(int) && test_y(i,2) >= interv(int))
                    connected_y(con1,con2) = 1;
                end
            end
            
        end
    end
    ipsilateral_y = zeros(elecs);
    interhemispheric_y = zeros(elecs);
    contralateral_y = zeros(elecs);

    ipsilateral_o = zeros(elecs);
    interhemispheric_o = zeros(elecs);
    contralateral_o = zeros(elecs);
    
    for i=1:size(interhemispheric_con,1)
        interhemispheric_y(interhemispheric_con(i,1),interhemispheric_con(i,2)) = connected_y(interhemispheric_con(i,1),interhemispheric_con(i,2));
        interhemispheric_o(interhemispheric_con(i,1),interhemispheric_con(i,2)) = connected_o(interhemispheric_con(i,1),interhemispheric_con(i,2));
    end
    for i=1:size(ipsilateral_con,1)
        ipsilateral_y(ipsilateral_con(i,1),ipsilateral_con(i,2)) = connected_y(ipsilateral_con(i,1),ipsilateral_con(i,2));
        ipsilateral_o(ipsilateral_con(i,1),ipsilateral_con(i,2)) = connected_o(ipsilateral_con(i,1),ipsilateral_con(i,2));
    end
    for i=1:size(contralateral_con,1)
        contralateral_y(contralateral_con(i,1),contralateral_con(i,2)) = connected_y(contralateral_con(i,1),contralateral_con(i,2));
        contralateral_o(contralateral_con(i,1),contralateral_con(i,2)) = connected_o(contralateral_con(i,1),contralateral_con(i,2));
    end
    connected_o=connected_o+transpose(connected_o);
    
    %%% Remove edge electrodes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            connected_o(:,[1 32 3 40 12 48 22 27 28 29 30 31 26 52 16 43 7 35 2]) = 0;
            connected_o([1 32 3 40 12 48 22 27 28 29 30 31 26 52 16 43 7 35 2],:) = 0;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    BC_o = betweenness_bin(connected_o);
    BC_old = [BC_old; BC_o];

    try
        if max(BC_o) > 0
            hub_o{1,int}(1,1) =  find(BC_o == max(BC_o));
            hub_o{2,int} =  channels_used(1,find(BC_o == max(BC_o))).label;
            hub_o{1,int}(1,2) =  max(BC_o);
            BC_o(BC_o==max(BC_o))=0;
            try
            hub_o{1,int}(2,1) =  find(BC_o == max(BC_o));
            hub_o{3,int} =  channels_used(1,find(BC_o == max(BC_o))).label;
            hub_o{1,int}(2,2) =  max(BC_o);            
            end
        end
    end
    A_o = A_o + connected_o;
    con_o{int} = connected_o;
    deg_o(int,:) = degrees_und(connected_o);
    bet_o(int,:) = betweenness_bin(connected_o);
    connected_y=connected_y+transpose(connected_y);
    %%% Remove edge electrodes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            connected_y(:,[1 32 3 40 12 48 22 27 28 29 30 31 26 52 16 43 7 35 2]) = 0;
            connected_y([1 32 3 40 12 48 22 27 28 29 30 31 26 52 16 43 7 35 2],:) = 0;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    BC_y = betweenness_bin(connected_y); 
    BC_young = [BC_young; BC_y];
    
    try
        if max(BC_y) > 0
            hub_y{2,int} =  channels_used(1,find(BC_y == max(BC_y))).label;
            hub_y{1,int}(1,1) =  find(BC_y == max(BC_y));
            hub_y{1,int}(1,2) =  max(BC_y);
            BC_y(BC_y==max(BC_y))=0;
            try
            hub_y{1,int}(2,1) =  find(BC_y == max(BC_y));
            hub_y{3,int} =  channels_used(1,find(BC_y == max(BC_y))).label;
            hub_y{1,int}(2,2) =  max(BC_y);            
            end
        end
    end
    A_y = A_y + connected_y;
    con_y{int} = connected_y;
    deg_y(int,:) = degrees_und(connected_y);
    bet_y(int,:) = betweenness_bin(connected_y);
    ipsilateral_y = ipsilateral_y+transpose(ipsilateral_y);
    ips_y{int} = ipsilateral_y;
    ipsilateral_o = ipsilateral_o+transpose(ipsilateral_o);
    ips_o{int} = ipsilateral_o;
    interhemispheric_y = interhemispheric_y+transpose(interhemispheric_y);
    int_y{int} = interhemispheric_y;
    interhemispheric_o = interhemispheric_o+transpose(interhemispheric_o);
    int_o{int} = interhemispheric_o;
    contralateral_y=contralateral_y+transpose(contralateral_y);
    cont_y{int} = contralateral_y;
    contralateral_o=contralateral_o+transpose(contralateral_o);
    cont_o{int} = contralateral_o;
    
    if create_movie
        subplot(1,2,2)
        cla
        set(gca,'nextplot','replacechildren');
            imshow(smaller_rgb)
            hold on
            gplot(connected_o-ipsilateral_o-contralateral_o-interhemispheric_o,pos,'.-k');
            gplot(ipsilateral_o,pos,'.-b');
            gplot(contralateral_o,pos,'.-g');
            gplot(interhemispheric_o,pos,'.-r');
            childs=get(gca,'children');
            set(intersect(findall(gcf,'type','line'),childs),'LineWidth',2)
            axis([-100 534 -60 550],'off')
            hold off
        subplot(1,2,1)
        cla
        set(gca,'nextplot','replacechildren');
            imshow(smaller_rgb)
            hold on
            gplot(connected_y-ipsilateral_y-contralateral_y-interhemispheric_y,pos,'.-k');
            gplot(ipsilateral_y,pos,'.-b');
            gplot(contralateral_y,pos,'.-g');
            gplot(interhemispheric_y,pos,'.-r');
            childs=get(gca,'children');
            set(intersect(findall(gcf,'type','line'),childs),'LineWidth',2)
            axis([-100 534 -60 550],'off')
            hold off

            timepoint = num2str(interv(int));
            ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
    text(0.5, 0.15,timepoint,'FontSize',20)
            title(('Younger Subjects'),'FontSize',12)
        frame = getframe(gcf);
        writeVideo(v,frame);
    end
end

close(v);