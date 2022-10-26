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

YouDONTWant2Analyze ='_SIE_';
    j = 0;
    for i = 1:NumberFiles
        TableOrVars = strfind(NameFiles(i,:),'TABLE'); % Will tell in the current
        % name readed as the word 'TABLE' on it
        SIEorSW = strfind(NameFiles(i,:),YouDONTWant2Analyze); % Will tell if the current name is SW
        isFIG = strfind(NameFiles(i,:),'FIG');

        % Because we are in the Escape if loop we have to select just the
        % variables that doesnt have TABLE or SW in their names

        if isempty(TableOrVars) &&  isempty(SIEorSW)  && isempty(isFIG)  % If doesnt have it means is the Variables
            j = j + 1 ;
            load(fullfile(Path2Files(i,1:end-1),NameFiles(i,:)),'Name','TableAnimal'); % loading just names
            Temp = char(Name);
            WeekDouble(j) = sscanf( Temp(5) , '%d'); % Week of the animal
            FishDouble(j) = sscanf( Temp(18) , '%d');  % Number of the animal
            TrialDouble(j) = sscanf( Temp(end), '%d'); % Number Trial
            DateDouble(j)  = sscanf( Temp(7:12), '%d');
        else
        end
    end

    % Next section comment allow us to have EACH TAB IS A DATE, INSIDE EACH TAB, EACH COLUMN IS A FISH
    %%%%%%%%%%%%% AND  EACH ROW IS A TRIAL


   %{


  % 4. All the animals analyzed must have the same dimesions for the table to export. 

    Dims = size(TableAnimal); % Dimensions of the table to export

    MatrixPosition = [WeekDouble',DateDouble',NaN(length(DateDouble),1),...
        NaN(length(DateDouble),1),FishDouble',TrialDouble']; % Matrix with all the data

    % The date must be year/month/day
    for i = 1:size(MatrixPosition ,1)
        temp = num2str(MatrixPosition(i,2));
        if numel(temp) == 6
            temp1 = strcat(temp(5:6),temp(3:4),temp(1:2));
            MatrixPosition(i,3) = str2double(temp1);
        elseif numel(temp) == 5
            MatrixPosition(i,3) = str2double(strcat(temp(4:5),temp(2:3),'0',temp(1)));
        else
            error('Number of elements on the date is wrong')
        end
    end


    % changing the value of the date for integers
    for i = unique(MatrixPosition(:,1))'
        temp = find(MatrixPosition(:,1) == i);
        temp1 = unique(sort((MatrixPosition(temp,3))));
        for j = 1:length(temp1)
            temp2 = find(MatrixPosition(temp,3)==temp1(j)) ;
            MatrixPosition(temp(temp2),4) = j;
        end
    end



    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%% EACH TAB IS A DATE, INSIDE EACH TAB, EACH COLUMN IS A FISH
    %%%%%%%%%%%%% AND  EACH ROW IS A TRIAL

    SpaceBtwFish = Dims(2) + 4 ; % Horizontal separation
    SpaceBtwTrial = Dims(1) + 25; % Vertical separation


    FinalPositon(:,1) =  MatrixPosition(:,1); % The column week is the same
    FinalPositon (:,2) = ((MatrixPosition (:,5)-1).*SpaceBtwFish)+1;
    FinalPositon (:,3) = ((MatrixPosition (:,6)-1).*SpaceBtwTrial)+1;


    clear Name TableAnimal
    j = 0;

    for i = 1:NumberFiles
        TableOrVars = strfind(NameFiles(i,:),'TABLE'); % Will be one if the Name readed
        % correspond to a Table

        SIEorSW = strfind(NameFiles(i,:),YouDONTWant2Analyze); % Will tell if the current name is SW
        isFIG = strfind(NameFiles(i,:),'FIG');

        if isempty(TableOrVars) &&  isempty(SIEorSW)  && isempty(isFIG) 
            j = j + 1 ;
            load(fullfile(Path2Files(i,:),NameFiles(i,:)),'Name','TableAnimal');
            Temp = char(Name);
            Week = Temp(1:5);
            Date = Temp(7:12);

            Column = xlscol(FinalPositon (j,2));
            Row = num2str(FinalPositon (j,3));
            RowData = num2str(FinalPositon (j,3) +2 );

            xlswrite(fullfile(path.MainFolder,'SE.xlsx'),{Name},strcat(Date,Week),strcat(Column, Row)) ;

            if exist('TableAnimal','var')
                writetable(TableAnimal,fullfile(path.MainFolder,'SE.xlsx'),'Sheet',strcat(Date,Week),'Range',strcat(Column,RowData));
            else
            end

            Excel = actxserver('excel.application');
            WB = Excel.Workbooks.Open(fullfile(path.MainFolder,'SE.xlsx'),0,false);
            % Set the color of cell "A1" of Sheet 1 to RED
            WB.Worksheets.Item(strcat(Date,Week)).Range(strcat(Column, Row,':',...
                xlscol(FinalPositon (j,2)+2),Row)).Interior.ColorIndex = 3;

            if exist('TableAnimal','var')
                WB.Worksheets.Item(strcat(Date,Week)).Range(strcat(Column, RowData,':',...
                    xlscol(FinalPositon (j,2)+Dims(2)-1),RowData)).Interior.ColorIndex = 4;
            else
            end


            % Save Workbook
            WB.Save();
            % Close Workbook
            WB.Close();
            % Quit Excel
            Excel.Quit();

            clear TableAnimal Name

        else
        end
    end

 %}

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%% JUST ONE TAB, EACH COLUMN IS A DATE, AND YOU HAVE POOL ALL
    %%%%%%%%%%%%% THE DATA FROM ALL THE ANIMALS AND TRIALS. THIS IS ALSO
    %%%%%%%%%%%%% CREATING A STRUCTURE WHERE EACH FIELD IS A COLUMN OF THE
    %%%%%%%%%%%%% EXCEL FIELD, THIS IS, A DATE. 

    % ASUMING AN ORDER ON THE DATA, THERE WILL NOT BE JUMPS ON THE DATES AND
    % THE SAME DATE WILL BE CONSECUTIVE UNTIL IS DONE

    ACUM2  = 0;
    ACUM = 0;
    j = 0;
    add = 0;
    DistanceFromTop = 3;
    LateralDistance = 20;
    NameDestin = 'SIE.xlsx';



YouDONTWant2Analyze =;

    for i = 1:NumberFiles
        TableOrVars = strfind(NameFiles(i,:),'TABLE'); % Will be one if the Name readed
        % correspond to a Table

        SIEorSW = strfind(NameFiles(i,:),YouDONTWant2Analyze);
        isFIG = strfind(NameFiles(i,:),'FIG');

        if isempty(TableOrVars) &&  isempty(SIEorSW) && isempty(isFIG) 
            j = j + 1 ;
            load(fullfile(Path2Files(i,:),NameFiles(i,:)),'Name','TableAnimal');
            Temp = char(Name);
            Week = Temp(1:5);
            Date = Temp(7:12);

            if  DateDouble(j) == str2double(Date) && j == 1 % First value %@ SET


                Dims = size(TableAnimal); % Dimensions of the table to export


                Column = xlscol(1+ACUM2);
                Row = num2str(DistanceFromTop +add);

                %       Store variable
                StoreVariable = strcat('D',Date); %@ SET
                Var.(StoreVariable)=  table2array(TableAnimal);
                Var.(StoreVariable)((1+add):(Dims(1)+add),1:Dims(2)) =  table2array(TableAnimal);

                ACUM = Dims(1);
                add = ACUM +add;


                writematrix(table2array(TableAnimal),fullfile(path.MainFolder,NameDestin),'Sheet',1,'Range',strcat(Column,Row));

                % CUSTOM EXCEL
                RowName=  num2str(1);
                writecell({strcat(Week,'_',Date)},fullfile(path.MainFolder,NameDestin),'Sheet',1,'Range',strcat(Column, RowName))
                RowParam =  num2str(2);
                writecell(TableAnimal.Properties.VariableNames,fullfile(path.MainFolder,NameDestin),'Sheet',1,'Range',strcat(Column, RowParam ))




                %         Excel = actxserver('excel.application');
                %         WB = Excel.Workbooks.Open(fullfile(path.MainFolder,NameDestin),0,false);
                %         % Set the color of cell "A1" of Sheet 1 to RED
                %         WB.Worksheets.Item(1).Range(strcat(Column, RowParam,':',xlscol(1+ACUM2+Dims(2)),RowParam)).Interior.ColorIndex = 3;
                %         WB.Worksheets.Item(1).Range(strcat(Column, RowName )).Interior.ColorIndex = 4;
                %          % Save Workbook
                %         WB.Save();
                %         % Close Workbook
                %         WB.Close();
                %         % Quit Excel
                %         Excel.Quit();


            elseif DateDouble(j) == str2double(Date) && DateDouble(j)==DateDouble(j-1)

                Dims = size(TableAnimal); % Dimensions of the table to export


                Column = xlscol(1+ACUM2);
                Row = num2str(DistanceFromTop +add);


                %Store variable
                StoreVariable = strcat('D',Date); %@ SET
                Var.(StoreVariable)((1+add):(Dims(1)+add),1:Dims(2)) =  table2array(TableAnimal);


                ACUM = Dims(1);
                add = ACUM +add;






                writematrix(table2array(TableAnimal),fullfile(path.MainFolder,NameDestin),'Sheet',1,'Range',strcat(Column,Row));
            else

                ACUM2 = LateralDistance + ACUM2;
                ACUM  = 0;
                add = 0;

                Dims = size(TableAnimal); % Dimensions of the table to export


                Column = xlscol(1+ACUM2);
                Row = num2str(DistanceFromTop +add);



                %Store variable
                StoreVariable = strcat('D',Date); %@ SET
                Var.(StoreVariable)((1+add):(Dims(1)+add),1:Dims(2)) =  table2array(TableAnimal);


                ACUM = Dims(1);
                add = ACUM +add;

                writematrix(table2array(TableAnimal),fullfile(path.MainFolder,NameDestin),'Sheet',1,'Range',strcat(Column,Row));


                % CUSTOM EXCEL
                RowName=  num2str(1);
                writecell({strcat(Week,'_',Date)},fullfile(path.MainFolder,NameDestin),'Sheet',1,'Range',strcat(Column, RowName))
                RowParam =  num2str(2);
                writecell(TableAnimal.Properties.VariableNames,fullfile(path.MainFolder,NameDestin),'Sheet',1,'Range',strcat(Column, RowParam ))


                %         Excel = actxserver('excel.application');
                %         WB = Excel.Workbooks.Open(fullfile(path.MainFolder,NameDestin),0,false);
                %         % Set the color of cell "A1" of Sheet 1 to RED
                %         WB.Worksheets.Item(1).Range(strcat(Column, RowParam,':',xlscol(1+ACUM2+Dims(2)),RowParam)).Interior.ColorIndex = 3;
                %         WB.Worksheets.Item(1).Range(strcat(Column, RowName )).Interior.ColorIndex = 4;
                %          % Save Workbook
                %         WB.Save();
                %         % Close Workbook
                %         WB.Close();
                %         % Quit Excel
                %         Excel.Quit();
                %

            end
        end
    end

    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ESCAPE AVERIGING
    %%%%%%%%%%%%% EACH TAB IS A WEEK, WE CALCULATE THE MEAN FOR EACH FISH, EACH
    %%%%%%%%%%%%% FISH CONSIST IN 17 VALUES (OR THE NUMBER OF COLUMNS OF
    %%%%%%%%%%%%% THE TABLE).
    %%%%%%%%%%%%% THE MEAN OF THE VARIABLES DEPENDING ON THE NUMBER OF 
    %%%%%%%%%%%%% CYCLES WILL BE AVERAGE PER CYCLE. FOR EXAMPLE. AVERAGES
    %%%%%%%%%%%%% OF THE FREQUENCIES OF ALL THE TRIALS PER CYCLES 1,
    %%%%%%%%%%%%% THE SAME FOR CYCLES 2...ETC. THE VARIABLES THAT ARE JUST
    %%%%%%%%%%%%% ONE VALUE (LATENCY, DURATION OF C BEND WILL BE AVERAGES ACROSS TRIALS)

    % ASUMING AN ORDER ON THE DATA, THERE WILL NOT BE JUMPS ON THE DATES AND
    % THE SAME DATE WILL BE CONSECUTIVE UNTIL IS DONE
clear TEMP AnimalAve Animal
ACUM2  = 0;
ACUM = 0;
j = 0;
add = 0;
DistanceFromTop = 3;
LateralDistance = 20;
NameDestin = 'SIE.xlsx';

YouDONTWant2Analyze =;


for i = 1:NumberFiles
    TableOrVars = strfind(NameFiles(i,:),'TABLE'); % Will be one if the Name readed
    % correspond to a Table

    SIEorSW = strfind(NameFiles(i,:),YouDONTWant2Analyze);
    isFIG = strfind(NameFiles(i,:),'FIG');

    if isempty(TableOrVars) &&  isempty(SIEorSW) && isempty(isFIG)

        load(fullfile(Path2Files(i,:),NameFiles(i,:)),'Name','TableAnimal');
        Temp = char(Name);
        Week = Temp(1:5);
        Date = Temp(7:12);
        Fish = Temp(18);

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

       

                    writecell({strcat(Week,'_',num2str(DateDouble((j-1))),'Fish',num2str(FishDouble(j-1)))},fullfile(path.MainFolder,NameDestin),'Sheet',...
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
                writecell({strcat('Week',num2str(WeekDouble((j-1))),'_',num2str(DateDouble((j-1))),'Fish',num2str(FishDouble(j-1)))},fullfile(path.MainFolder,NameDestin),'Sheet',...
                    strcat('Week',num2str(WeekDouble((j-1)))),'Range',strcat(Column, RowName))

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



%% SPONTANEUS SWIMMING. NOT AVEREGING, DIFERENTS VIDEOS ARE NOT DIFFERENT TRIALS,
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
NameDestin = 'SW.xlsx';

YouDONTWant2Analyze = '_SIE_';


for i = 1:NumberFiles
    TableOrVars = strfind(NameFiles(i,:),'TABLE'); % Will be one if the Name readed
    % correspond to a Table

    SIEorSW = strfind(NameFiles(i,:),YouDONTWant2Analyze);
    isFIG = strfind(NameFiles(i,:),'FIG');

    if isempty(TableOrVars) &&  isempty(SIEorSW) && isempty(isFIG)

        load(fullfile(Path2Files(i,1:end-1),NameFiles(i,:)),'Name','TableAnimal');
        Temp = char(Name);
        Week = Temp(1:5);
        Date = Temp(7:12);
        Fish = Temp(18);

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


                if str2double(Week(end))>=5 && (length(cont)-1) >= 2

                AnimalAve(:,1:5) = Animal(:,1:5);
                AnimalAve(1,6) = max(Animal(cont(1:2),6)); 
                AnimalAve(1,7) = max(Animal(cont(1:2),7));
                AnimalAve(1,8) = sum(Animal(cont(1:2),8)); 
                AnimalAve(1,9) =  sum(Animal(cont(1:2),9));
                AnimalAve(1,10) = mean(Animal(:,1)); 
                AnimalAve(1,11) = mean(Animal(:,2));
                AnimalAve(1,12) = mean(Animal(:,3)); 
                AnimalAve(1,13) = mean(Animal(:,4)); 
                AnimalAve(1,14) = sum(Animal(cont(1:2),14)); 
                AnimalAve(1,15) = Animal(1,15);
                AnimalAve(1,16) = sum(Animal(cont(1:2),16)); 

                elseif str2double(Week(end))<=4

                AnimalAve(:,1:5) = Animal(:,1:5); 
                AnimalAve(1,6) = Animal(1,6); 
                AnimalAve(1,7) = Animal(1,7); 
                AnimalAve(1,8) = Animal(1,8); 
                AnimalAve(1,9) = Animal(1,9); 
                AnimalAve(1,10) = mean(Animal(:,1)); 
                AnimalAve(1,11) = mean(Animal(:,2));
                AnimalAve(1,12) = mean(Animal(:,3)); 
                AnimalAve(1,13) = mean(Animal(:,4)); 
                AnimalAve(1,14) = Animal(1,14); 
                AnimalAve(1,15) = Animal(1,15); 
                AnimalAve(1,16) = Animal(1,16);

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

                if str2double(Week(end))>=5 && (length(cont)-1) >= 2

                AnimalAve(:,1:5) = Animal(:,1:5);
                AnimalAve(1,6) = max(Animal(cont(1:2),6)); 
                AnimalAve(1,7) = max(Animal(cont(1:2),7));
                AnimalAve(1,8) = sum(Animal(cont(1:2),8)); 
                AnimalAve(1,9) =  sum(Animal(cont(1:2),9));
                AnimalAve(1,10) = mean(Animal(:,1)); 
                AnimalAve(1,11) = mean(Animal(:,2));
                AnimalAve(1,12) = mean(Animal(:,3)); 
                AnimalAve(1,13) = mean(Animal(:,4)); 
                AnimalAve(1,14) = sum(Animal(cont(1:2),14)); 
                AnimalAve(1,15) = Animal(1,15);
                AnimalAve(1,16) = sum(Animal(cont(1:2),16)); 

                elseif str2double(Week(end))<=4

                AnimalAve(:,1:5) = Animal(:,1:5); 
                AnimalAve(1,6) = Animal(1,6); 
                AnimalAve(1,7) = Animal(1,7); 
                AnimalAve(1,8) = Animal(1,8); 
                AnimalAve(1,9) = Animal(1,9); 
                AnimalAve(1,10) = mean(Animal(:,1)); 
                AnimalAve(1,11) = mean(Animal(:,2));
                AnimalAve(1,12) = mean(Animal(:,3)); 
                AnimalAve(1,13) = mean(Animal(:,4)); 
                AnimalAve(1,14) = Animal(1,14); 
                AnimalAve(1,15) = Animal(1,15); 
                AnimalAve(1,16) = Animal(1,16);

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
