function [outputArg1,outputArg2] = LikhithaStats(inputVar)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
outVal = zeros(2,size(inputVar,2));
outVal(1,:) = mean(inputVar);
outVal(2,:) = min(inputVar);
outVal(3,:) = max(inputVar);


%get output to display formatted stats
disp('Statistics for the variable:')
disp(['Mean: ' num2str(outVal(1,:))]);
disp(['Min: ' num2str(outVal(2,:))]);
disp(['Max: ' num2str(outVal(3,:))]);

%save output into variables
outputArg1 = outVal;
outputArg2 = size(inputVar);

end

