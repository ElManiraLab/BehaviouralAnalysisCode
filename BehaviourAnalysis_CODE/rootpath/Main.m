 %% David Madrid . Last Rev 27/04/2022 

% Loading with UI TABLE
clear
clc
S1_user_settings
S2_Loading_Animal
S3_Coordinates_DLC
S4_Check_labels
S5_Vector_Computation
S6_Semiautomatic
S7_Automatic
S8_Table
S10_saving



% Loading automaticly
close all
clear
clc
S1_user_settings

%list
for SelectedaCell = 12%1:size(TempMatrix,2)
    T = cell2table(TempMatrix);
    T = rows2vars(T);
    T=T(:,(2:end));
    temp1 = table2cell(T(SelectedaCell,:));

    % Name of the file loaded
    Name_temp = string(temp1);
    Name = strjoin(Name_temp,'_');
    disp(strcat('Loading animal selected:',{' '},Name))


    % If DLC_output contains more then one type of experiment, this is the
    % place for puting a if loop to select the experiment that you want


    % Creating the loading animal path selected on the table.
    % This path is used to save and load DATA.
    CurrentSavingPath = fullfile(path.data,temp1{:});
    
       clear T temp1 fig h s str prompt temp Name_temp all_fig ans

       S3_Coordinates_DLC
       S4_Check_labels
       % Check video
       S5_Vector_Computation
       S6_Semiautomatic
       S7_Automatic
       S8_Table
       S10_saving
       FFFF(SelectedaCell ) = sum(wave.*ConverFact); 
       clearvars -except FFFF
       clc
       S1_user_settings
end

writetable(TableAnimal.swm_1,fullfile(path.MainFolder,'Caudal Hinbrain Ablations spon.xlsx'));
               