%% David Madrid . Last Rev 16/05/2022

if isequal(TypeExperiment,'ES') % Normaly the semiautomatic is for the SIE.

    % Dynamic of the C response
    % Calculation of the Angle using dot product. SAME VECTOR WITH ITSELF
    ChangingVector3D = NaN(size(Vec3D,1),length(frames)-1);
    for i=1:length(frames)-1
        for ii = 1:size(Vec3D,1)
            %         ChangingVector3D(ii,i)= acos(((Vec3D(ii,1,i).*Vec3D(ii,1,i+1))+(Vec3D(ii,2,i).*Vec3D(ii,2,i+1)))./...
            %             ((sqrt(Vec3D(ii,1,i+1).^2 + Vec3D(ii,2,i+1).^2)).*(sqrt(Vec3D(ii,1,i).^2 + Vec3D(ii,2,i).^2)))).*180/pi;

            ChangingVector3D(ii,i) =  atan2d(Vec3D(ii,1,i).*Vec3D(ii,2,i+1)-Vec3D(ii,2,i).*Vec3D(ii,1,i+1),...
                Vec3D(ii,1,i).*Vec3D(ii,1,i+1)+Vec3D(ii,2,i).*Vec3D(ii,2,i+1));
        end
    end


    %%                              REAL SWIMMING ANALYSIS (ALTERNATION)



    % We will use the baseline per EACH EPIOSDE. If you want to use the
    % general baseline like tempor

    %       baseline_swimming_gen =BASELINE_PER_EPISODE;
    %     tempor =baseline_swimming;

    for k=1:length(fieldnames(EPISODE_X)) % we will do it across swimming episodes
        close all
        temp1 = fieldnames(EPISODE_X);
        myfield1 = char(temp1(k));
        tempor = baseline_swimming(k);
        numepisodes = length(fieldnames(EPISODE_X)); 

        % REMOVING POINTS FURTHER AWAY BASED ON SMALL FREQUENCY

        timepoints = EPISODE_X.(myfield1);

        %Forward identification
        for i=1:length(timepoints)-1
            distance_frames(i) = timepoints (i+1)-timepoints (i);
            freq(i) = 1/(distance_frames(i)*(1/vidObj.FrameRate ));
        end

        threshold = 4; %Remove date points that are really far away (small frequency), posible
        %different episodes f swimming

        v=zeros(1,length(timepoints));

        for i=1:length(timepoints)-1
            if freq(i)>threshold
                v (i) = 1;
                v (i+1) = 1;

            else
                v(i+1) = 0;
            end
        end
        clear freq distance_frames threshold

        v1 = find(v);
        % THIS VECOR (V) HAVE THE LOGICAL VALUE OF THE TIMEPOINTS WHERE THE FREQUENCY BTW
        % HALF OF A CYCLE IS BIGGER THAN A THRESHOLD

        if isempty(v1) % If there is no swimming there will be no index and all the rest of the code will give
            % us error, so if v1 is empty means that in this episode there
            % is not swimming and we can jumo to the next one


            FINAL_POINTS_SWIMMING_X.(myfield1) =  [];
            FINAL_POINTS_SWIMMING_Y.(myfield1) = [];
            FREQ_SWIM_X.(myfield1) = [];
            FREQ_SWIM_Y.(myfield1) = [];


        else % if is not empty mean there is swimming and we can continue with the code


            plot(EPISODE_X.(myfield1),tempor*ones(size(EPISODE_X.(myfield1))),'g','LineWidth',4);hold on
            plot(EPISODE_X.(myfield1),EPISODE_Y.(myfield1),'LineWidth',3);
            xline(timepoints(v1),'LineWidth',1)

            % REMOVE CONSECUTIVE PEAKS OR TROUGTS WITH SMALL DIFERENCES

            % % Equal number of data points in peaks, if is not equal this will add zeros
            % % at the end of the shorter vector
            %
            % if length(CALCIUM.pks1_swim)==length(CALCIUM.pks2_swim)
            %     return
            % elseif length(CALCIUM.pks1_swim)>length(CALCIUM.pks2_swim)
            %     zeropading = zeros(1,length(CALCIUM.pks1_swim)-length(CALCIUM.pks2_swim));
            %    pks2_swim = [CALCIUM.pks2_swim; zeropading'];
            % elseif length(CALCIUM.pks1_swim)<length(CALCIUM.pks2_swim)
            %     zeropading = zeros(1,length(CALCIUM.pks2_swim)-length(CALCIUM.pks1_swim));
            %    pks1_swim= [CALCIUM.pks1_swim; zeropading'];
            % end

            % Next we have to organize time-wise the peaks and troughs and puting them
            % in orde on a vector. For that i use the conditionals to first detect if
            % the time of and first event (peak or trougts) is found in the vector
            % location of the peaks (locs1) or of the trougts(locs2). them i will take
            % the peak or the trougt corresponding to that time point and i will place
            % it in a new vector. Them i will do it with the second timepoint and so on
            % Now the vector event_vector contains the values of the peaks and trougts
            % cronologally order



            Amplitud_threshold = 10;
            %
            %             for i = 1:length(timepoints)
            %                 if  ismember(timepoints(i),EPISODE_X.(myfield1))
            %                     event_vector(i) =EPISODE_Y.(myfield1)(find(timepoints(i)==EPISODE_X.(myfield1)));
            %                 elseif ismember(timepoints(i),CALCIUM.locs2_swim)
            %                     event_vector(i) =CALCIUM.pks2_swim(find(timepoints(i)==CALCIUM.locs2_swim));
            %                 end
            %             end


            %             Remove elements with small diferences (less than amplitude_threshold)

            remove_amplitude=NaN(1,length(timepoints));
            for i=1:length(timepoints)-1
                if abs(abs(EPISODE_Y.(myfield1)(i+1))+abs(EPISODE_Y.(myfield1)(i)))>Amplitud_threshold
                    if remove_amplitude (i) == 0
                        remove_amplitude (i+1) = 1;
                    else
                        remove_amplitude (i) = 1;
                        remove_amplitude (i+1) = 1;
                    end
                else
                    remove_amplitude (i+1) = 0;
                end
            end

            v2 = find(remove_amplitude);
            xline(timepoints(v2),'r--','LineWidth',3)

            ii = intersect(v1,v2);
            xline(timepoints(ii),'g--','LineWidth',3)

            clear Amplitud_threshold  remove_amplitude

            % REMOVE JUST TAILBEATING

            tail_beating=zeros(1,length(timepoints));
            tail_beating(1)=1;
            std_used = 2.5; % how many standars deviation above and below the baseline

            % Remove the values that are consecutivetly way below the baseline
            baseline = tempor;
            topbaseline = baseline + std_used*std_baseline;
            bottombaseline = baseline - std_used*std_baseline;
            yline(topbaseline(k))
            yline(bottombaseline(k))
            for  i=1:length(timepoints)-1
                if EPISODE_Y.(myfield1)(i)<bottombaseline(k) && EPISODE_Y.(myfield1)(i+1)>topbaseline(k)
                    if tail_beating(i)==1
                        tail_beating(i+1)=1; 
                    else
                        tail_beating(i)=1;
                    end

                elseif EPISODE_Y.(myfield1)(i)>topbaseline(k) && EPISODE_Y.(myfield1)(i+1)<bottombaseline (k)
                    if tail_beating(i)==1
                        tail_beating(i+1)=1; 
                    else
                        tail_beating(i)=1;
                    end

                else
                    if tail_beating(i)==1
                    else 
                    tail_beating(i+1)=0;
                    end

                end
            end

            v3= find(tail_beating);
            if v3==1
                jj=ii;
                xline(timepoints(jj),'m--','LineWidth',3)
            else
                xline(timepoints(v3),'b--','LineWidth',1)
                jj= intersect(ii, v3);
                xline(timepoints(jj),'m--','LineWidth',3)
            end

            clear tail_beating

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            % CONTINUITY OF THE DATA
            %Remove some datapoints that are far away and solitary

            diff_distance = 0.20;

            datapoints = timepoints(jj);
            if length(datapoints)==1 %means there is no swimming
                FINAL_POINTS_SWIMMING_X.(myfield1) =  [];
                FINAL_POINTS_SWIMMING_Y.(myfield1) = [];
                FREQ_SWIM_X.(myfield1) = [];
                FREQ_SWIM_Y.(myfield1) = [];
                img('save',CALCIUM,[],list,nfish);
                close all

            else

                for i = 1:length (datapoints)-1
                    diff_datapoints(i) = abs(datapoints(i)-datapoints(i+1));
                    if diff_datapoints(i)<diff_distance
                        v4(i)=1;
                        v4(i+1) = 1;
                    else
                        v4(i+1)=0;

                    end
                end

                v5= find(v4);

                if isempty(v5)
                    Final_points_swimming = timepoints(jj);
                    xline(timepoints(jj) ,'b--','LineWidth',5)

                else
                    hh= intersect(jj, v5);
                    xline(timepoints(hh) ,'b--','LineWidth',5)

                    Final_points_swimming = timepoints(hh);
                end

            end

            uiwait;


            %% Frequencies analysis

            Freq

            % In case you have more then one episode you want to create a
            % structure with each single variable variables 
            DISTANCECYCLE.(myfield1) =  DistanceCycle; 
            VELOCIYCYCLE.(myfield1) = VelociyCycle; 
            DISTANCECYCLE.(myfield1) =  DistanceCycle; 
            FREQ_SW.(myfield1) = CompleteCycle; 
            AMPLITUDEHALFCYCLE.(myfield1) = AmplitudeHalfCycle; 
            TIMEEPIOSE.(myfield1)  = TimeEpiose ; 
            DISTANCEWHOEPI.(myfield1)  = DistanceWhoEpi ; 
            MAXVELOCITY.(myfield1) = MaxVelocity;

           



           
%             %% C RESPONSE
%             if isequal(TypeExperiment,'SIE') % We will analyze the ESCAPE
%                 %plot(wave)
%                 %plot(abs(wave))
%                 if Final_points_swimming(1)-15<laserframeON && Final_points_swimming(end)>laserframeON % If 1 the light is ha
%                     %happening in this episode. So the C start will be in this episode
% 
%                     CstartCadndidate = Final_points_swimming>laserframeON ;
%                     fff = find(CstartCadndidate ,1,"first");
%                     CandidateCAmplitude = abs(wave(Final_points_swimming(fff))); % Amplitude of the C response
%                     CandidateCFrame = find(abs(wave)==CandidateCAmplitude);
%                     if length(CandidateCFrame)>1
%                         CandidateCFrame = CandidateCFrame(1); % Frame for the C response
%                     end
%                     find(Final_points_swimming==CandidateCFrame)
%                     Final_points_swimming = Final_points_swimming(find(Final_points_swimming==CandidateCFrame):end);
%                     AmplitudePeaksAfterC = abs(wave(Final_points_swimming));
%                     NumberPeaksAfterC = length(AmplitudePeaksAfterC);
%                     Cduration = CandidateCFrame - (laserframeON+Latency-1);
%                     %plot(AmplitudePeaksAfterC)
% 
%                     % Now we have to exclude all the time points and values for swimming prior and
%                     % during the C response
%                     Freq
%                 end
% 
%             end
        end
    end
 % THIS IS FOR THE ESCAPE TO DETECT VIDEOS WHEN THE VIDEO WAS
 % STOPPED BEFORE THE ANIMAL STOPPED SWIMMING
% 
%     prompt = 'Keep swimming at the end';
%     dlgtitle = 'Input';
%     dims = [1 35];
% 
%     definput ={'N'};
%     answer = inputdlg(prompt,dlgtitle,dims,definput);
%     answerText = char(answer(1));
% 
%     if isequal(answerText ,'Y')
%         KeepSwimming = 1;
%     elseif isequal(answerText ,'N')
%         KeepSwimming = 0;
%     end


elseif isequal(TypeExperiment,'SW') % Here normally is for the SW

    % The point selected for the analysis is the 3th one, hind brain. Is the
    % most stable one. -> DistancePixels(3,:)

    % Maybe because the length of the videos is not the same, you wanna
    % take less frames from on condition and more from the other

%     if WeekNumber<=4
% 
%     wave = DistancePixels(3,1:end-900)./LengthAnimalFrames;
%     Velo = VelocityFrames(3,1:end-900); %[px/sec]
%     frames = frames(1:end-900); 
% 
%     elseif WeekNumber>=5 && WeekNumber<=8

    wave = DistancePixels(3,:)./LengthAnimalFrames;
    wave = medfilt1(wave,10); %plot(wave)
    maxi = max(wave); 
    Velo = VelocityFrames(3,:); %[px/sec]

%     end 


    % wave = medfilt1(wave,5);

    % wave = squeeze(SumAng3D );

    % Finding number of epsiodes

    figure('units','normalized','outerposition',[0 0 1 1])
    MinPkProminence =  0.003; % 0.005
    MinPkDistance = 15; % 15
    MinPkHeight = 0.002; % 0.01


    findpeaks(wave,'MinPeakProminence',MinPkProminence...
        ,'MinPeakDistance',MinPkDistance,'MinPeakHeight',MinPkHeight), hold on

    [pks,locs] = findpeaks(wave,'MinPeakProminence',MinPkProminence...
        ,'MinPeakDistance',MinPkDistance,'MinPeakHeight',MinPkHeight);

    scatter(locs,pks,'r')


    NumEpisodes = length(locs);

    % Finding the length of the episodes. The peak should be in btw the two
    % points of intrsection with the thershold line. This threshold can be
    % diferent for diferent weeks, next part allows you to change depending
    % on the week

%     if WeekNumber<=7
%         Th = 0.005;
%     elseif WeekNumber==8
        Th = 0.004 ;
%     end

    yline( Th )
    A = [frames', NaN, frames'; wave, NaN, Th.*ones(1,length(frames))];
    Inter = InterX(A);
    temp = Inter (1,:);


    Inte1 = NaN(1,length(locs));
    Inte2 = NaN(1,length(locs));
    for i = 1:length(locs)
        if isempty( find (temp>locs(i),1,'first') )
        else
            Inte1(i) = find (temp>locs(i)-1,1,'first') ;
        end

        if isempty( find (temp<locs(i),1,'last') )
        else
            Inte2(i)= find (temp<locs(i)-1,1,'last') ;
        end
    end

    % Control Test


    Keep1 = find(~isnan(Inte1));
    Keep2 = find(~isnan(Inte2));

    Keep = intersect(Keep1, Keep2);


    Inte1 = Inte1(Keep);
    Inte2  = Inte2(Keep);
    pks = pks(Keep);
    locs = locs(Keep);
    NumEpisodesIncl = max(Keep);
    if isempty(NumEpisodesIncl)
        NumEpisodesIncl = 0; 
    end 

    % Control Test
    if length(Inte1)==length(Inte2) && length(Inte1)==length(pks)
    else
        error('Diferent number of peaks and intersections')
    end

    close all
    figure('units','normalized','outerposition',[0 0 1 1])
    plot(wave), hold on
    scatter(temp (Inte1),Th.*ones(1,length(Inte1)),'b')
    scatter(temp(Inte2),Th.*ones(1,length(Inte2)),'g')
    scatter(locs,pks,'r')
    title(Name)
%     saveas(gcf,fullfile(CurrentSavingPath,strcat('ThresholdFIG'))); 
%     saveas (gcf,fullfile('C:\Users\El Manira lab\Desktop\Threhold',strcat(Name,'ThresholdFIG.jpg')))
    close all
     MaxAcceptedStd = 10; 

    if std(wave./LengthAnimalFrames) > MaxAcceptedStd  % to remove outliers, bad labelling


    else



        WithEpisode = temp (Inte1)- temp (Inte2); %[frames]
        close all
        scatter(WithEpisode,pks)


        temp1 = temp (Inte1);
        temp2 = temp (Inte2);

        DistancePerEpisode = NaN(1,NumEpisodesIncl);
        VelocityPerEpisode = NaN(1,NumEpisodesIncl);

        wave = wave.*LengthAnimalFrames;

        for i = 1: NumEpisodesIncl
            DistancePerEpisode(i) = sum(wave(ceil(temp2(i)):ceil(temp1(i))));
            VelocityPerEpisode(i) = DistancePerEpisode(i)/WithEpisode(i); %[px/frames]
        end

        plot((VelocityPerEpisode.*(vidObj.FrameRate))./LengthAnimalFrames);
        ylabel('BL/sec')
        xlabel('Episodes')
        saveas(gcf,fullfile(CurrentSavingPath,strcat('VelocityFIG'))),close all

        % Area under the curve (Trapezoidal integration)

        %      Q = trapz(wave);


    end

% Direction of the animal and kinematics


for i = 1:length(Vec3D)-1
       AngHead(i,1,:)= atan2d(Vec3D(1,1,i).*Vec3D(1,2,i+1)-Vec3D(1,2,i).*Vec3D(1,1,i+1),...
             Vec3D(1,1,i).*Vec3D(1,1,i+1)+Vec3D(1,2,i).*Vec3D(1,2,i+1)); 
end 

plot(AngHead)
hold on
suma = 0; 
for i = 1:length(Vec3D)-1
    ff (i)= AngHead(i) + suma;  
    suma = suma + AngHead(i); 
end 
h = figure(4); 
plot(ff)
saveas(gcf,fullfile(CurrentSavingPath,strcat('ThresholdFIG')));




% tempAng3D = squeeze(Ang3D);
% y = tempAng3D(1,:);  % head vector
% %    tempAng3D = squeeze(AngHeadTail3D);
% %    y = medfilt1(tempAng3D(:,1),10);
% i = 1;
% 
% Ang3Dconstant(i,1,:)= (atan2d(Vec3D(i,1,:).*0-Vec3D(i,2,:).*1,...
%     Vec3D(i,1,:).*1+Vec3D(i,2,:).*0));
% figure(2)
% plot(Ang3DconstantFilt)
% 
% %%%%
% hold on
% Ang3Dconstant2(i,1,:)= (atan2d(Vec3D(i,1,:).*-1-Vec3D(i,2,:).*0,...
%     Vec3D(i,1,:).*0+Vec3D(i,2,:).*-1));
% Ang3DconstantFilt2 = (squeeze((Ang3Dconstant2)));
% Ang3DconstantFilt2 = medfilt1( (Ang3DconstantFilt2));
% figure(3)
% plot(Ang3DconstantFilt2)
% g = Ang3DconstantFilt2+90; 
% plot(g)
% 
% 
% %%%%
% 
% Ang3DconstantFilt2(1)-Ang3DconstantFilt(1)
% 
% 
% % The problem is in the transition from 180 to -180 that there is a jump
% 
% for i = 1:length(Ang3DconstantFilt)-1
%     if Ang3DconstantFilt(i)*Ang3DconstantFilt(i+1)<0
%         Ang3DconstantFiltC(i+1) = Ang3DconstantFilt(i) + abs((abs(Ang3DconstantFilt(i+1))-180))...
%             + abs((abs(Ang3DconstantFilt(i))-180));
%         Ang3DconstantFiltC(i) = Ang3DconstantFilt(i);
%     else
%         Ang3DconstantFiltC(i) = Ang3DconstantFilt(i);
%     end
% 
% end
% Ang3DconstantFiltC = Ang3DconstantFiltC';
% figure(2)
% plot(Ang3DconstantFiltC)
% 
% 
% % extracting just the change is the angle 
% 
% for i = 1:length(Ang3DconstantFilt)-1
%     if Ang3DconstantFilt(i)*Ang3DconstantFilt(i+1)<0 && Ang3DconstantFilt(i)*Ang3DconstantFilt(i+1)<-8100
%         AngleChange(i) =   abs((abs(Ang3DconstantFilt(i+1))-180))...
%             + abs((abs(Ang3DconstantFilt(i))-180));
%     else
%         AngleChange(i) = abs(Ang3DconstantFilt(i+1))-abs(Ang3DconstantFilt(i));
%     end
% 
% end
% AngleChange = AngleChange'; 
% plot( AngleChange)
% plot( abs(AngleChange))
% 
% t = find(Ang3DconstantFilt(1:end-1)>0); 
% AngleChange(t) = -AngleChange(t); 
% plot( AngleChange)
% 
% 
% 
% 
% 
% u(:,1) = Vec3D(1,1,:); 
% u(:,2) = Vec3D(1,2,:);
% u(:,3) = 0; 
% 
% v(:,1) = 1;
% v(:,2) = 0; 
% v(:,3) = 0; 
% 
% n = [ 0 0 1]; 
% for i = 1:length(u)
% x(i,:) = cross(u(i,:),v); 
% end 
% for i = 1:length(u)
% c(i,:) = sign(dot(x(i,:),n)) * norm(n);
% a(i,:) = atan2d(c(i,:),dot(u(i,:),v));
% end 
% plot(a)
% 
% 
% 
% %%%%%%
% 
% for i = 1:length(Ang3DconstantFilt)-1
%     if Ang3DconstantFilt(i)<0 && Ang3DconstantFilt(i)<-90 && Ang3DconstantFilt(i-1)<-90
%         Ang3DconstantFiltC(i) = Ang3DconstantFilt(i) + 360;
%     elseif Ang3DconstantFilt(i)<0 && Ang3DconstantFilt(i)<-90 && Ang3DconstantFilt(i-1)>-90
%         Ang3DconstantFiltC(i) = Ang3DconstantFilt(i); 
%     else
%         Ang3DconstantFiltC(i) = Ang3DconstantFilt(i);
%     end
% 
% end
% 
% 
% %%% cabeza
% for i = 1:length(Vec3D)-1
%        AngHead(i,1,:)= atan2d(Vec3D(1,1,i).*Vec3D(1,2,i+1)-Vec3D(1,2,i).*Vec3D(1,1,i+1),...
%              Vec3D(1,1,i).*Vec3D(1,1,i+1)+Vec3D(1,2,i).*Vec3D(1,2,i+1)); 
% end 
% 
% sum = 0; 
% for i = 1:length(Vec3D)-1
%     ff (i)= AngHead(i) + sum;  
%     sum = sum + AngHead(i); 
% end 
end 