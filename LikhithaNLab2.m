%% unique Blue data - fitting psych function for 0-1 data
clear all;
close all;
clc;
%Resp 0 = reddish, 1 = greenish

%sorting my data
my_data= xlsread('LikhithaNLab2Data.xls');
hue=my_data(:,2);
res=my_data(:,3);
[sorted,inx]=sort(my_data(:,1));%sorting according to index by moving all 0 values from 1:90, 1 from 91:180
huesort=hue(inx);
ressort=res(inx);
sorted_data=[sorted huesort ressort]; % sorted array

test= table(my_data(:,1),my_data(:,2),my_data(:,3),'VariableNames',{'inp','Hue','Resp'});% another way to sort
bluetest=test(test.inp==0,2:3);% assigning 0 to blue

tblStats = grpstats(bluetest,{ 'Hue'},...
               {'mean' 'std' 'numel'}) % groups stats of blue data response
tblCount = grpstats(bluetest,{ 'Hue', 'Resp'}) %notice this doesnt show every group
%computing count and proportions from table data
tblStats.FreqGreen = tblStats.mean_Resp.*tblStats.numel_Resp;
tblStats.FreqRed = tblStats.numel_Resp-tblStats.FreqGreen;
tblStats.Prop = tblStats.FreqGreen./tblStats.numel_Resp; %notice same as mean_Resp since its 0-1

%-------final probit plot with CIs, threshold, etc
x = tblStats.Hue;
y = tblStats.FreqGreen;
n = tblStats.numel_Resp;
[b, d, s] = glmfit(x,[y n],'binomial','Link','probit');
[yfit, ciLO, ciHI] = glmval(b,x,'probit',s);
figure;
plot(x,y./n,'o',x,yfit,'r-')
hold on
Thresh = interp1(yfit,x, .5);
set(gca,'XLim',[min(x) max(x)]);
plot(x,(yfit-ciLO),'--b')
plot(x,(yfit+ciHI),'--b')
plot([x(1) Thresh],[.5 .5],'k--');
plot([Thresh Thresh],[.5 0],'k--');
text(Thresh,min(get(gca,'YLim')),...
    [' Unique Hue @ ' num2str(Thresh)],...
    'HorizontalAl','left',...
    'VerticalAl','bottom',...
    'Color','k','fontsize',12);
title('My Unique Blue')
xlabel('Stimulus Hue');
ylabel('Reddish <-    Proportion    -> Greenish');
legend('Measured Data','Probit fit','95% CI','Location','Best')
xticks([210:7.5:270])

%plot just raw data
% scatter(huesort(1:90,1),ressort(1:90,1))
% ylim([-.1,1.1])
% xlabel('Stimulus Hue');
% ylabel('(0=reddish)     Response      (1=greenish)')
% xticks([210:7.5:270])

%plot just probability
x = tblStats.Hue;
y = tblStats.FreqGreen;
n = tblStats.numel_Resp;
figure;
plot(x,y./n,'o')
hold on
set(gca,'XLim',[min(x) max(x)]);
xlabel('Stimulus Hue');
ylabel('Reddish <-    Proportion    -> Greenish');
xticks([210:7.5:270])

%-------probit vs logit
x = tblStats.Hue;
y = tblStats.FreqGreen; %frequency
n = tblStats.numel_Resp; %number of total responses
[b, d, s] = glmfit(x,[y n],'binomial','Link','probit');%glm-general linear model
[yfit, ciLO, ciHI] = glmval(b,x,'probit',s);
[b2, d2, s2] = glmfit(x,[y n],'binomial','Link','logit');%fitting to reduce the error
[yfit2, ciLO2, ciHI2] = glmval(b2,x,'logit',s2);
figure;
plot(x,y./n,'o')
hold on
plot(x,yfit,'r-')
plot(x,yfit2,'b-')
set(gca,'XLim',[min(x) max(x)]);
xlabel('Stimulus Hue');
ylabel('Reddish <-    Proportion    -> Greenish');
legend('Measured Data','Probit fit','Logit fit','Location','NorthWest')
xticks([210:7.5:270])

%---normCDF with minimizer
x = tblStats.Hue;
y = tblStats.FreqGreen;
n = tblStats.numel_Resp;
params.x = x;
params.y = y./n;
opts = optimoptions('fminunc');
sol0 = [mean(x), (max(x)-min(x))/2]; % starting guesses for mu and sigma
sol = fminunc(@normcdf_minimizer,sol0,opts,params);
yfit = normcdf(x,sol(1),sol(2));
figure
plot(params.x,y./n,'o')
hold on;
plot(params.x,yfit,'b-');

%----confidence intervals
x = tblStats.Hue;
y = tblStats.FreqGreen;
n = tblStats.numel_Resp;
[b, d, s] = glmfit(x,[y n],'binomial','Link','probit');%std,variance
[yfit, ciLO, ciHI] = glmval(b,x,'probit',s);%low,high confidence value.
figure;
plot(x,y./n,'o',x,yfit,'r-')%more observer= lower confident interval
hold on
set(gca,'XLim',[min(x) max(x)]);%n=number of tounfd

plot(x,(yfit-ciLO),'--b')
plot(x,(yfit+ciHI),'--b')
xlabel('Stimulus Hue');
ylabel('Reddish <-    Proportion    -> Greenish');
legend('Measured Data','Probit fit','95% CI','Location','NorthWest')
xticks([210:7.5:270])

%% Yellow
yeltest=test(test.inp==1,2:3);
tblStats = grpstats(yeltest,{ 'Hue'},...
               {'mean' 'std' 'numel'})
tblCount = grpstats(yeltest,{ 'Hue', 'Resp'}) %notice this doesnt show every group
%computing count and proportions from table data
tblStats.FreqGreen = tblStats.mean_Resp.*tblStats.numel_Resp;
tblStats.FreqRed = tblStats.numel_Resp-tblStats.FreqGreen;
tblStats.Prop = tblStats.FreqGreen./tblStats.numel_Resp; %notice same as mean_Resp since its 0-1

%-------final probit plot with CIs, threshold, etc
x = tblStats.Hue;
y = tblStats.FreqGreen;
n = tblStats.numel_Resp;
[b, d, s] = glmfit(x,[y n],'binomial','Link','probit');
[yfit, ciLO, ciHI] = glmval(b,x,'probit',s);
figure;
plot(x,y./n,'o',x,yfit,'r-')
hold on
Thresh = interp1(yfit,x, .5);
set(gca,'XLim',[min(x) max(x)]);
plot(x,(yfit-ciLO),'--b')
plot(x,(yfit+ciHI),'--b')
plot([x(1) Thresh],[.5 .5],'k--');
plot([Thresh Thresh],[.5 0],'k--');
text(Thresh,min(get(gca,'YLim')),...
    [' Unique Hue @ ' num2str(Thresh)],...
    'HorizontalAl','left',...
    'VerticalAl','bottom',...
    'Color','k','fontsize',12);
title('My Unique Yellow')
xlabel('Stimulus Hue');
ylabel('Reddish <-    Proportion    -> Greenish');
legend('Measured Data','Probit fit','95% CI','Location','Best')
xticks([78:3:102])

%plot just raw data
% scatter(huesort(91:180,1),ressort(91:180,1))
% ylim([-.1,1.1])
% xlabel('Stimulus Hue');
% ylabel('(0=reddish)     Response      (1=greenish)')
% xticks([60:6.25:110])

%plot just probability
x = tblStats.Hue;
y = tblStats.FreqGreen;
n = tblStats.numel_Resp;
figure;
plot(x,y./n,'o')
hold on
set(gca,'XLim',[min(x) max(x)]);
xlabel('Stimulus Hue');
ylabel('Reddish <-    Proportion    -> Greenish');
xticks([60:6.25:110])

%-------probit vs logit
x = tblStats.Hue;
y = tblStats.FreqGreen; %frequency
n = tblStats.numel_Resp;%number of total responses
[b, d, s] = glmfit(x,[y n],'binomial','Link','probit');%glm-general linear model
[yfit, ciLO, ciHI] = glmval(b,x,'probit',s);
[b2, d2, s2] = glmfit(x,[y n],'binomial','Link','logit');%fitting to reduce the error
[yfit2, ciLO2, ciHI2] = glmval(b2,x,'logit',s2);
figure;
plot(x,y./n,'o')
hold on
plot(x,yfit,'r-')
plot(x,yfit2,'b-')
set(gca,'XLim',[min(x) max(x)]);
xlabel('Stimulus Hue');
ylabel('Reddish <-    Proportion    -> Greenish');
legend('Measured Data','Probit fit','Logit fit','Location','NorthWest')
xticks([60:6.25:110])

%---normCDF with minimizer
x = tblStats.Hue;
y = tblStats.FreqGreen;
n = tblStats.numel_Resp;
params.x = x;
params.y = y./n;
opts = optimoptions('fminunc');
sol0 = [mean(x), (max(x)-min(x))/2]; % starting guesses for mu and sigma
sol = fminunc(@normcdf_minimizer,sol0,opts,params);
yfit = normcdf(x,sol(1),sol(2));
figure
plot(params.x,y./n,'o')
hold on;
plot(params.x,yfit,'b-');

%----confidence intervals
x = tblStats.Hue;
y = tblStats.FreqGreen;
n = tblStats.numel_Resp;
[b, d, s] = glmfit(x,[y n],'binomial','Link','probit');%std,variance
[yfit, ciLO, ciHI] = glmval(b,x,'probit',s);%low,high confidence value.
figure;
plot(x,y./n,'o',x,yfit,'r-')%more observer= lower confident interval
hold on
set(gca,'XLim',[min(x) max(x)]);%n=number of tounfd

plot(x,(yfit-ciLO),'--b')
plot(x,(yfit+ciHI),'--b')
xlabel('Stimulus Hue');
ylabel('Reddish <-    Proportion    -> Greenish');
legend('Measured Data','Probit fit','95% CI','Location','NorthWest')
xticks([60:6.25:110])


