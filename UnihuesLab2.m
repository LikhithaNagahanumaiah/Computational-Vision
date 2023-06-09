%function out = generateRGBSamples(centerLCh, n, maxDeltah)
    % centerLCh: triplet with L* C h coordinates (you want to change h and leave L&C the same)
    % n: number of samples (actually will be n*2 + 1, so if n=4 you will get 9 colors)
    % maxDeltah: range of hue (actually will be h*2, so if n=25 you will get range of 50)
    % out: M by [R G B angle] matrix - will give you RGB values and hue

    %check Shamey 2019 (Fig.1 & Tabl.3) for some good starting points for
    %LCh values for each hue - we are using high Chroma colors & D65 as the lightsource
    
%generate wide range of blue samples 
%holding L(62) & C(30) constant, with h=240 in middle , 
blues = generateRGBSamples([62, 30, 240], 17, 30); %([one color value)], n+1 color patches(12*2)+1, delta hue(on both side);
%want lighness the same L,C,h values ;
%check gamut, range might be too big!(L*, chroma and hue values,(nu.of
%samples),range)

%plot the wide range of blue samples
Hf = figure;
for i = 1:length( blues )
    subplot(7,5,i);%plotting all patches in a figure
patch([0,1,1,0],[0,0,1,1],blues(i,1:3),'EdgeColor','none')
set(gca,'Visible','off')
text(0,.9,num2str(round(blues(i,4))),'FontSize',6);
end

%now look at the plot and pick:
% - a center that looks like it could be a unique blue (no mix of red/green)
    % maybe 260? maybe different for you
% - endpoints that should 100% look green or red - these should be equally spaced from the center
    % maybe 235 & 285? maybe different for you. Also keep in mind that
    % colors look different presented next to eachother than when isolated!

%now make 9 patches that are equally spaced in hue between the low end, center, and high end
MYblues = generateRGBSamples([62, 30, 240], 4, 30); %240 is center, 4*2+1=9, 240 +/-30 = 210-270 

%double check these choices in a plot
Hf = figure;
for i = 1:length( MYblues )
    subplot(3,3,i);%plotting 9 patches from greenish to reddish
patch([0,1,1,0],[0,0,1,1],MYblues(i,1:3),'EdgeColor','none')
set(gca,'Visible','off')
text(0,.9,num2str(round(MYblues(i,4))),'FontSize',12);
end
%if they look good, these are the blue stimuli for your experiment!


%% same thing for yellows:

%generate wide range of yellow samples
%holding L(75) & C(75) constant, with h=90 in middle

yels = generateRGBSamples([70, 50, 85], 17, 30); %17*2+1=35 patches used to select unique hue

%plot the wide range of yellow samples
Hf = figure;
for i = 1:length( yels )
    subplot(7,5,i);
patch([0,1,1,0],[0,0,1,1],yels(i,1:3),'EdgeColor','none')
set(gca,'Visible','off')
text(0,.9,num2str(round(yels(i,4))),'FontSize',12);
end

%now look at the plot and pick:
% - a center that looks like it could be a unique yellow (no mix of red/green)
    % maybe 90? maybe different for you
% - endpoints that should 100% look green or red - these should be equally spaced from the center
    % maybe 235 & 285? maybe different for you
    
    %now make 9 patches that are equally spaced in hue between the low end, center, and high end
MYyels = generateRGBSamples([70, 50, 85], 4, 25); %90 is center, 4*2+1=9, 90 +/-12.5 = 78-103(ish) 

%double check these choices in a plot
Hf = figure;
for i = 1:length( MYyels )
    subplot(3,3,i);
patch([0,1,1,0],[0,0,1,1],MYyels(i,1:3),'EdgeColor','none')
set(gca,'Visible','off')
text(0,.9,num2str(round(MYyels(i,4))),'FontSize',12);
end
%if they look good, these are the yellow stimuli for your experiment!

%% another look at your stimuli
MYbluesLAB = rgb2lab(MYblues(:,1:3));%converting rgb to lab 
MYyelsLAB = rgb2lab(MYyels(:,1:3));
figure;%plotting Lab values of a*b* graph.  
scatter(MYbluesLAB(:,2),MYbluesLAB(:,3),60,MYblues(:,1:3),'filled')
hold on
scatter(MYyelsLAB(:,2),MYyelsLAB(:,3),60,MYyels(:,1:3),'filled')
axis equal
axis([ -60 60, -60 60 ]);
plot([0 0],get(gca,'YLim'),'k--');
plot(get(gca,'XLim'),[0 0],'k--');
xlabel('a*'); ylabel('b*');title('My Hues');
