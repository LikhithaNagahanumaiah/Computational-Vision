function LikhithaNLab4gui()


% stimuli
addpath(pwd,'images') %add subfolder with images to path
gd.files = dir(fullfile(pwd,'images/*.jpg')); %directory of image files
%setup stimuli trackers
gd.pairs = []; %empty matrix
LM1 = [nchoosek(1:6,2)];
LM2 = [nchoosek(7:11,2)];
LM3 = [nchoosek(12:16,2)];
LM4 = [nchoosek(17:22,2)];
LM5 = [nchoosek(23:28,2)];
LM6 = [nchoosek(29:35,2)];

% repetitions

gd.pairs = [LM1;LM2;LM3;LM4;LM5;LM6]; %arranged in pairs
gd.pairs = repmat(gd.pairs,2,1); %making replications

%random the order

randorder = randperm(length(gd.pairs))';
for i = 1:length(gd.pairs)
    gd.randpairs(i,:) = (gd.pairs(randorder(i),:));
end
gd.Ntrials = length(gd.pairs); % Ntrials- total number of trials

% create and maximize figure, remove menus 
gd.Hf = figure;
set(gd.Hf,'Position',get(groot,'ScreenSize'))
set(gd.Hf,'Menubar','none')
gd.Hf.Color = [.5 .5 .5];

% create two axes in which to display images
gd.Ha(1) = axes('Position',[.05 .1 .44 .7],'Box','off');
gd.Ha(2) = axes('Position',[.51 .1 .44 .7],'Box','off');
set(gd.Ha,'Visible','off');
  
% create a text box for instructions
gd.Ht = uicontrol('Style','text',...
        'Units','normalized',...
        'Position',[.05 .9 .9 .08],...
        'BackgroundColor',[.5 .5 .5],...
        'FontSize',14,'FontName','Arial',...
        'String','Press S to start the experiment');
    
% prepare to store observer data required for analysis
gd.trial = 1;  %current trial number
gd.obsData = gd.randpairs; %first 2 cols of data will be the pairs, the 3rd column will be the observer response (added later)

% assign keyboard callback (what to do when keys are pressed)
set(gd.Hf,'KeyPressFcn',@demoGuiKeys);

% store guidata
guidata(gd.Hf,gd)

end
% this is the end of the GUI construction


% demoGuiKeys: handles keyboard input while
% the GUI is "in focus" on the screen
function demoGuiKeys(HObj,EvtData)
    gd = guidata(HObj)

    switch EvtData.Key
            
        % s key: start the experiment
        case 's'
            % display first trial
            gd = displayImages(gd); %this calls another subfunction (see below, what does this do?)
            gd.Ht.String = 'Choose the image you like more using left or right arrow keys';
            
        % left arrow: if selected left image
        case 'leftarrow'
           % clear the images
           set(get(gd.Ha(1),'children'),'visible','off')
           set(get(gd.Ha(2),'children'),'visible','off') 
           
            % record the selection
            disp('leftarrow');
            gd.obsData(gd.trial,3) = gd.Lresp; %this is pre-defined in the subfunction below
            
            % increment trial
            gd.trial = gd.trial+1;
            
            % save data
            obsData = gd.obsData;
            
            % pause between stimuli
            pause(1);
            
            % go to next trial if there is one
            if gd.trial <= gd.Ntrials
                gd = displayImages(gd);
            else
                % or else finish up
                fileName = sprintf('LikhithaLab4Data2%s.xls', datestr(now,'mm-dd-yyyy HH_MM_SS')); %set a file name according to date
                writematrix(gd.obsData, fileName)    %save the data to a file
                close(HObj)
                return
            end
        
        % right arrow: select right image
        case 'rightarrow'
            % clear the images
            set(get(gd.Ha(1),'children'),'visible','off')
            set(get(gd.Ha(2),'children'),'visible','off') 
            
            % record the selection
            disp('rightarrow');
            gd.obsData(gd.trial,3) = gd.Rresp; %this is the only thing that changes for 'rightarrow'
            
            % increment trial
            gd.trial = gd.trial+1;
            
            % save data
            obsData = gd.obsData;
            
            % pause between stimuli
            pause(1);
            
            % go to next trial if there is one
            if gd.trial <= gd.Ntrials
                gd = displayImages(gd);
            else
                % finish
                fileName = sprintf('LikhithaLab4Data2%s.xls', datestr(now,'mm-dd-yyyy HH_MM_SS'));
                writematrix(gd.obsData, fileName)   
                close(HObj)
                return
            end
        
        % esc: close figure and quit
        case 'escape'
            close(HObj)
            return
        otherwise
            % do nothing
    end
       
    guidata(gd.Hf,gd)
end
% end of demoGuiKeys


% displayImages: displays images on the axes, sets up the randomly selected
% side of screen (which side of the screen is each image on?), and
% pre-defines the possible responses (saves the image number according to
% the random side of screen). 
function gd = displayImages(gd)
% argument: 
%   gd: struct of userdata for GUI
    
    % random left-right presentation
    gd.side = ceil( rand(1)*2 ); %will either be 1 or 2 each trial
    if gd.side == 1    %will decide which image will be on which side
        side = [1 2];  % im1Left, im2Right
    else
        side = [2 1];  % im2Left, im1Right
    end
    
    % display images 
    axes(gd.Ha(1));
    imshow(gd.files(gd.randpairs(gd.trial,side(1))).name) %picks one of the image pairs from 'side'
    
    axes(gd.Ha(2));
    imshow(gd.files(gd.randpairs(gd.trial,side(2))).name) %picks the other of the image pairs from 'side'
    
    %pre-define reponses
    gd.Lresp = gd.randpairs(gd.trial,side(1)) %saves which image the observer picked if they choose 'left'
    gd.Rresp = gd.randpairs(gd.trial,side(2)) %saves which image the observer picked if they choose 'right'

end
% end of displayImages