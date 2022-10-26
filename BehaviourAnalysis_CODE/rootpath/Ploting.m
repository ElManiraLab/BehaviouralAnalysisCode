% Sum of the Angles vs Frames
figure
plot(frames, squeeze(SumAng3D))
title('Sum Angles vs Frames')
xlabel('Frames')
ylabel('Sum of the angles[º]')
xline(laserframeON)
xline(laserframeOFF)

% Head-tail angle vs Frames
figure
plot(frames, squeeze(AngHeadTail3D))
title('Head tail angles vs Frames')
xlabel('Frames')
ylabel('Head tail angles [º]')
xline(laserframeON)
xline(laserframeOFF)



% Head distane travel vs Frames
figure
plot(frames, DistanceBodyLenghtPer) % length(DistanceHead) = length(frames)-1. First
% frame the head tavel 0 pixels
title('Head distane travel vs Frames')
xlabel('Frames')
ylabel('Head distane travel [in bodylengths]')
xline(laserframeON)
xline(laserframeOFF)

% Length Animal vs frames
figure
plot(frames,LengthAnimalFrames)
title('Length Animal vs Frames')
xlabel('Frames')
ylabel('Length Animal [pixels]')
xline(laserframeON)
xline(laserframeOFF)

% Dynamic of the C response (LINE PLOT OF THE CHANGE IN THE ANGLE FOR EACH VECTOR WITH ITSELF)
figure
% plot(frames,[ ChangingVector3D(1) ; squeeze(ChangingVector3D(1,1,:))])
plot(frames(laserframeON:laserframeOFF+10),squeeze(ChangingVector3D(1,laserframeON:laserframeOFF+10))) % HEAD-HB
hold on 
plot(frames(laserframeON:laserframeOFF+10),squeeze(ChangingVector3D(9,laserframeON:laserframeOFF+10))) % SC7-SC8
title('Change of angle trough time')
ylabel('Angle [º]')
xlabel('Frames')
xline([laserframeON laserframeOFF])
legend('Head-hindbrain','SC7-SC8','Light ON', 'Light OFF')

% Dynamic of the C response (ARROW PLOT WITH COORDINATES) (ANIMATION)
figure
xlim([-50 50])
ylim([-50 50])
title('Dynamic of the C response')

for i=1:length(frames)
arrow([0,0],[Vec3D(1,1,i),-Vec3D(1,2,i)],10,30,60,3,'Color',colours(1)),hold on
arrow([0,0],[-Vec3D(9,1,i),Vec3D(9,2,i)],10,30,60,3,'Color',colours(9))
pause(0.1)
end 

%Peaks after the C response 
plot(abs(PeaksAfterC))

% Curvature all body parts trough time 

imagesc(ChangingVector3D)
colorbar
ylabel('Bodyoarts')
xlabel('Frames')
title('Angle vs time')
% surf(ChangingVector3D)
% contourf(ChangingVector3D)

%time swiming time moving
plot(1:vidObj.NumFrames,4.*ones(1,vidObj.NumFrames),'r','LineWidth',3),hold on
plot(SWIMMING_TIME_FICTIVE,3.*ones(1,length(SWIMMING_TIME_FICTIVE)),'g','LineWidth',3)
plot(SWIMMING_TIME_REAL,2.*ones(1,length(SWIMMING_TIME_REAL)),'b','LineWidth',3)
plot(Total_time_moving ,ones(1,length(Total_time_moving )),'k','LineWidth',3)
ylim([0 5])
legend('Total Num Frames', 'Swimming Fic', 'Swimming Real', 'Frames moving') 
 

%% GROUP PLOTING EVERYTHING POOL

lightBLUE = [0.356862745098039,0.811764705882353,0.956862745098039];
darkBLUE = [0.0196078431372549,0.0745098039215686,0.670588235294118];
kk = 8; 
blueGRADIENTfixed = [linspace(lightBLUE(1),darkBLUE(1),kk)',...
    linspace(lightBLUE(2),darkBLUE(2),kk)', linspace(lightBLUE(3),darkBLUE(3),kk)'];


% VS DATES --> need to run the excel sript for one tab


% Color = ['r','b','g','y','k','c','m','r']; 
 Week = [1 1 1 2 2 2 3 3 3 3 3 4 4 5 5 5 6 6 7 7 8 8 8 ];

figure
for j = 1:length(TableAnimal.Properties.VariableNames)
    TableAnimal.Properties.VariableNames;
    NumVAR = num2str(j);
    for i = 1:length(fieldnames(Var))
        temp = fieldnames(Var);
        myfield = char(temp(i));
        Y = Var.(myfield)(1:end,str2double(NumVAR));

        %     X = i*ones(length(Y));
        X = i*ones(length(Y));
        NoZeros = find(Y);
        scatter(X(NoZeros),Y(NoZeros),[],[blueGRADIENTfixed( Week(i),:)],'filled'), hold on
        xlabel('Dates')
        ylabel(TableAnimal.Properties.VariableNames{str2double(NumVAR)})
        xlim([0 inf])
        ylim([0 inf])
        temp = char(TableAnimal.Properties.VariableNames(j)); 
        NewName =temp(1:end-5); 

    end
     SaveIn = "C:\Users\Usuario\OneDrive\Escritorio\Var_VS_date";
    if ~exist(fullfile(SaveIn,strcat(NewName,'_','VSDate')), 'dir')
       
        saveas(gcf,fullfile(SaveIn,strcat(NewName,'_','VSDate')))
        saveas(gcf,fullfile(SaveIn,strcat(NewName,'_','VSDate')),'tiff')
        close all
    else
        close all
    end
end


% VS DATES MEAN --> need to run the ecel sript for one tab

figure
for j = 1:length(TableAnimal.Properties.VariableNames)
    TableAnimal.Properties.VariableNames;
    NumVAR = num2str(j);
    for i = 1:length(fieldnames(Var))
        temp = fieldnames(Var);
        myfield = char(temp(i));
        Y = Var.(myfield)(3:end,str2double(NumVAR));
        NoZeros = find(Y) ;
        F = mean(Y(NoZeros));
        %     X = i*ones(length(Y));
        X = i*ones(length(F));
        %     NoZeros = find(Y);
        scatter(X,F,[],[blueGRADIENTfixed( Week(i),:)],'filled'), hold on
        xlabel('Dates')
        ylabel(TableAnimal.Properties.VariableNames{str2double(NumVAR)})
        xlim([0 inf])
        ylim([0 inf])
        temp = char(TableAnimal.Properties.VariableNames(j));
        NewName =temp(1:end-5);

    end
     SaveIn = "C:\Users\Usuario\OneDrive\Escritorio\Var_VS_date";
    if ~exist(fullfile(SaveIn,strcat(NewName,'_','VSDate')), 'dir')
        saveas(gcf,fullfile(SaveIn,strcat(NewName,'_','VSDate_Mean')))
        saveas(gcf,fullfile(SaveIn,strcat(NewName,'_','VSDate_Mean')),'tiff')
        close all
    else
        close all
    end
end


% VS DATES BOXPLOT --> need to run the ecel sript for one tab


% Color = ['r','b','g','y','k','c','m','r']; 
 Week = [1 1 1 2 2 2 3 3 3 3 3 4 4 5 5 5 6 6 7 7 8 8 8 ];

figure
for j = 1:length(TableAnimal.Properties.VariableNames)
    TableAnimal.Properties.VariableNames;
    NumVAR = num2str(j);
    for i = 1:length(fieldnames(Var))
        temp = fieldnames(Var);
        myfield = char(temp(i));
        Y = Var.(myfield)(1:end,str2double(NumVAR));

        %     X = i*ones(length(Y));
        X = i*ones(1,length(Y));
        NoZeros = find(Y);
        boxplot(Y(NoZeros),'Colors',[blueGRADIENTfixed( Week(i),:)],'Positions',i), hold on
        xlabel('Dates')
        ylabel(TableAnimal.Properties.VariableNames{str2double(NumVAR)})
        xlim([0 inf])
        ylim([0 inf])
        temp = char(TableAnimal.Properties.VariableNames(j)); 
        NewName =temp(1:end-5); 

    end
     SaveIn = "C:\Users\Usuario\OneDrive\Escritorio\Var_VS_date";
    if ~exist(fullfile(SaveIn,strcat(NewName,'_','VSDate')), 'dir')
       
        saveas(gcf,fullfile(SaveIn,strcat(NewName,'_','VSDateBOXPLOT')))
        saveas(gcf,fullfile(SaveIn,strcat(NewName,'_','VSDateBOXPLOT')),'tiff')
        close all
    else
        close all
    end
end


 % VS LENGHT SCATTER
 
%  Color = ['r','b','g','y','k','c','m','r'];


for h = [2 3 4 5 6 7 8 9 10 11 12 14 15 16]
j = 0;
% close all

    for i = 1:NumberFiles
        TableOrVars = strfind(NameFiles(i,:),'TABLE'); % Will tell in the current
        % name readed as the word 'TABLE' on it
        if isempty(TableOrVars) % If doesnt have it means is the Variables
            j = j + 1 ;
            load(fullfile(Path2Files(i,:),NameFiles(i,:)),'Name','TableAnimal'); % loading just names
            Temp = char(Name);
            WeekDouble(j) = sscanf( Temp(5) , '%d'); % Week of the animal
            FishDouble(j) = sscanf( Temp(18) , '%d');  % Number of the animal
            TrialDouble(j) = sscanf( Temp(end), '%d'); % Number Trial
            DateDouble(j)  = sscanf( Temp(7:12), '%d');
            Weekh = str2num(Temp(5));

            Length = table2array(TableAnimal(1,13));
            Var = table2array(TableAnimal(1:end,h));
            NonZeros = find(Var); 

          
             

            X = Length.*ones(1,length(Var )); 

            scatter(X(NonZeros),Var(NonZeros),[],[blueGRADIENTfixed(str2double(Temp(5)),:)],'filled'), hold on
            xlabel('Length')
            ylabel(TableAnimal.Properties.VariableNames(h))



        else
        end
    end

    temp = char(TableAnimal.Properties.VariableNames(h)); 
        NewName =temp(1:end-5); 


      SaveIn = "C:\Users\Usuario\OneDrive\Escritorio\Var_vs_length"; 
    if ~exist(fullfile(SaveIn,strcat(NewName,'_','VSLength')), 'dir')
        saveas(gcf,fullfile(SaveIn,strcat(NewName,'_','VSLength')))
        saveas(gcf,fullfile(SaveIn,strcat(NewName,'_','VSLength')),'tiff')
        close all
    else
        close all
    end

end





% VS LENGHT MEAN SCATTER
 


for h = [2 3 4 5 6 7 8 9 10 11 12 14 15 16]

    j = 0;

    for i = 1:NumberFiles
        TableOrVars = strfind(NameFiles(i,:),'TABLE'); % Will tell in the current
        % name readed as the word 'TABLE' on it
        if isempty(TableOrVars) % If doesnt have it means is the Variables
            j = j + 1 ;
            load(fullfile(Path2Files(i,:),NameFiles(i,:)),'Name','TableAnimal'); % loading just names
            Temp = char(Name);
            WeekDouble(j) = sscanf( Temp(5) , '%d'); % Week of the animal
            FishDouble(j) = sscanf( Temp(18) , '%d');  % Number of the animal
            TrialDouble(j) = sscanf( Temp(end), '%d'); % Number Trial
            DateDouble(j)  = sscanf( Temp(7:12), '%d');


            Length = table2array(TableAnimal(1,13));
            Var = table2array(TableAnimal(1:end,h));

            X = Length; 

            scatter(X(NonZeros),mean(Var(NonZeros)),[],[blueGRADIENTfixed(str2double(Temp(5)),:)],'filled'), hold on
          
            xlabel('Length')
            ylabel(TableAnimal.Properties.VariableNames(h))



        else
        end
    end

    temp = char(TableAnimal.Properties.VariableNames(h)); 
        NewName =temp(1:end-5); 


      SaveIn = "C:\Users\Usuario\OneDrive\Escritorio\Var_vs_length"; 
    if ~exist(fullfile(SaveIn,strcat(NewName,'_','VSLength')), 'dir')
        saveas(gcf,fullfile(SaveIn,strcat(NewName,'_','VSLength_Mean')))
                saveas(gcf,fullfile(SaveIn,strcat(NewName,'_','VSLength_Mean')),'tiff')
        close all
    else
        close all
    end

end







% FREQ VS AMPLITUD
close all

 h = [2 3]; 
j = 0;
% close all

    for i = 1:NumberFiles
        TableOrVars = strfind(NameFiles(i,:),'TABLE'); % Will tell in the current
        % name readed as the word 'TABLE' on it
        if isempty(TableOrVars) % If doesnt have it means is the Variables
            j = j + 1 ;
            load(fullfile(Path2Files(i,:),NameFiles(i,:)),'Name','TableAnimal'); % loading just names
            Temp = char(Name);
            WeekDouble(j) = sscanf( Temp(5) , '%d'); % Week of the animal
            FishDouble(j) = sscanf( Temp(18) , '%d');  % Number of the animal
            TrialDouble(j) = sscanf( Temp(end), '%d'); % Number Trial
            DateDouble(j)  = sscanf( Temp(7:12), '%d');
            Weekh = str2num(Temp(5));

            Length = table2array(TableAnimal(1:end,h(1)));
            Var = table2array(TableAnimal(1:end,h(2)));

          


            scatter(Length,Var,[],[blueGRADIENTfixed(str2double(Temp(5)),:)],'filled'), hold on
            xlabel('Freq')
            ylabel('Ampl')


        else
        end
    end

    temp = char(TableAnimal.Properties.VariableNames(h)); 
        NewName =temp(1:end-5); 


      SaveIn = "C:\Users\Usuario\OneDrive\Escritorio\Var_vs_length"; 
    if ~exist(fullfile(SaveIn,strcat(NewName,'_','VSDate')), 'dir')
        saveas(gcf,fullfile(SaveIn,strcat(NewName,'_','VSLength')))
        close all
    else
        close all
    end




 % NUMBER OF CYCLES
j = 0;
% close all

    for i = 1:NumberFiles
        TableOrVars = strfind(NameFiles(i,:),'TABLE'); % Will tell in the current
        % name readed as the word 'TABLE' on it
        if isempty(TableOrVars) % If doesnt have it means is the Variables
            j = j + 1 ;
            load(fullfile(Path2Files(i,:),NameFiles(i,:)),'Name','TableAnimal'); % loading just names
            Temp = char(Name);
            WeekDouble(j) = sscanf( Temp(5) , '%d'); % Week of the animal
            FishDouble(j) = sscanf( Temp(18) , '%d');  % Number of the animal
            TrialDouble(j) = sscanf( Temp(end), '%d'); % Number Trial
            DateDouble(j)  = sscanf( Temp(7:12), '%d');
            Weekh = str2num(Temp(5));

            Length = table2array(TableAnimal(1,13));
            Var = length(table2array(TableAnimal(1:end,1)));

          
             

            X = Length.*ones(1,length(Var )); 

            scatter(X,Var,[],[blueGRADIENTfixed(str2double(Temp(5)),:)],'filled'), hold on
            xlabel('Length')
            ylabel('Number Half Cycles')



        else
        end
    end
% 
%     temp = char(TableAnimal.Properties.VariableNames(h)); 
%         NewName =temp(1:end-5); 


      SaveIn = "C:\Users\Usuario\OneDrive\Escritorio\Var_vs_length"; 
    if ~exist(fullfile(SaveIn,strcat(NewName,'_','VSDate')), 'dir')
        saveas(gcf,fullfile(SaveIn,strcat('NumCycles','_','VSLength')))
         saveas(gcf,fullfile(SaveIn,strcat('NumCycles','_','VSLength_Mean')),'tiff')
        close all
    else
        close all
    end


%% GROUP PLOTING MEAN OF TRIAL PER FISH

% Frequency pulling animal per date
 

Variable = 1; 
NumberCycles = 4; 

lightBLUE = [0.356862745098039,0.811764705882353,0.956862745098039];
darkBLUE = [0.0196078431372549,0.0745098039215686,0.670588235294118];
kk = length(fieldnames(Var)); 
blueGRADIENTfixed = [linspace(lightBLUE(1),darkBLUE(1),kk)',...
    linspace(lightBLUE(2),darkBLUE(2),kk)', linspace(lightBLUE(3),darkBLUE(3),kk)'];

for i = 1:length(fieldnames(Var))
    temp = fieldnames(Var);
    myfield = char(temp(i)); 
    AnimalIndex = find(Var.(myfield)(:,6)); 
    for ii = 1:NumberCycles
    CyMean(ii,i) = mean(Var.(myfield)(AnimalIndex+ii-1,Variable)); 
    Cystd(ii,i) = std(Var.(myfield)(AnimalIndex+ii-1,Variable)); 
    scatter(ii,CyMean(ii,i),[],blueGRADIENTfixed(i,:),'filled'),hold on
    end 
    plot(CyMean(:,i),'color',blueGRADIENTfixed(i,:))

end 
xlim([0 4])


% Frequency ploting EACH FISH 

Variable = 1; 

lightBLUE = [0.356862745098039,0.811764705882353,0.956862745098039];
darkBLUE = [0.0196078431372549,0.0745098039215686,0.670588235294118];
kk = length(fieldnames(Var)); 
blueGRADIENTfixed = [linspace(lightBLUE(1),darkBLUE(1),kk)',...
    linspace(lightBLUE(2),darkBLUE(2),kk)', linspace(lightBLUE(3),darkBLUE(3),kk)'];

for i = 1:length(fieldnames(Var))
    temp = fieldnames(Var);
    myfield = char(temp(i));
    AnimalIndex = find(Var.(myfield)(:,6));
    dif = diff(AnimalIndex); 

    for ii = 1:length(AnimalIndex)
        if length(dif)>=ii
            plot(Var.(myfield)(AnimalIndex(ii):dif(ii),Variable),'color',blueGRADIENTfixed(i,:)),hold on
            %scatter([1:dif(ii)],Var.(myfield)(AnimalIndex(ii):dif(ii),Variable),[],blueGRADIENTfixed(i,:),'filled'),hold on
        else 
            plot(Var.(myfield)(AnimalIndex(ii):end,Variable),'color',blueGRADIENTfixed(i,:))
            %scatter([1:lengt(dif(ii-1)+1-],Var.(myfield)(AnimalIndex(ii):dif(ii),Variable),[],blueGRADIENTfixed(i,:),'filled'),hold on

        end 
       

    end
    plot(CyMean(:,i),'color',blueGRADIENTfixed(i,:))

end



