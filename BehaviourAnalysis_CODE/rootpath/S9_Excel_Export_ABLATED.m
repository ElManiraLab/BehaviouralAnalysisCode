%% David Madrid . Last Rev 18/05/2022

%{

EXTREMLY IMPORTANT!,each video needs to have a unique name, (week,fish,trial,condition)
adding a new fish to the porject must respect the previous names already
in it. THIS CODE ALLOWS FOR DIFERENT CONFIGURATION OF THE DATA TO EXPORT

%}

clear
clc



% 1.Reading directories of all files inside de DATA folder
S1_user_settings
files = dir(strcat(path.data,'\**\*.mat'));
NumberFiles = size(char(files.name),1);
NameFiles = char(files.name);
Path2Files = char(files.folder);


% 2. Extracting names and parameters

%{

 In each of the Data subfolders there is a variable with all the variables of the
 analysis and a table variable with just the variables that will be
 exported in excel. In this case, the table var is not needed, is just for
 access easily in case of error, the variable that must be imported
 here is the variables with all variables inside, this is, the one that
 doesnt contain TABLE in the name. Also there can be other variables on it.
 
The best way is divided in case using a if loop

%}



% 3. Loop to extract names of the variables in the subfolders.
YouDONTWant2Analyze = '_SW_';

j = 0;
for i = 1:NumberFiles
    TableOrVars = strfind(NameFiles(i,:),'TABLE'); % Will tell in the current
    % name readed as the word 'TABLE' on it

    isFIG = strfind(NameFiles(i,:),'FIG');
     SIEorSW = strfind(NameFiles(i,:),YouDONTWant2Analyze); 


    % Because we are in the Escape if loop we have to select just the
    % variables that doesnt have TABLE or SW in their names

    if isempty(isFIG) && isempty(SIEorSW)  % If doesnt have it means is the Variables
        j = j + 1 ;
        load(fullfile(Path2Files(i,1:end),NameFiles(i,:)),'Name','TableAnimal'); % loading just names
        Temp = char(Name);

        FishDouble(j) = sscanf( Temp(20) , '%d');  % Number of the animal
        TrialDouble(j) = sscanf( Temp(end), '%d'); % Number Trial
        WeekDouble(j)  = sscanf( Temp(6) , '%d');

        if isequal(Temp(8:14),'Control')
            h = 1;
        elseif isequal(Temp(8:14),'Ablated')
            h = 2;
        end
        DateDouble(j) =  h; % Week of the animal

    else
    end
end



%% ESCAPE 
% THE SAME DATE WILL BE CONSECUTIVE UNTIL IS DONE
clear TEMP AnimalAve Animal
ACUM2  = 0;
ACUM = 0;
j = 0;
add = 0;
DistanceFromTop = 3;
LateralDistance = 20;
NameDestin = 'Caudal Hinbrain Ablations.xlsx';


YouDONTWant2Analyze = '_SW_';


for i = 1:NumberFiles
    TableOrVars = strfind(NameFiles(i,:),'TABLE'); % Will be one if the Name readed
    % correspond to a Table
    isFIG = strfind(NameFiles(i,:),'FIG');
    SIEorSW = strfind(NameFiles(i,:),YouDONTWant2Analyze);

    if isempty(TableOrVars) &&  isempty(isFIG) && isempty(SIEorSW)

        load(fullfile(Path2Files(i,:),NameFiles(i,:)),'Name','TableAnimal');
        Temp = char(Name);
        Week = Temp(1:6);
        if isequal(Temp(8:14),'Control')
            h = 1;
        elseif isequal(Temp(8:14),'Ablated')
            h = 2;
        end
        Date =  h; % Week of the animal

        Fish = Temp(20);

        j = j + 1 ;

        if  j == 1 || WeekDouble(j)==WeekDouble(j-1)

            if FishDouble(j) == str2double(Fish) && j == 1

                myfield = strcat('A',num2str(j));
                TEMP.(myfield) = table2array(TableAnimal);





            elseif FishDouble(j) == str2double(Fish) && FishDouble(j)==FishDouble(j-1) &&...
                    DateDouble(j) ==  DateDouble(j-1)

                myfield = strcat('A',num2str(j));
                TEMP.(myfield) = table2array(TableAnimal);


            else

                for ii = 1:length(fieldnames(TEMP))
                    TEMP1 = fieldnames(TEMP);
                    TEMP2 = char(TEMP1(ii));
                    c = 0;
                    while size(TEMP.(TEMP2),1) >c
                        Animal(1+c,:,ii) = TEMP.(TEMP2)(1+c,:);
                        c = c + length(c);
                    end
                end

                AnimalAve = mean(Animal,3);

                Column = xlscol(1+ACUM2);
                Row = num2str(DistanceFromTop);

                RowParam = Row - 1;





                %                 %Store variable
                %                 if DateDouble(j)==DateDouble(j-1)
                %                 StoreVariable = strcat('D',num2str(DateDouble(j))); %@ SET
                %                 Var.(StoreVariable)((1+add):(Dims(1)+add),1:Dims(2)) =  AnimalAve;
                %                 else
                %
                %                       StoreVariable = strcat('D',num2str(DateDouble(j-1))); %@ SET
                %                 Var.(StoreVariable)((1+add):(Dims(1)+add),1:Dims(2)) =  AnimalAve;
                %                 end


                %                 ACUM = Dims(1);
                %                 add = ACUM +add;


                writematrix(AnimalAve,fullfile(path.MainFolder,NameDestin),'Sheet',strcat('Week',num2str(WeekDouble(j))),'Range',strcat(Column,Row));
                RowName=  num2str(1);



                writecell({strcat(num2str(DateDouble((j-1))),'Fish',num2str(FishDouble(j-1)))},fullfile(path.MainFolder,NameDestin),'Sheet',...
                    strcat('Week',num2str(WeekDouble(j))),'Range',strcat(Column, RowName))

                writecell(TableAnimal.Properties.VariableNames,fullfile(path.MainFolder,NameDestin),'Sheet',...
                    strcat('Week',num2str(WeekDouble(j))),'Range',strcat(Column, RowParam ))


                ACUM2 = LateralDistance + ACUM2;



                clear TEMP
                clear AnimalAve Animal

                myfield = strcat('A',num2str(j));
                TEMP.(myfield) = table2array(TableAnimal);

            end

        else

            for ii = 1:length(fieldnames(TEMP))
                TEMP1 = fieldnames(TEMP);
                TEMP2 = char(TEMP1(ii));
                c = 0;
                while size(TEMP.(TEMP2),1) >c
                    Animal(1+c,:,ii) = TEMP.(TEMP2)(1+c,:);
                    c = c + length(c);
                end
            end

            AnimalAve = mean(Animal,3);

            Column = xlscol(1+ACUM2);
            Row = num2str(DistanceFromTop);

            RowParam = Row - 1;



            writematrix(AnimalAve,fullfile(path.MainFolder,NameDestin),'Sheet',strcat('Week',num2str(WeekDouble(j-1))),'Range',strcat(Column,Row));
            RowName=  num2str(1);

            writecell({strcat(num2str(DateDouble((j-1))),'Fish',num2str(FishDouble(j-1)))},fullfile(path.MainFolder,NameDestin),'Sheet',...
                strcat('Week',num2str(WeekDouble(j-1))),'Range',strcat(Column, RowName))

            writecell(TableAnimal.Properties.VariableNames,fullfile(path.MainFolder,NameDestin),'Sheet',...
                strcat('Week',num2str(WeekDouble(j-1))),'Range',strcat(Column, RowParam ))

            ACUM2 = 0;


            clear TEMP
            clear AnimalAve Animal

            myfield = strcat('A',num2str(j));
            TEMP.(myfield) = table2array(TableAnimal);




        end

    end
end



%% SPONTANEUS SWIMMING ABLATED. NOT AVEREGING, DIFERENTS VIDEOS ARE NOT DIFFERENT TRIALS,
% JUST THE CONTINUATION OF THE SAME TRIAL 
%%%%%%%%%%%%% EACH TAB IS A WEEK

    % ASUMING AN ORDER ON THE DATA, THERE WILL NOT BE JUMPS ON THE DATES AND
    % THE SAME DATE WILL BE CONSECUTIVE UNTIL IS DONE

    clear TEMP AnimalAve Animal
    ACUM2  = 0;
    ACUM = 0;
    j = 0;
    add = 0;
    DistanceFromTop = 3;
    LateralDistance = 20;
    NameDestin = 'sw.xlsx';

    YouDONTWant2Analyze = '_SIE_';


    for i = 1:NumberFiles
        TableOrVars = strfind(NameFiles(i,:),'TABLE'); % Will be one if the Name readed
        % correspond to a Table

        SIEorSW = strfind(NameFiles(i,:),YouDONTWant2Analyze);
        isFIG = strfind(NameFiles(i,:),'FIG');

        if  isempty(SIEorSW) && isempty(isFIG)


            load(fullfile(Path2Files(i,1:end),NameFiles(i,:)),'Name','TableAnimal','EPISODE_X');



            Temp = char(Name);
            Week = Temp(1:6);
            if isequal(Temp(8:14),'Control')
                h = 1;
            elseif isequal(Temp(8:14),'Ablated')
                h = 2;
            end
            Date =  h; % Week of the animal

            Fish = Temp(20);

            j = j + 1 ;



            if  j == 1 || WeekDouble(j)==WeekDouble(j-1)

                if FishDouble(j) == str2double(Fish) && j == 1

                    myfield = strcat('A',num2str(j));
                    TEMP.(myfield) = table2array(TableAnimal);





                elseif FishDouble(j) == str2double(Fish) && FishDouble(j)==FishDouble(j-1) &&...
                        DateDouble(j) ==  DateDouble(j-1)

                    myfield = strcat('A',num2str(j));
                    TEMP.(myfield) = table2array(TableAnimal);


                else

                    ADD = 0;

                    for ii = 1:length(fieldnames(TEMP))
                        TEMP1 = fieldnames(TEMP);
                        TEMP2 = char(TEMP1(ii));

                        Animal((1 +ADD):size(TEMP.(TEMP2))+ADD,:) = TEMP.(TEMP2);
                        ADD = size(TEMP.(TEMP2)) + ADD;
                        cont(1) = 1;
                        cont(ii + 1) = ADD (1) + 1;

                    end


                    if  (length(cont)-1) >= 2

                        AnimalAve(:,1:5) = Animal(:,1:5);
                        AnimalAve(1,6) = max(Animal(cont(1:2),6));
                        AnimalAve(1,7) = max(Animal(:,7));
                        AnimalAve(1,8) = sum(Animal(:,8));
                        AnimalAve(1,9) =  sum(Animal(:,9));
                        AnimalAve(1,10) = mean(Animal(:,1));
                        AnimalAve(1,11) = mean(Animal(:,2));
                        AnimalAve(1,12) = mean(Animal(:,3));
                        AnimalAve(1,13) = mean(Animal(:,4));
                        AnimalAve(1,14) = sum(Animal(:,14));
                        AnimalAve(1,15) = Animal(1,15);
                        AnimalAve(1,16) = sum(Animal(:,16));


                    end


                    Column = xlscol(1+ACUM2);
                    Row = num2str(DistanceFromTop);

                    RowParam = Row - 1;


                    %                 %Store variable
                    %                 if DateDouble(j)==DateDouble(j-1)
                    %                 StoreVariable = strcat('D',num2str(DateDouble(j))); %@ SET
                    %                 Var.(StoreVariable)((1+add):(Dims(1)+add),1:Dims(2)) =  AnimalAve;
                    %                 else
                    %
                    %                       StoreVariable = strcat('D',num2str(DateDouble(j-1))); %@ SET
                    %                 Var.(StoreVariable)((1+add):(Dims(1)+add),1:Dims(2)) =  AnimalAve;
                    %                 end


                    %                 ACUM = Dims(1);
                    %                 add = ACUM +add;

                    if exist('AnimalAve','var')

                        writematrix(AnimalAve,fullfile(path.MainFolder,NameDestin),'Sheet',strcat('Week',num2str(WeekDouble(j))),'Range',strcat(Column,Row));
                        RowName=  num2str(1);

                        writecell({strcat(Week,'_',num2str(DateDouble((j-1))),'Fish',num2str(FishDouble(j-1)))},fullfile(path.MainFolder,NameDestin),'Sheet',...
                            strcat('Week',num2str(WeekDouble(j))),'Range',strcat(Column, RowName))

                        writecell(TableAnimal.Properties.VariableNames,fullfile(path.MainFolder,NameDestin),'Sheet',...
                            strcat('Week',num2str(WeekDouble(j))),'Range',strcat(Column, RowParam ))


                        ACUM2 = LateralDistance + ACUM2;

                    else
                    end


                    clear TEMP AnimalAve Animal cont


                    myfield = strcat('A',num2str(j));
                    TEMP.(myfield) = table2array(TableAnimal);

                end

            else

                ADD = 0;

                for ii = 1:length(fieldnames(TEMP))
                    TEMP1 = fieldnames(TEMP);
                    TEMP2 = char(TEMP1(ii));

                    Animal((1 +ADD):size(TEMP.(TEMP2))+ADD,:) = TEMP.(TEMP2);
                    ADD = size(TEMP.(TEMP2)) + ADD;
                    cont(1) = 1;
                    cont(ii + 1) = ADD (1) + 1;

                end

                if (length(cont)-1) >= 2

                    AnimalAve(:,1:5) = Animal(:,1:5);
                    AnimalAve(1,6) = max(Animal(cont(1:2),6));
                    AnimalAve(1,7) = max(Animal(:,7));
                    AnimalAve(1,8) = sum(Animal(:,8));
                    AnimalAve(1,9) =  sum(Animal(:,9));
                    AnimalAve(1,10) = mean(Animal(:,1));
                    AnimalAve(1,11) = mean(Animal(:,2));
                    AnimalAve(1,12) = mean(Animal(:,3));
                    AnimalAve(1,13) = mean(Animal(:,4));
                    AnimalAve(1,14) = sum(Animal(:,14));
                    AnimalAve(1,15) = Animal(1,15);
                    AnimalAve(1,16) = sum(Animal(:,16));


                end


                Column = xlscol(1+ACUM2);
                Row = num2str(DistanceFromTop);

                RowParam = Row - 1;



                if exist('AnimalAve','var')

                    writematrix(AnimalAve,fullfile(path.MainFolder,NameDestin),'Sheet',strcat('Week',num2str(WeekDouble(j-1))),'Range',strcat(Column,Row));
                    RowName=  num2str(1);

                    writecell({strcat('Week',num2str(WeekDouble((j-1))),'_',num2str(DateDouble((j-1))),'Fish',num2str(FishDouble(j-1)))},fullfile(path.MainFolder,NameDestin),'Sheet',...
                        strcat('Week',num2str(WeekDouble((j-1)))),'Range',strcat(Column, RowName))

                    writecell(TableAnimal.Properties.VariableNames,fullfile(path.MainFolder,NameDestin),'Sheet',...
                        strcat('Week',num2str(WeekDouble(j-1))),'Range',strcat(Column, RowParam ))




                else
                end


                ACUM2 = 0;
                clear TEMP  AnimalAve Animal cont

                myfield = strcat('A',num2str(j));
                TEMP.(myfield) = table2array(TableAnimal);




            end


        end
    end



    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %% SPONTANEUS SWIMMING FOR VIDEOS RECORDED HIGH FRAME RATE AND EACH VIDEO MAY CONTAIN
    %  MORE THAN ONE EPISODE.

    % ASUMING AN ORDER ON THE DATA, THERE WILL NOT BE JUMPS ON THE DATES AND
    % THE SAME DATE WILL BE CONSECUTIVE UNTIL IS DONE

    clear TEMP
    counter = [0 0]; % first value is for the control and second for the ablated
    counter2 = 0; 
    DistanceFromTop = 3;
    LateralDistance = 20;
    NameDestin = 'sw.xlsx';

    for i = 1:NumberFiles
        TableOrVars = strfind(NameFiles(i,:),'TABLE'); % Will be one if the Name readed

        if  ~isempty(TableOrVars)
            

            load(fullfile(Path2Files(i,1:end),NameFiles(i,:)),'Name','TableAnimal','EPISODE_X');



            Temp = char(Name);
            Week = Temp(1:6);
            if isequal(Temp(8:14),'Control')
                h = 1;
            elseif isequal(Temp(8:14),'Ablated')
                h = 2;
            end
            Date =  h; % Week of the animal

            Fish = Temp(20);


            for k=1:length(fieldnames(EPISODE_X))

                temp1 = fieldnames(EPISODE_X);
                myfield1 = char(temp1(k));
                temp5 = table2array(TableAnimal.(myfield1));

                Column = xlscol(1+counter(Date));
                Row = num2str(DistanceFromTop);
                RowParam = Row - 1;


                writematrix(temp5,fullfile(path.MainFolder,NameDestin),'Sheet',strcat('Condition',num2str(Date)),'Range',strcat(Column,Row));
                RowName=  num2str(1);

                writecell({Name},fullfile(path.MainFolder,NameDestin),'Sheet',...
                    strcat('Condition',num2str(Date)),'Range',strcat(Column, RowName))

                writecell(  TableAnimal.(myfield1).Properties.VariableNames,fullfile(path.MainFolder,NameDestin),'Sheet',...
                    strcat('Condition',num2str(Date)),'Range',strcat(Column, RowParam ))


                A( [(1+counter2):length(temp5(:,1))+counter2],1) = temp5(:,1); % Freq
                 A( [(1+counter2):length(temp5(:,1))+counter2],2) = temp5(:,2); % Amplitude

              %scatter(A(:,1),A(:,2))


                counter(Date) = LateralDistance + counter(Date);
                counter2 = counter2 + length(temp5(:,1)); 

                

            end
        end
    end


