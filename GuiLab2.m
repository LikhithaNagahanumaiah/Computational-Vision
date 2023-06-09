%%GUI to find unique blue and yellow with the method of constant stimuli output:
function LikhithaNguiLab2()

% first column is 0 for blue stimuli, 1 for yellow;
% second column is the stimulus hue value, corresponding to col 4 in gd.blueStim or gd.yellowStim;
%third column is the response-:0 for greenish and 1 for reddish
% create a fig at given position, with mentioned colors and other characters
gd.Hf = figure('Position',[200,200,500,400], 'Color',[.5 .5 .5], 'units','normalized','outerposition',[0 0 1 1]);  
% create text for the experiment left-greenish and right for redish
gd.InstructText = '<< left arrow << GREEN-ish  Esc to end   RED-ish >> right arrow >>';
%%initialize text
gd.Ht = text(.5,.8,gd.InstructText,'HorizontalAl','center','FontSize',24);  
axis off; axis equal;  
% create axes for yellow and blue color patches
gd.Ha = axes('Position',[.35 .3 .3 .4]);
%set the axes and turn off ticks

set(gd.Ha,'XColor','none','YColor','none');


% create color data for process
gd.blueStim = generateRGBSamples([62, 30, 240], 4, 30); %setting my blue colors to be these 4,4 extremes RGB-hue
gd.yellowStim = generateRGBSamples([70, 50, 85], 4, 25); %setting my yellow colors to be these 4,4 extremes RGB-hue

% create data structure
gd.stim = [gd.blueStim; gd.yellowStim]  ; %combining blues and yellows into 1 array
rep = 10  ; %repeate 10 times
gd.by = repmat([zeros(9,1); ones(9,1)],rep,1); %9 for yellows and 9 for blues
x = 1:length(gd.stim);
for i = 1:rep %making trial index starting with 1 with repetation
 gd.randOrd(x,:) = [randperm(9)'; (randperm(9)+9)']; % create both blue and yellow stimuli sets at random order

x = x+length(gd.stim);
end
gd.i = 1; % index starting with 1
gd.data = zeros(180,3); %create data container
% setting first patch color to be the first color
set(gd.Ha,'Color',gd.stim(gd.randOrd(gd.i),1:3))  % columns 1-3
%store variables in figure's GUIdata
guidata(gd.Hf,gd)
%assign keyboard callback
set(gd.Hf,'KeyPressFcn',@myKeyPress )
end

%after pressing a key
function myKeyPress(HObj,EvtData)
 %grab the updated guidata
gd = guidata(HObj)
switch(EvtData.Key) %after pressed- specific keys
 %left pressed: record 0 and set next patch color
  case('leftarrow')
    resp=0; %the response will be coded as 0
    %put into the data 1-0\1 2-hue 3-resp
    gd.data(gd.i,:)=[gd.by(gd.i), gd.stim(gd.randOrd(gd.i),4), resp];
   
   %change patch color
    gd.i = gd.i+1; % increase +1 trails
    if gd.i <= 180 %all the trials
        %change the patch color to the next random color in gd.stim
      set(gd.Ha,'Color',gd.stim(gd.randOrd(gd.i),1:3))
      set(gca, 'visible', 'off')
      pause(1);% pause for a second before next stimuli appears
      set(gca,'visible', 'on')
    else
      disp ('done!'); %show done
      disp(gd.data); % display all the data
      fileName = sprintf('LN%s.xls', datestr(now,'mm-dd-yyyy HH_MM_SS')) % create xls file with information
      writematrix(gd.data, fileName)%writing response into file
      close(HObj)  % close GUI
      return    
    end
    %left pressed: record 0 and set next patch color
  case('rightarrow')
    resp=1; %response value 1
    gd.data(gd.i,:)=[gd.by(gd.i), gd.stim(gd.randOrd(gd.i),4), resp];% data- 1-correct 0,1, 2-hue 3-resp
    gd.i = gd.i+1; %trail increments
    if gd.i <= 180 % For 180 trail
      %change the patch color to the next random color in gd.stim  
      set(gd.Ha,'Color',gd.stim(gd.randOrd(gd.i),1:3))
      set(gca, 'visible', 'off')
      pause(1);
      set(gca,'visible', 'on')
    else
      disp ('done!'); % display done
      disp(gd.data); % display data
      fileName = sprintf('LN%s.xls', datestr(now,'mm-dd-yyyy')) % create file with name and information
      writematrix(gd.data, fileName)
      close(HObj)  
      return    
    end
  case('escape') %ways to exit the gui or do nothing if other keys are pressed
      % write data to xls file
      fileName = sprintf('LN%s.xls', datestr(now,'mm-dd-yyyy'))
      writematrix(gd.data, fileName)
      close(HObj)
      return
  otherwise
      %do nothing if any key besides left or right are pressed.
end
guidata(HObj,gd)
end
