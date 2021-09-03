time = -1500:5:2495;

eegData = zeros(61,48,800,100);
channels = [1,32,33,3,36,4,37,40,8,41,9,12,44,13,45,48,18,49,19,22,43,23,54,27,57,58,28];

for ch= 1:61
    if ismember(ch,channels)
        for freq = 1:48
            for t=1:299
                for trial = 1:100
                    eegData(ch,freq,t,trial)=randn(1,1);
                end
            end
            for t=300:500
                for trial = 1:25
                    eegData(ch,freq,t,trial) = 2*pi*(2500+time(t))/1000*freq;
                end
                for trial = 26:50
                    eegData(ch,freq,t,trial) = randn(1,1);
                end
                for trial = 51:75
                    eegData(ch,freq,t,trial) = 2*pi*(2500+time(t))/1000*freq;
                end
                for trial = 76:100
                    eegData(ch,freq,t,trial) = randn(1,1);
                end
            end
            for t=501:800
                for trial = 1:100
                eegData(ch,freq,t,trial)=randn(1,1);
                end
            end
        end
        
    else
        for freq = 1:48
            for t=1:299
                for trial = 1:100
                    eegData(ch,freq,t,trial)=randn(1,1);
                end
            end
            for t=300:500
                for trial = 26:50
                    eegData(ch,freq,t,trial) = 2*pi*(2500+time(t))/1000*freq;
                end
                for trial = 1:25
                    eegData(ch,freq,t,trial) = randn(1,1);
                end
                for trial = 76:100
                    eegData(ch,freq,t,trial) = 2*pi*(2500+time(t))/1000*freq;
                end
                for trial = 51:75
                    eegData(ch,freq,t,trial) = randn(1,1);
                end
            end
            for t=501:800
                for trial = 1:100
                eegData(ch,freq,t,trial)=randn(1,1);
                end
            end
        end
        
    end
end

