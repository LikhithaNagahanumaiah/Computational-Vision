clear all;
close all;

flist = dir('*xls');
data = [];
for i=1:length(flist) % raed all data
    dat{i} = readmatrix(flist(i).name);
    data = [data; dat{i}];  %adding this to previous data
end
%sort data
[datasort,ind] = sortrows(data);
%separate 'groups' - you want separate scales for separate groups of images
Lm1data = datasort(1:330,:);
Lm2data = datasort(331:550,:);
Lm3data = datasort(551:770,:);
Lm4data = datasort(771:1100,:);
Lm5data = datasort(1101:1430,:);
Lm6data = datasort(1431:1892,:);

% Landmark 1- MAG
LMdata = Lm1data; %just using one group of images at a time 
% LMdata = LMdata-6; %data has to be -Mimages for indicies below to work
%create another column of sum data 
for i=1:length(LMdata) %making count data for 1 im preferred over other
    if LMdata(i,3)==LMdata(i,2)
        LMdata(i,4)=1
    else
        LMdata(i,4)=0
    end
end
%creating F matrix: sum of times each image was prefered over the
%other in each pair
N = 22; %number of observers/observations
M = 6; % 4 images within each group
Fmatrix = zeros(M,M);
for i=1:length(LMdata)
    Fmatrix(LMdata(i,1),LMdata(i,2)) = Fmatrix(LMdata(i,1),LMdata(i,2)) + LMdata(i,4); %adding vals each iteration (filling out top half of matrix)
    Fmatrix(LMdata(i,2),LMdata(i,1)) = N - Fmatrix(LMdata(i,1),LMdata(i,2)); %filling out bottom half of matrix
end
%proportion matrix
Pmatrix = Fmatrix./N
%correct for saturated comparisons (p=0 or p=1)
Pmatrix = min(Pmatrix,1-1/(2*N));
Pmatrix = max(Pmatrix,1/(2*N));
%make Z-scores
Zmatrix = norminv(Pmatrix);
Zmatrix(logical(eye(M))) = 0 %sets diag back to 0
%scale values for each image (average Zscores for each image)
Svalue = mean(Zmatrix);
%unsophisticated way to calculate 95CIs:
CIs = 1.96*(1/sqrt(N*M)); % 95% corresponds to 1.96 zscores, 1zscore = 1SD, weight by sqrt of Nobservers * Msamples 
                           % +/- add/subtract this value to Svalues. 
CIs = repmat(CIs,1,length(Svalue));
%plot
figure
hold on
plot(Svalue,0,'dk','markersize',15,'markerfacecolor',[0 .44 .74])
% errorbar(Svalue,zeros(size(Svalue)),CIs,'horizontal','-k') 
%error bars look bad with such a small sample
for i = 1:length(Svalue)
text(Svalue(i), -.2, num2str(i) )
end
plot(get(gca,'XLim'),[0 0],'-k');
title('Lamndmark1-MAG'); xlabel('Scale Value (Z-Score)'); yticks(''); xlim([-1.8 1.8]);

% Landmark 2- Sentinel
LMdata = Lm2data; %just using one group of images at a time 
LMdata = LMdata-6; %data has to be -Mimages for indicies below to work
%create another column of sum data 
for i=1:length(LMdata) %making count data for 1 im preferred over other
    if LMdata(i,3)==LMdata(i,2)
        LMdata(i,4)=1
    else
        LMdata(i,4)=0
    end
end
%creating F matrix: sum of times each image was prefered over the
%other in each pair
N = 22; %number of observers/observations
M = 5; % 4 images within each group
Fmatrix = zeros(M,M);
for i=1:length(LMdata)
    Fmatrix(LMdata(i,1),LMdata(i,2)) = Fmatrix(LMdata(i,1),LMdata(i,2)) + LMdata(i,4); %adding vals each iteration (filling out top half of matrix)
    Fmatrix(LMdata(i,2),LMdata(i,1)) = N - Fmatrix(LMdata(i,1),LMdata(i,2)); %filling out bottom half of matrix
end
%proportion matrix
Pmatrix = Fmatrix./N
%correct for saturated comparisons (p=0 or p=1)
Pmatrix = min(Pmatrix,1-1/(2*N));
Pmatrix = max(Pmatrix,1/(2*N));
%make Z-scores
Zmatrix = norminv(Pmatrix);
Zmatrix(logical(eye(M))) = 0 %sets diag back to 0
%scale values for each image (average Zscores for each image)
Svalue = mean(Zmatrix);
%unsophisticated way to calculate 95CIs:
CIs = 1.96*(1/sqrt(N*M)); % 95% corresponds to 1.96 zscores, 1zscore = 1SD, weight by sqrt of Nobservers * Msamples 
                           % +/- add/subtract this value to Svalues. 
CIs = repmat(CIs,1,length(Svalue));
%plot
figure
hold on
plot(Svalue,0,'dk','markersize',15,'markerfacecolor',[0 .44 .74])
% errorbar(Svalue,zeros(size(Svalue)),CIs,'horizontal','-k') 
%error bars look bad with such a small sample
for i = 1:length(Svalue)
text(Svalue(i), -.2, num2str(i) )
end
plot(get(gca,'XLim'),[0 0],'-k');
title('Lamndmark2-Sentinel'); xlabel('Scale Value (Z-Score)'); yticks(''); xlim([-1.8 1.8]);

% Landmark 3- Color cube
LMdata = Lm3data; %just using one group of images at a time 
LMdata = LMdata-11; %data has to be -Mimages for indicies below to work
%create another column of sum data 
for i=1:length(LMdata) %making count data for 1 im preferred over other
    if LMdata(i,3)==LMdata(i,2)
        LMdata(i,4)=1
    else
        LMdata(i,4)=0
    end
end
%creating F matrix: sum of times each image was prefered over the
%other in each pair
N = 22; %number of observers/observations
M = 5; % 4 images within each group
Fmatrix = zeros(M,M);
for i=1:length(LMdata)
    Fmatrix(LMdata(i,1),LMdata(i,2)) = Fmatrix(LMdata(i,1),LMdata(i,2)) + LMdata(i,4); %adding vals each iteration (filling out top half of matrix)
    Fmatrix(LMdata(i,2),LMdata(i,1)) = N - Fmatrix(LMdata(i,1),LMdata(i,2)); %filling out bottom half of matrix
end
%proportion matrix
Pmatrix = Fmatrix./N
%correct for saturated comparisons (p=0 or p=1)
Pmatrix = min(Pmatrix,1-1/(2*N));
Pmatrix = max(Pmatrix,1/(2*N));
%make Z-scores
Zmatrix = norminv(Pmatrix);
Zmatrix(logical(eye(M))) = 0 %sets diag back to 0
%scale values for each image (average Zscores for each image)
Svalue = mean(Zmatrix);
%unsophisticated way to calculate 95CIs:
CIs = 1.96*(1/sqrt(N*M)); % 95% corresponds to 1.96 zscores, 1zscore = 1SD, weight by sqrt of Nobservers * Msamples 
                           % +/- add/subtract this value to Svalues. 
CIs = repmat(CIs,1,length(Svalue));
%plot
figure
hold on
plot(Svalue,0,'dk','markersize',15,'markerfacecolor',[0 .44 .74])
% errorbar(Svalue,zeros(size(Svalue)),CIs,'horizontal','-k') 
%error bars look bad with such a small sample
for i = 1:length(Svalue)
text(Svalue(i), -.2, num2str(i) )
end
plot(get(gca,'XLim'),[0 0],'-k');
title('Lamndmark3-Color cube'); xlabel('Scale Value (Z-Score)'); yticks(''); xlim([-1.8 1.8]);

% Landmark 4- MCS
LMdata = Lm4data; %just using one group of images at a time 
LMdata = LMdata-16; %data has to be -Mimages for indicies below to work
%create another column of sum data 
for i=1:length(LMdata) %making count data for 1 im preferred over other
    if LMdata(i,3)==LMdata(i,2)
        LMdata(i,4)=1
    else
        LMdata(i,4)=0
    end
end
%creating F matrix: sum of times each image was prefered over the
%other in each pair
N = 22; %number of observers/observations
M = 6; % 4 images within each group
Fmatrix = zeros(M,M);
for i=1:length(LMdata)
    Fmatrix(LMdata(i,1),LMdata(i,2)) = Fmatrix(LMdata(i,1),LMdata(i,2)) + LMdata(i,4); %adding vals each iteration (filling out top half of matrix)
    Fmatrix(LMdata(i,2),LMdata(i,1)) = N - Fmatrix(LMdata(i,1),LMdata(i,2)); %filling out bottom half of matrix
end
%proportion matrix
Pmatrix = Fmatrix./N
%correct for saturated comparisons (p=0 or p=1)
Pmatrix = min(Pmatrix,1-1/(2*N));
Pmatrix = max(Pmatrix,1/(2*N));
%make Z-scores
Zmatrix = norminv(Pmatrix);
Zmatrix(logical(eye(M))) = 0 %sets diag back to 0
%scale values for each image (average Zscores for each image)
Svalue = mean(Zmatrix);
%unsophisticated way to calculate 95CIs:
CIs = 1.96*(1/sqrt(N*M)); % 95% corresponds to 1.96 zscores, 1zscore = 1SD, weight by sqrt of Nobservers * Msamples 
                           % +/- add/subtract this value to Svalues. 
CIs = repmat(CIs,1,length(Svalue));
%plot
figure
hold on
plot(Svalue,0,'dk','markersize',15,'markerfacecolor',[0 .44 .74])
% errorbar(Svalue,zeros(size(Svalue)),CIs,'horizontal','-k') 
%error bars look bad with such a small sample
for i = 1:length(Svalue)
text(Svalue(i), -.2, num2str(i) )
end
plot(get(gca,'XLim'),[0 0],'-k');
title('Lamndmark4-MCS'); xlabel('Scale Value (Z-Score)'); yticks(''); xlim([-1.8 1.8]);

% Landmark 5- Liberty pole
LMdata = Lm5data; %just using one group of images at a time 
LMdata = LMdata-22; %data has to be -Mimages for indicies below to work
%create another column of sum data 
for i=1:length(LMdata) %making count data for 1 im preferred over other
    if LMdata(i,3)==LMdata(i,2)
        LMdata(i,4)=1
    else
        LMdata(i,4)=0
    end
end
%creating F matrix: sum of times each image was prefered over the
%other in each pair
N = 22; %number of observers/observations
M = 6; % 6 images within each group
Fmatrix = zeros(M,M);
for i=1:length(LMdata)
    Fmatrix(LMdata(i,1),LMdata(i,2)) = Fmatrix(LMdata(i,1),LMdata(i,2)) + LMdata(i,4); %adding vals each iteration (filling out top half of matrix)
    Fmatrix(LMdata(i,2),LMdata(i,1)) = N - Fmatrix(LMdata(i,1),LMdata(i,2)); %filling out bottom half of matrix
end
%proportion matrix
Pmatrix = Fmatrix./N
%correct for saturated comparisons (p=0 or p=1)
Pmatrix = min(Pmatrix,1-1/(2*N));
Pmatrix = max(Pmatrix,1/(2*N));
%make Z-scores
Zmatrix = norminv(Pmatrix);
Zmatrix(logical(eye(M))) = 0 %sets diag back to 0
%scale values for each image (average Zscores for each image)
Svalue = mean(Zmatrix);
%unsophisticated way to calculate 95CIs:
CIs = 1.96*(1/sqrt(N*M)); % 95% corresponds to 1.96 zscores, 1zscore = 1SD, weight by sqrt of Nobservers * Msamples 
                           % +/- add/subtract this value to Svalues. 
CIs = repmat(CIs,1,length(Svalue));
%plot
figure
hold on
plot(Svalue,0,'dk','markersize',15,'markerfacecolor',[0 .44 .74])
% errorbar(Svalue,zeros(size(Svalue)),CIs,'horizontal','-k') 
%error bars look bad with such a small sample
for i = 1:length(Svalue)
text(Svalue(i), -.2, num2str(i) )
end
plot(get(gca,'XLim'),[0 0],'-k');
title('Lamndmark5-Liberty pole'); xlabel('Scale Value (Z-Score)'); yticks(''); xlim([-1.8 1.8]);

% Landmark 6- Tiger
LMdata = Lm6data; %just using one group of images at a time 
LMdata = LMdata-28; %data has to be -Mimages for indicies below to work
%create another column of sum data 
for i=1:length(LMdata) %making count data for 1 im preferred over other
    if LMdata(i,3)==LMdata(i,2)
        LMdata(i,4)=1
    else
        LMdata(i,4)=0
    end
end
%creating F matrix: sum of times each image was prefered over the
%other in each pair
N = 22; %number of observers/observations
M = 7; % 4 images within each group
Fmatrix = zeros(M,M);
for i=1:length(LMdata)
    Fmatrix(LMdata(i,1),LMdata(i,2)) = Fmatrix(LMdata(i,1),LMdata(i,2)) + LMdata(i,4); %adding vals each iteration (filling out top half of matrix)
    Fmatrix(LMdata(i,2),LMdata(i,1)) = N - Fmatrix(LMdata(i,1),LMdata(i,2)); %filling out bottom half of matrix
end
%proportion matrix
Pmatrix = Fmatrix./N
%correct for saturated comparisons (p=0 or p=1)
Pmatrix = min(Pmatrix,1-1/(2*N));
Pmatrix = max(Pmatrix,1/(2*N));
%make Z-scores
Zmatrix = norminv(Pmatrix);
Zmatrix(logical(eye(M))) = 0 %sets diag back to 0
%scale values for each image (average Zscores for each image)
Svalue = mean(Zmatrix);
%unsophisticated way to calculate 95CIs:
CIs = 1.96*(1/sqrt(N*M)); % 95% corresponds to 1.96 zscores, 1zscore = 1SD, weight by sqrt of Nobservers * Msamples 
                           % +/- add/subtract this value to Svalues. 
CIs = repmat(CIs,1,length(Svalue));
%plot
figure
hold on
plot(Svalue,0,'dk','markersize',15,'markerfacecolor',[0 .44 .74])
% errorbar(Svalue,zeros(size(Svalue)),CIs,'horizontal','-k') 
%error bars look bad with such a small sample
for i = 1:length(Svalue)
text(Svalue(i), -.2, num2str(i) )
end
plot(get(gca,'XLim'),[0 0],'-k');
title('Lamndmark6-Tiger'); xlabel('Scale Value (Z-Score)'); yticks(''); xlim([-1.8 1.8]);




