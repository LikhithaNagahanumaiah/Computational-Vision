% load the data
load('cvs_lab3_dispdata.mat') 

% display model parameters: black (flare), matrix, LUT (EOTF)
kindex = find(all(rgb==0,2)) %black index: find all rgbs = [0 0 0]
windex = find(all(rgb==255,2)) %white index: find all rgbs = [255 255 255]
pindex(1,1)= find(all(rgb==[255 0 0],2));
pindex(2,1)= find(all(rgb==[0 255 0],2));
pindex(3,1)= find(all(rgb==[0 0 255],2));


%pindex = [29; 58; 87] %primary index: find rgb = [255 0 0; 0 255 0; 0 0 255] you have to find the rows corresponding to these in rgb

kXYZ = mean(xyz(kindex,:)) %mean of black XYZ measurements
%wXYZ = mean(xyz(windex,:))  %mean of white XYZ measurements
wXYZ = xyz(windex,:) %white XYZ

xyz2 = xyz - repmat(kXYZ,length(xyz),1) %removing black from rest of measurements

M = xyz2(pindex,:)' %primary matrix

%create EOTF curves from gray-ramp data
grayRGB = ( M \ xyz2(157:208,:)' )'; % index (157 to 208) matches your gray ramp data.
LUT = interp1(rgb(157:208,1),grayRGB,(0:255)); %interpolate to span full 0-255 range
%% plot EOTF- 3x1D LUTs
figure
plot (0:255,LUT)
xlabel('Digital Code Value');ylabel('Linear RGB');title('EOTF')
xlim([0 255]); ylim([0 1])
% forward model
RGB = [200, 100, 50]; %input an RGB value
RGBlin=zeros(size(RGB));
for i = 1:3           %use the LUT to get a linear RGB value
    RGBlin(i) = LUT((RGB(i)+1),i);
end
XYZest = ( M .* RGBlin' )' + kXYZ; % predicted XYZ output for RGB driving display.
%reverse model- Here I separetly put the 6 values step by step and then took out one by one.
XYZ = [11, 22, 3]; %this a target XYZ value.
XYZ2=XYZ-kXYZ;
RGBlinest = (inv(M) * XYZ2' )';
[~,idx]=min(abs(RGBlinest-LUT));
RGBest = idx-1;        %this is the predicted RGB input to display the target XYZ value
%% error between measured and predicted XYZ in CIEDE2000
% forward model for "verification" colors - colors after the ramps
RGB = rgb(209:333,:); %RGB inputs for verification colors
XYZ = xyz(209:333,:); % XYZ for verification colors
RGBlin=zeros(size(RGB));
for i = 1:3           %convert to linearRGB
    RGBlin(:,i) = LUT((RGB(:,i)+1),i);
end
XYZest = ( M * RGBlin' )' + kXYZ;    %use matrix to predict XYZ.
%calculate error in deltaE00 between measured and predicted XYZs
%XYZn = xyz(ones(length(lambda),1)
XYZn = [95.0438;100;108.8368]';  %white point.   
error = deltaE00(lab(XYZ',XYZn),lab(XYZest',XYZn)); %using function 'lab' to convert XYZ to LAB
meanDE=mean(error) %mean, min, and max DE
minDE=min(error)
maxDE=max(error)
%plot the DE error between measured and predicted XYZ
figure
hist(error,35)
hold on
plot([meanDE meanDE],get(gca,'YLim'),'r--');
text(meanDE*1.05,max(get(gca,'YLim'))*0.8,...
    ['Mean \DeltaE^*_{00} = ' num2str(meanDE)],...
    'HorizontalAl','left',...
    'VerticalAl','bottom',...
    'Color','r');
xlabel('DeltaE');ylabel('freq')
% The higher the DE, the more colorimetric error.
% DE < 1 is likely imperceptible by the human eye, and considered very good.
% DE 1-2 may be borderline perceptible, but likely not noticeable in most condi
%% plot some chromaticity coordinates (small xyz) in xy chromaticity space
% load CIE cmf2
data = xlsread('StdObsFuncs.xls'); wl = data(:,1); cmf2 = data(:,2:4);
% compute the spectral locus in xy chromaticitiy space.
% cmf2 is the XYZ of each wavelength
sl_xy(:,1) = cmf2(:,1)./(cmf2(:,1)+cmf2(:,2)+cmf2(:,3)); %computing x
sl_xy(:,2) = cmf2(:,2)./(cmf2(:,1)+cmf2(:,2)+cmf2(:,3)); %computing y
%xy of all measured XYZ colors
all_xy(:,1) = (xyz(:,1)./(xyz(:,1)+xyz(:,2)+xyz(:,3)));
all_xy(:,2) = (xyz(:,2)./(xyz(:,1)+xyz(:,2)+xyz(:,3)));
% make the plots
slRGB = xyz2rgb(cmf2);     
slRGB = min(max(slRGB,0),1);
figure
hold on
box on
for i = 2:length(wl)
    plot(sl_xy([i-1 i],1),sl_xy([i-1 i],2),'Color',slRGB(i,:))
end
plot(all_xy(:,1),all_xy(:,2),'kx');
xlabel('x'); ylabel('y');
axis equal
axis([0 .8 0 .9])
grid on
set(gca,'Color',[.9 .9 .9],'GridColor','w','GridAlpha',1)
set(gca,'TickDir','out')
set(gca,'FontSize',12)
%% more plots
%primary plot
allcolors=xyz2rgb(xyz./100);
xy_p = all_xy([pindex],:);
xy_p(4,:)=xy_p(1,:); %making it repeat 1st color to make triangle connect
primcolors=allcolors([pindex],:);
primcolors(4,:)=primcolors(1,:); %
primcolors = min(max(primcolors,0),1);
slRGB = xyz2rgb(cmf2);     
slRGB = min(max(slRGB,0),1);
figure
hold on
box on
for i = 2:length(wl)
    plot(sl_xy([i-1 i],1),sl_xy([i-1 i],2),'Color',slRGB(i,:))
end
plot(xy_p(:,1),xy_p(:,2),'-k'); %gamut
for ii = 1:length(xy_p)
    plot(xy_p(ii,1),xy_p(ii,2),'Color',primcolors(ii,:),'Marker','.','MarkerSize',20)
end
xlabel('x'); ylabel('y');
axis equal
axis([0 .8 0 .9])
grid on
set(gca,'Color',[.9 .9 .9],'GridColor','w','GridAlpha',1)
title('Primary Chromaticity')
set(gca,'TickDir','out')
set(gca,'FontSize',12)
%ramp plot
ramp_xy = all_xy([1:87],:);
rampcolors=allcolors([1:87],:);
rampcolors = min(max(rampcolors,0),1);
figure
hold on
box on
for i = 2:length(wl)
    plot(sl_xy([i-1 i],1),sl_xy([i-1 i],2),'Color',slRGB(i,:))
end
plot(xy_p(:,1),xy_p(:,2),'-k'); %gamut
for ii = 1:length(ramp_xy)
    plot(ramp_xy(ii,1),ramp_xy(ii,2),'Color',rampcolors(ii,:),'Marker','x','MarkerSize',5)
end
xlabel('x'); ylabel('y');
axis equal
axis([0 .8 0 .9])
grid on
set(gca,'Color',[.9 .9 .9],'GridColor','w','GridAlpha',1)
title('Ramp Chromaticity')
set(gca,'TickDir','out')
set(gca,'FontSize',12)
%verification plot
ver_xy = all_xy([117:end],:);
vercolors=allcolors([117:end],:);
vercolors = min(max(vercolors,0),1);
figure
hold on
box on
for i = 2:length(wl)
    plot(sl_xy([i-1 i],1),sl_xy([i-1 i],2),'Color',slRGB(i,:))
end
plot(xy_p(:,1),xy_p(:,2),'-k'); %gamut
for ii = 1:length(ver_xy)
    plot(ver_xy(ii,1),ver_xy(ii,2),'Color',vercolors(ii,:),'Marker','x','MarkerSize',5)
end
xlabel('x'); ylabel('y');
axis equal
axis([0 .8 0 .9])
grid on
set(gca,'Color',[.9 .9 .9],'GridColor','w','GridAlpha',1)
title('Verification Chromaticity')
set(gca,'TickDir','out')
set(gca,'FontSize',12)
%% Question 8
load('LikiJulia.mat')
primaries(1,1)= 2
primaries(2,1)= 3
primaries(3,1)= 4
%xy of all measured XYZ colors
xy_(:,1) = (measXYZ(:,1)./(measXYZ(:,1)+measXYZ(:,2)+measXYZ(:,3)))
xy_(:,2) = (measXYZ(:,2)./(measXYZ(:,1)+measXYZ(:,2)+measXYZ(:,3)))
allcolors=xyz2rgb(measXYZ./100);

% make the plots
%1) the spectral locus
figure
hold on
box on
for i = 2:length(wl)
    plot(sl_xy([i-1 i],1),sl_xy([i-1 i],2),'Color',slRGB(i,:))
end
plot(xy_(:,1),xy_(:,2),'kx');
xlabel('x'); ylabel('y');
axis equal
axis([0 .8 0 .9])
grid on
set(gca,'Color',[.9 .9 .9],'GridColor','w','GridAlpha',1)
set(gca,'TickDir','out')
set(gca,'FontSize',12)

% plot 2
xy_p = xy_([primaries],:)
xy_p(4,:)=xy_p(1,:) 
primcolors=allcolors([primaries],:)
primcolors(4,:)=primcolors(1,:) %
primcolors = min(max(primcolors,0),1) 
slRGB = xyz2rgb(cmf2);     
slRGB = min(max(slRGB,0),1); 
figure
hold on
box on
for i = 2:length(wl) % SL
    plot(sl_xy([i-1 i],1),sl_xy([i-1 i],2),'Color',slRGB(i,:))
end
plot(xy_p(:,1),xy_p(:,2),'-k'); %gamut
for ii = 1:length(xy_p)
    plot(xy_p(ii,1),xy_p(ii,2),'Color',primcolors(ii,:),'Marker','.','MarkerSize',20)
end
xlabel('x'); ylabel('y');
axis equal
axis([0 .8 0 .9])
grid on
title('Primary Chromaticity')
set(gca,'Color',[.9 .9 .9],'GridColor','w','GridAlpha',1)
set(gca,'TickDir','out')
set(gca,'FontSize',12)

%ramp plot- plot 3
ramp_xy = xy_([6:87],:);
rampcolors=allcolors([6:87],:);
rampcolors = min(max(rampcolors,0),1);
figure
hold on
box on
for i = 2:length(wl)
    plot(sl_xy([i-1 i],1),sl_xy([i-1 i],2),'Color',slRGB(i,:))
end
plot(prim_xy(:,1),prim_xy(:,2),'-k'); %gamut
for ii = 1:length(ramp_xy)
    plot(ramp_xy(ii,1),ramp_xy(ii,2),'Color',rampcolors(ii,:),'Marker','x','MarkerSize',5)
end
xlabel('x'); ylabel('y');
axis equal
axis([0 .8 0 .9])
grid on
set(gca,'Color',[.9 .9 .9],'GridColor','w','GridAlpha',1)
title('Ramp Chromaticity')
set(gca,'TickDir','out')
set(gca,'FontSize',12)
