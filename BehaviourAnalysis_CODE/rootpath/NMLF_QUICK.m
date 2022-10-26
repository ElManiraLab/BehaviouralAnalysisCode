close all
clear
clc
S1_user_settings
for SelectedaCell = 1:size(TempMatrix,2)
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
       S5_Vector_Computation
       S6_Semiautomatic
       S7_Automatic
       S8_Table
       FFFF(SelectedaCell,[1 2]) = [nonzeros(table2array(TableAnimal(:,9)))...
           nonzeros(table2array(TableAnimal(1,16)))]; 
       clearvars -except FFFF
       clc
       S1_user_settings
end
FFFF