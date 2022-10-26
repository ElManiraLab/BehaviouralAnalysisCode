


if isequal(TypeExperiment,'ES') % Normaly the semiautomatic is for the SIE.

     for k=1:length(fieldnames(EPISODE_X))
       temp1 = fieldnames(EPISODE_X);
        myfield1 = char(temp1(k));
        TableAnimal.(myfield1) = table; 

%   TableAnimal.(myfield1)(:,1) = array2table(freq_sw'); 
    TableAnimal.(myfield1)(:,1) = array2table(FREQ_SW.(myfield1)'); % Cycle Freq extracted from the half cycle [cycles/sec]
    TableAnimal.(myfield1)(:,2) = array2table(AMPLITUDEHALFCYCLE.(myfield1)'); % Amplitude of the half cycle [Angles]
    TableAnimal.(myfield1)(:,3) = array2table((VELOCIYCYCLE.(myfield1)*ConverFact)'); % Velocity half of a cycle [cm per second]
    TableAnimal.(myfield1)(:,4) = array2table(((VELOCIYCYCLE.(myfield1)./LengthAnimalFrames))'); % Velocity [BodyLengths/sec]
    TableAnimal.(myfield1)(1,5)= array2table(DISTANCEWHOEPI.(myfield1) *ConverFact); % Distance [cm]
    TableAnimal.(myfield1)(1,6) = array2table(DISTANCEWHOEPI.(myfield1) / LengthAnimalFrames); % Distance [bodylength]
    TableAnimal.(myfield1)(1,7) = array2table((DISTANCEWHOEPI.(myfield1) /((TIMEEPIOSE.(myfield1)(end)-(TIMEEPIOSE.(myfield1)(1)))*(1/vidObj.FrameRate)))*ConverFact); %cm/sec
    TableAnimal.(myfield1)(1,8) = array2table(DISTANCEWHOEPI.(myfield1) /((TIMEEPIOSE.(myfield1)(end)-(TIMEEPIOSE.(myfield1)(1)))*(1/vidObj.FrameRate))./LengthAnimalFrames); % [bodyLengths / sec]
%     TableAnimal.(myfield1)(1,10) = array2table(LatencyMiliSeconds); %[ms]
%     TableAnimal.(myfield1)(1,11) =array2table(CandidateCAmplitude); %
%     TableAnimal.(myfield1)(1,12) = array2table(Cduration*(1/vidObj.FrameRate)*1000); % duration from the latency to the peak of the c bend
    TableAnimal.(myfield1)(1,9) = array2table(LengthAnimalFrames*ConverFact);
    TableAnimal.(myfield1)(1,10) = array2table((TIMEEPIOSE.(myfield1)(end)-(TIMEEPIOSE.(myfield1)(1)))*(1/vidObj.FrameRate)*1000); % duration of the whole episode ms
    TableAnimal.(myfield1)(1,11) = array2table((MAXVELOCITY.(myfield1)*ConverFact)'); % max velocity [cm per second]
    TableAnimal.(myfield1)(1,12) = array2table((MAXVELOCITY.(myfield1)./LengthAnimalFrames)'); % max velocity [BodyLengths/sec]
%     TableAnimal.(myfield1)(1,17) = array2table(KeepSwimming'); % duration of the whole episode
 TableAnimal.(myfield1)(1,13) = array2table(LatencyMiliSeconds); % max velocity [BodyLengths/sec]
%     TableAnimal.(myfield1)(1,17) = array2table(KeepSwimming'); % duration of the whole episode


    TableAnimal.(myfield1).Properties.VariableNames(1:13) = {'Cycle Freq [Hz]','Cycle Amp [Degrees] ',...
        'Velocity Half Cycle [cm/sec]','Velocity Half Cycle BL [BL/sc]','Total distance episode [cm]','Total distance episode BL [BL]' ,...
        'Ave Velocity Episode [cm/sec]','Ave Velocity Epiosde BL [BL/sec]', 'Length [cm]',...
        'Duration whole episode [ms]','Max Velocity Episode [cm/sec]','Max Velocity Episode [BL/sec]','Latency [ms]'};
     end 


    filename = strcat(Name,'.mat'); % Creating the name
    save(fullfile(CurrentSavingPath,strcat('TABLE',filename)),'TableAnimal','Name','EPISODE_X'); % Saving in the correct folder
    save(fullfile(CurrentSavingPath,strcat('TABLE',filename)),'TableAnimal','Name','EPISODE_X','SumAng3D'); % Saving in the correct folder


elseif isequal(TypeExperiment,'SW') % Here normally is for the SW

    if std(wave) >  MaxAcceptedStd 
%     elseif NumEpisodes == 0
    else


        TableAnimal(:,1) = array2table((WithEpisode.*(1/vidObj.FrameRate))'); % Duration of each episode [sec]
        TableAnimal(:,2) = array2table((DistancePerEpisode.*ConverFact)'); % Distance travel per episode [cm]
        TableAnimal(:,3) = array2table((DistancePerEpisode./ LengthAnimalFrames)'); %  Distance travel per episode [BL]
        TableAnimal(:,4) = array2table(((VelocityPerEpisode.*(vidObj.FrameRate)).*(ConverFact))'); % Velocity per epsiodee[cm/sec]
        TableAnimal(:,5)= array2table(((VelocityPerEpisode.*(vidObj.FrameRate))./LengthAnimalFrames)');  % Velocity per episode [BodyLengths/sec]
        TableAnimal(1,6) = array2table(max(Velo.*(ConverFact))); % Max Velocity [cm/sec]
        TableAnimal(1,7) = array2table(max(Velo./ LengthAnimalFrames)); % Max Velocity [BL/sec]
        TableAnimal(1,8) = array2table(sum(wave.*ConverFact)); % Total distance including not swiming [cm]
        TableAnimal(1,9) = array2table(sum(wave)./LengthAnimalFrames);  % Total distance including not swiming [BL]
        

%         if isempty(DistancePerEpisode)
%         TableAnimal(1,10) =array2table(0); 
%         TableAnimal(1,11) =array2table(0);
%         TableAnimal(1,12) =array2table(0); 
%         TableAnimal(1,13) =array2table(0); 
        
        TableAnimal(1,10) =array2table(mean(DistancePerEpisode.*ConverFact)); % Average distance all episodes [cm]
        TableAnimal(1,11) =array2table(mean(DistancePerEpisode./ LengthAnimalFrames)); % Average distance all episodes [BL]
        TableAnimal(1,12) =array2table(mean((VelocityPerEpisode.*(vidObj.FrameRate)).*(ConverFact))); % Average velocity all episodes [cm/sec]
        TableAnimal(1,13) =array2table(mean((VelocityPerEpisode.*(vidObj.FrameRate))./ LengthAnimalFrames)); % Average velocity all episodes [BodyLengths/sec]
        
       
        TableAnimal(1,14) = array2table(NumEpisodes); % Num episodes
        TableAnimal(1,15) =  array2table(LengthAnimalFrames*ConverFact);
        TableAnimal(1,16) =  array2table(NumEpisodesIncl); 


        TableAnimal.Properties.VariableNames(1:16) = {'Duration episodes [sec]','Distance episodes [cm]','Distance episodes [BL]',...
            'Velocity Epiosdes [cm/sec]','Velocity Episodes [BL/sc]','Max velocity [cm/sec]','Max velocity [BL/sec]' ,...
            'Total Distance including no swim [cm]','Total Distance including no swim [BL]','Average Distance Episodes [cm]','Average Distance Episodes [BL]',...
            'Average Velocity Episodes [cm/sec]', 'Average Velocity Episodes [BL/sec]',...
            'Num Episodes','Length [cm]', 'Num Episodes Inc'};


        filename = strcat(Name,'.mat'); % Creating the name
        save(fullfile(CurrentSavingPath,strcat('TABLE',filename)),'TableAnimal','Name'); % Saving in the correct folder


    end
end
