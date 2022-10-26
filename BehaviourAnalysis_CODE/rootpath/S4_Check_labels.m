%% David Madrid . Last Rev 05/05/2022

% Detection of type of experiment

SIEorSW = strfind(Name,'ES');
if isempty (SIEorSW)
    TypeExperiment = 'SW';
else
    TypeExperiment = 'ES';
end

%Loading or not the video: 

if isequal(TypeExperiment,'SW') % Long videos, it would take a lot of time to load it
    % if the sampling rate is constant just put it. Normally this is for
    % swimming videos with a lot of frames

    vidObj.FrameRate = 60;
 implay(fullfile(DLC_directory,PathORVideo));


else % otherwise, normally SIE videos, are short videos and its fine 


    %% 1. Checking how good is the DLC labelling
    vidObj = VideoReader(fullfile(DLC_directory,PathORVideo)); % Importing original video
    implay(fullfile(DLC_directory,PathORVideo)); 


% 
% 
%     prompt = {strcat('Do you want to check some specific frames? (Total number of frames: '...
%         ,sprintf('%.0f',vidObj.NumFrames),')'),'If yes, which frame'};
%     dlgtitle = 'Input';
%     dims = [1 35];
% 
%     definput ={'N',sprintf('%.0f',0)};
%     answer = inputdlg(prompt,dlgtitle,dims,definput);
%     answerText = char(answer(1));
%     fr = str2double(answer(2)); % frame number
%     I = read(vidObj);
%     %imtool(I(:,:,1,1))
%     clear I;
% 
%     % Coloring and numering vectors
%     colours = [	'r' 'g' 'b' 'c' 'm' 'y' 'k' 'r' 'g' 'b'];
%     VecNames = ['v1' 'v2' 'v3' 'v4' 'v5' 'v6' 'v7' 'v8' 'v9' 'v10'];
% 
% 
% 
%     if isequal(answerText,'Y') ||  isequal(answerText,'y') && fr~=0
%         I = read(vidObj,(fr)); % Reading video
%         fig = figure;
%         imagesc(I)
%         % imtool(I)
%         hold on
%         scatter(Coor3D(:,1,fr),Coor3D(:,2,fr));
%         % line(Coor3D(:,1,fr),Coor3D(:,2,fr));
% 
%         % Just with lines
%         for i = 1:10-1
%             plot([Coor3D(i,1,fr),Coor3D(i+1,1,fr)],[Coor3D(i,2,fr),Coor3D(i+1,2,fr)],'Color',colours(i),'LineWidth',2 )
%         end
% 
%         % Just with arrows
%         for i = 1:10-1
%             arrow([Coor3D(i+1,1,fr),Coor3D(i+1,2,fr)],[Coor3D(i,1,fr),Coor3D(i,2,fr)],1,30,60,'Color',colours(i) )
%         end
% 
% 
%         %     %median filer
%         %     j = medfilt1(Coor3D(:,2,fr));
%         %     line(Coor3D(:,1,fr),j)
%         %
%         %
%         %     %spline cubir interpolation
%         %     xx = linspace(Coor3D(1,1,fr),Coor3D(end,1,fr),10);
%         %     s = spline(Coor3D(:,1,fr),Coor3D(:,2,fr),xx);
%         %     plot(xx,s,'r')
% 
%         waitfor(fig) % Waiting to close for continuing
% 
%     elseif isequal(answerText,'N') ||  isequal(answerText,'n')
% 
%     elseif fr>vidObj.NumFrames
%         error(strcat('The frame selected exceeds the total number of frames:',sprintf('%.0f',vidObj.NumFrames)))
%     elseif fr<vidObj.NumFrames
%         error('Frames can not be negative')
%     elseif fr==0
%         error(strcat(sprintf('%.0f', 0),' does not exist as a frame'))
%     else
%         error('Something went wrong')
%     end


end


