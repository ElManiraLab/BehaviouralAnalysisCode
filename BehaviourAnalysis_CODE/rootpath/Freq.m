%% FREQUENCIES ANALYSIS AND PARAMETERS FOR ONE EPISODE

%% 1. FREQUENCY USING PEAKS (FICTIVE CYCLE) --> HALF CYCLES

% Prelocate

DistanceCycle = NaN(1,length(Final_points_swimming)-1);
VelociyCycle = NaN(1,length(Final_points_swimming)-1);
distance_frames_sw = NaN(1,length(Final_points_swimming)-1); % Prelocate distance btw frames
freq_sw = NaN(1,length(Final_points_swimming)-1); %Prelocate half cycle frequencies

% Half cycle analysis

for i=1:length(Final_points_swimming)-1

    distance_frames_sw(i) = Final_points_swimming(i+1)-Final_points_swimming(i);
    freq_sw(i) = 1./(distance_frames_sw(i)*(1/vidObj.FrameRate));

    % Mean Distance Per half cycle
    DistanceCycle(i) = sum(DistancePixels(3,floor(Final_points_swimming(i)):floor(Final_points_swimming(i+1))));

    % Mean Velocity Per half cycle
    VelociyCycle(i) = DistanceCycle(i)/(distance_frames_sw(i)*(1/vidObj.FrameRate));

end

CompleteCycle = freq_sw./2; %To have the frequency of the complete cycle (double of data points)

%2. Extraction of the midpoint for each half cycle frequency
middpoint = NaN(1,length(Final_points_swimming)-1);
for i=1:length(Final_points_swimming)-1
    middpoint(i) = (Final_points_swimming(i+1)+Final_points_swimming(i))/2;
end

% The two amplitudes for each half of a cycle
AmplitudeHalfCycle = NaN(1,length(Final_points_swimming)-1);
for i = 1:length(Final_points_swimming)-1
    AmplitudeHalfCycle(i) = peak2peak([wave(floor(Final_points_swimming(i+1)*Nfactor)) wave(floor(Final_points_swimming(i)*Nfactor))]);
end


%{

%% 3. FREQUENCY USING REAL CYCLES --> COMPLETE CYCLES

%% IMPORTANT. THIS PART CAN NOT BE DONE WITH THE INTERPOLATED WAVE, IS TOO
%  BIG AND IS ASKING FOR 600 GB OF RAM. IF YOU WANT TO CALCULATE THE REAL
%  FREQUENCY, AMPLITUDE, ETC, MUST BE DONE WITH THE NON INTERPOLATED WAVE
%  THIS IS REDIFINING AGAIN 
%  SumAng3D = sum(Ang3D);
%  wave = squeeze(SumAng3D); 
% OTHER OPTION IS REDUCING THE Nfactor. (with Nfactor = 100, is asking for 671 GB RAM)

% This part is not in use right now. 

%1. Detection of the first and last inflexion. Using function InterX
% the line of intersection is the baseline, topbaseline and bottom
% baseline
clear tempora

%       A = [frames', NaN, frames'; wave', NaN, baseline.*ones(1,length(frames))];
B = [frames', NaN, frames'; wave', NaN, topbaseline(k).*ones(1,length(frames))];
C = [frames', NaN, frames'; wave', NaN, bottombaseline(k).*ones(1,length(frames))];

%       Inter1 = InterX(A); % Contains the intersecction btw the baselione and the curve.
Inter2 = InterX(B); % Contains the intersecction btw the baselione and the curve.
Inter3 = InterX(C); % Contains the intersecction btw the baselione and the curve.

temp = [Inter2, Inter3];  % Inter1

[~,idx] = sort(temp(1,:)); % sort just the first column
InterTemp = temp(:,idx);   % sort the whole matrix using the sort indices

plot(frames, wave), hold on, plot(frames, baseline.*ones(1,length(frames))), scatter(InterTemp(1,:),InterTemp(2,:))
yline(topbaseline(k))
yline(bottombaseline(k))



tempo =  find(InterTemp(1,:)<Final_points_swimming(1),1,'last'); 

for i = tempo:size(InterTemp,2)-1
    
    if InterTemp(1,i+1) - InterTemp(1,i) > 5 && i== tempo

        tempora(1,i) = InterTemp(1,i);
        tempora(2,i) = InterTemp(2,i);
    elseif InterTemp(2,i+1)> baseline && InterTemp(2,i)> baseline
    elseif InterTemp(2,i+1)< baseline && InterTemp(2,i)<baseline

%     elseif InterTemp(1,i+1) - InterTemp(1,i) < 3.02 
    else
        tempora(1,i) = (InterTemp(1,i+1) + InterTemp(1,i))/2;
        tempora(2,i) = (InterTemp(2,i+1) + InterTemp(2,i))/2;

%      elseif InterTemp(1,i+1) - InterTemp(1,i) < 4
% 
%         tempora(1,i) = (InterTemp(1,i+1) + InterTemp(1,i))/2;
%         tempora(2,i) = (InterTemp(2,i+1) + InterTemp(2,i))/2;
    
        

    end

end

clear Inter
Inter(1,:) = nonzeros(tempora(1,:));
Inter(2,:) = nonzeros(tempora(2,:));

[~,idx] = sort(Inter(1,:)); % sort just the first column
Inter = Inter(:,idx);

plot(frames, wave), hold on, plot(frames, baseline.*ones(1,length(frames))), scatter(Inter(1,:),Inter(2,:))
yline(topbaseline(k))
yline(bottombaseline(k))


%Find the first inflexion. For that, find the first interseccion point
%before the first peak
if isempty(find(Inter(1,:)< Final_points_swimming(1),1,'last'))
    r = 1;
    while isempty(find(Inter(1,:)< Final_points_swimming(r),1,'last'))
        r=r+1;

    end
    temp = find(Inter(1,:)< Final_points_swimming(r),1,'last');
    FirstInflex = Inter(1,temp);
    xline(FirstInflex)
else
    temp = find(Inter(1,:)< Final_points_swimming(1),1,'last');
    FirstInflex = Inter(1,temp);
    xline(FirstInflex)
end

% Same for last inflexion

if isempty(find(Inter(1,:)> Final_points_swimming(end),1,'first'))
    r=1;
    while isempty(find(Inter(1,:)> Final_points_swimming(end-r),1,'first'))
         r=r+1;
    end
    temp1 = find(Inter(1,:)> Final_points_swimming(end-r),1,'first');
    LastInflex = Inter(1,temp1);
    xline(LastInflex)
    InsideCycle = Inter(1,temp:temp1);
else
    temp1 = find(Inter(1,:)> Final_points_swimming(end),1,'first');
    LastInflex = Inter(1,temp1);
    xline(LastInflex)
    InsideCycle = Inter(1,temp:temp1);
end

plot(frames,wave), hold on
RealCycle = zeros(1,length(temp:temp1));


% Creating the all the real

    acum = 0;Cont = 0;
    
    for l = 1:2:length(temp:temp1)
        xline(InsideCycle(l),'b--','LineWidth',5)
        RealCycle(l) = InsideCycle(l);
        if acum == 1
            xt = (InsideCycle(l-2) + InsideCycle(l))/2;
            yt = 140;
            acum = 1;
            Cont = Cont + length(Cont);
            text(xt,yt,strcat('C',sprintf('%.0f',Cont )),'Color','red','FontSize',10)

            %Mean Distance Per cycle
            DistanceCycle1(Cont) = sum(DistancePixels(2,round(InsideCycle(l-2)):...
                round(InsideCycle(l))));

            % Mean velocity per cycle
            VelociyCycle1 (Cont) = DistanceCycle1(Cont) / ((round(InsideCycle(l-2))-round(InsideCycle(l)))*(1/vidObj.FrameRate)); 

        else
            acum = 1;
        end
    end
ff = nonzeros(RealCycle);


uiwait

%3. Extraction of the instantaneus real frequency of the cycles
distance_frames_sw_R = NaN(1,length(ff)-1);
RealFreq =NaN(1,length(ff)-1);
for i=1:length(ff)-1
    distance_frames_sw_R(i) = ff(i+1)-ff(i);
    RealFreq(i) = 1./(distance_frames_sw_R(i)*(1/vidObj.FrameRate));
end

%4. Extraction of the midpoint for each real frequency
middpoint = NaN(1,length(ff)-1);
for i=1:length(ff)-1
    middpoint(i) = (ff(i+1)+ff(i))/2;
end


% Amplitude per each real cycle
AmplitudeCycle = NaN(1,length(RealFreq));
for i = 1:length(RealFreq)
    temp = find (Final_points_swimming>ff(i) & Final_points_swimming<ff(i+1));
    AmplitudeCycle(i) =  peak2peak(wave(Final_points_swimming(temp)));
end

% WHOLE EPISODE

% % For escape
% TimeEpiose = (laserframeON+Latency-1):ceil(LastInflex); % From beginning of C start to End of real episode [PIXEL]
% DistanceWhoEpi = sum(DistancePixels(1,TimeEpiose)); 
% MaxVelocity = max(VelociyCycle); 

% For high frame rate sw. can not be the same than For escape because there
% is not latency

TimeEpiose = floor(ff(1)):ceil(LastInflex); 
DistanceWhoEpi = sum(DistancePixels(3,TimeEpiose)); % the point in the hidbrain
MaxVelocity = max(VelociyCycle); 

%}

TimeEpiose = floor(Final_points_swimming(1)):floor(Final_points_swimming(end)); 
DistanceWhoEpi = sum(DistanceCycle); % the point in the hidbrain
MaxVelocity = max(VelociyCycle); 
