function [mean_val] = statistical_mean(signal)
signalsize=length(signal);
signal_sum=0;
for i=1:signalsize
    signal_sum=signal_sum+signal(i);
end
mean_val=signal_sum/signalsize;
end

