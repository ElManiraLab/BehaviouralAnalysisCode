%% David Madrid . Last Rev 05/05/2022 

%% 1.  Vector Calculation and matrices creation

Vec3D = NaN(9,2,length(frames)); 
for i = 1:size(Vec3D,1)
   Vec3D(i,1,:) = Coor3D(i,1,:)-Coor3D(i+1,1,:);
   Vec3D(i,2,:) = Coor3D(i,2,:)-Coor3D(i+1,2,:);
end 

% % OPTIONAL: arrows from the origin for a specific frame (fr)
%  figure
%  fr = ;
%  for i = 1:size(Vec3D,1)
%  arrow([0,0],[Vec3D(i,1,fr),-Vec3D(i,2,fr)],10,30,60,3,'Color',colours(i)),hold on
%  end 

%% 2. Calculation of the Angle

    %{
    
    % 1. Using dot product. ALL CONSECUTIVE BODY PARTS
    % VECTORS
     Ang3D = NaN(8,1,length(frames));
     for i = 1:size(Vec3D,1)-1
         Ang3D(i,1,:)= acos(((Vec3D(i,1,:).*Vec3D(i+1,1,:))+(Vec3D(i,2,:).*Vec3D(i+1,2,:)))./...
             ((sqrt(Vec3D(i,1,:).^2 + Vec3D(i,2,:).^2)).*(sqrt(Vec3D(i+1,1,:).^2 + Vec3D(i+1,2,:).^2)))).*180/pi; 
     end 
    
     % Calculation of the ANGLE using dot product. TWO SELECTED BODY PARTS
     % VECTORS. (i.e. 1--> HEAD-HB  ;  9--> SC7-SC8)
     i = [1 9];
     AngHeadTail3D(1,1,:)= acos(((Vec3D(i(1),1,:).*Vec3D(i(2),1,:))+(Vec3D(i(1),2,:).*Vec3D(i(2),2,:)))./...
         ((sqrt(Vec3D(i(1),1,:).^2 + Vec3D(i(1),2,:).^2)).*(sqrt(Vec3D(i(2),1,:).^2 + Vec3D(i(2),2,:).^2)))).*180/pi;
    
    %}
    
    %2. 
% 
    % Using atan2d. ALL CONSECUTIVE BODY PARTS
    Ang3D = NaN(8,1,length(frames)); % Has positive and negative angles
    for i = 1:size(Vec3D,1)-1
         Ang3D(i,1,:)= atan2d(Vec3D(i,1,:).*Vec3D(i+1,2,:)-Vec3D(i,2,:).*Vec3D(i+1,1,:),...
             Vec3D(i,1,:).*Vec3D(i+1,1,:)+Vec3D(i,2,:).*Vec3D(i+1,2,:)); 
     end 
    
     % Using atan2d. TWO SELECTED BODY PARTS
     % VECTORS. (i.e. 1--> HEAD-HB  ;  9--> SC7-SC8)
     i = [1 9];
     AngHeadTail3D(1,1,:)= atan2d(Vec3D(i(1),1,:).*Vec3D(i(2),2,:)-Vec3D(i(1),2,:).*Vec3D(i(2),1,:),...
             Vec3D(i(1),1,:).*Vec3D(i(2),1,:)+Vec3D(i(1),2,:).*Vec3D(i(2),2,:)); 
    
     %Calculation of the matrix that contains the SUM of all ANGLE  for each
     %frame
     SumAng3D = sum(Ang3D);
     SumAng3DPosi = sum(abs(Ang3D)); % Has just positive angles
     % size(SumAng3DPosi)
     


 %% 3. Size of the dish

 %      3.1 Depending on a condition
 %{

 TempWeek = char(Name);
 WeekNumber = str2double(TempWeek(5));
 if isa(WeekNumber,'double')
     if WeekNumber<=4
         DishSize = 5; %cm
         Diameter = 705;  %PX
         ConverFact = DishSize / Diameter; %cm of one pixel

     elseif WeekNumber>=5 && WeekNumber<8
         DishSize = 8; %cm
         Diameter = 910;%PX
         ConverFact = DishSize / Diameter; %cm of one pixel

     elseif WeekNumber==8
         DishSize = 12; %cm
         Diameter = 1095;%PX
         ConverFact = DishSize / Diameter; %cm of one pixel

     else
         error('The number of the week is not between 1 and 8')
     end
 else
     error('The number of the week can not being read')
 end
 clear TempWeek

 %}

%      3.2 Constat for all trials

         DishSize = 8; %cm
         %imtool(I(:,:,1,1))
         Diameter = 910;%PX
         ConverFact = DishSize / Diameter; %cm of one pixel


 %% 4. Size of the fish

 % Size of the fish. Sum of the length [PIXEL] of each vector across frame
 % the size of the fish should remain more or less stable even if is bending

 temp = NaN(9,length(frames));
 for i=1:9
     temp(i,:) = sqrt(Vec3D(i,1,:).^2 + Vec3D(i,2,:).^2);
 end
 
 LengthAnimalVectorFrames = sum(temp); % Length [PIXEL] across time
 LengthAnimalFrames = mean( LengthAnimalVectorFrames); % Final length [PIXEL] is the average across time
 LengthAnimalStdFrames = std( LengthAnimalVectorFrames);

 % Control for bad frames labelling
 if LengthAnimalVectorFrames > (LengthAnimalFrames*0.15)+ LengthAnimalFrames 
     plot(LengthAnimalVectorFrames)
     ylabel('Length Animal')
     xlabel('Frames')
     error('Probably the labelling is not good. The length of the animal is changing too much')
 end 

 %% 5.Instantaneus distance travel for each point 

 DistancePixels = NaN(10,length(frames)-1); 
 VelocityFrames= NaN(1,length(frames)-1);


 % Each row is a body part each column is the parameter per each frame

 for j = 1:10 
     for i=1:length(frames)-1
         DistancePixels(j,1) = 0; % In the first frame the head doesnt travel
         DistancePixels(j,i+1) = sqrt((Coor3D(j,1,i+1)-Coor3D(j,1,i)).^2 + (Coor3D(j,2,i+1)-Coor3D(j,2,i)).^2); % [px]
     end


     %Instantaneus velocity
     
     for i=1:length(frames)-1
         VelocityFrames(j,1) = 0; % In the first frame the head doesnt travel
         VelocityFrames(j,i+1) = DistancePixels(j,i+1)/(1/vidObj.FrameRate); % [px/sec]
     end
 end

% if the head is moving more than 0.5 of the body length in consecutive
% frames will e consider has movement

% % plot(squeeze(SumAng3D))
%  Total_time_moving = find(DistanceBodyLenghtPer(1,:)>0.5); 


      %% Detecting if is an SW or SIE experiment

if isequal(TypeExperiment,'ES')
 
    % Case that is ESCAPE
    Thershold = 6; % For detecting C response
    %plot(DistancePixels(1,:))
    BaseLine = mean(DistancePixels(1,(laserframeON-10):laserframeON));
    StdBaseLine = std(DistancePixels(1,(laserframeON-10):laserframeON));
    ThersholdValue = BaseLine + Thershold*StdBaseLine;
    temp = find((DistancePixels(1,laserframeON:end))>ThersholdValue);
    plot(DistancePixels(1,:)); xline(laserframe(1),'r'); xline(temp(1) + laserframeON,'b')
    Latency = temp(1); % [Frames]
    LatencyMiliSeconds = Latency*(1/vidObj.FrameRate)*1000; % [Miliseconds]. This is latency form the 
    % lights ON to start of the movement
    FrameLatency = laserframeON + Latency -1 ; 
    uiwait
    
end
     

     % For eliminating the problem with the sampling rate, the signal will
     % be interpolate by a determinate factor
     Nfactor = 100; 
     SumAng3D = interp(squeeze(SumAng3D),Nfactor);
     
     clear i 


