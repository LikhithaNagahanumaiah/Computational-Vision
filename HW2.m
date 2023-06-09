%% Question 1: Data file input and plotting
% 1a.
close all
clear all
x1 = xlsread('MacBethColorChecker.xls');
[x,txt] = xlsread('MacBethColorChecker.xls');
%1b.
wl = x(2:end,1); %Wavelength from 2nd row to end row and only 1st column   
CCref = x(2:end,2:25);%extracting remaining values except the 1st row and 1st column
figure;
plot(wl,CCref)
xlabel('wavelength (nm)');
ylabel('reflectance factor');
%1c.
MeanRef = mean(CCref); %caluculating the mean using incuilt function
%1d.
figure;
plot(MeanRef)
xlabel(' 24 patches');
ylabel('Mean Reflectance');
title('Average Reflectance for each 24 patches')
%patch 16, 19,20 has the highest peak,as the luminance of those colors are
%higher than other patches. 
% 1e.
yel = find(wl == 570)%finding the position of the wavelength
%1f plot reflectace at 570nm for 24 patches
figure;
plot(CCref(yel,:)) %plotting for all patches at 570nm
xlabel(' 24 patches');
ylabel(' Reflectance(570nm)');
title('Reflectance at 570nm for each patch')

%The patches 12,16,19,20, have higher reflectance at 570nm, as bright
%objects reflect mlre light may be ?

%% Question 2: Image reading, data, and plotting
%2a.
imgSRGB = imread('MCC24.jpg');%read image
%2b.
figure;
imshow(imgSRGB)%display image
%2c.
figure;
imshow(imgSRGB(:,:,3));%display image without color dimesion
title('B dimension')
%2d.
imgXYZ = rgb2xyz( imgSRGB );
%2e.
figure;
imshow(imgXYZ(:,:,2))
title('Y channel')%16,19,20
%Y channel represents the luminance that is the amount of brightness in an
%image, patch 16 and 19 and 20 has more mean value than other patches therefore we
%can see those patches luminance level in this image 


