%% David Madrid . Last Rev 05/05/2022 

%% 1. Dynamicly loading the animal

T = cell2table(TempMatrix); 
T = rows2vars(T); 
T=T(:,(2:end)); 


fig = uifigure;
h = uitable( fig,'Data', T); % set up a table
h.Selection = []; % select a cell programmatically
h.SelectionType; % default 'cell', could be 'row' or 'column'
h.Multiselect; % default 'on', could be 'off', but will interact with SelectionType


% Animals already analyzed will appear in red

if any(AnimalAnalyzed)
    s = uistyle('BackgroundColor','red');
    addStyle(h,s,'row',find(AnimalAnalyzed))
end

pause(2)

str = 'N';
while isequal(str,'N')
prompt = 'You want to select this animal? For Yes click any letter different form N: ';
str = input(prompt,'s');
end

temp = h.Selection;
SelectedaCell = temp(1);
temp1 = table2cell(T(SelectedaCell,:));
all_fig = findall(0, 'type', 'figure');
close(all_fig)



% Name of the file loaded

 Name_temp = string(temp1); 
 Name = strjoin(Name_temp,'_'); 
 disp(strcat('Loading animal selected:',{' '},Name))



% Creating the loading animal path selected on the table.
% This path is used to save and load DATA.

CurrentSavingPath = fullfile(path.data,temp1{:}); 
 if isfile(fullfile(CurrentSavingPath,strcat(Name,'.mat')))
     disp('This animal has been already analyzed.')   
     prompt = 'Do you want to use previous data (D) or reanalyzed(R)?:'; 
     str = input(prompt,'s');
     if isequal(str,'D')
         load(fullfile(CurrentSavingPath,strcat(Name,'.mat')));
         disp(strcat('Loading animal selected:',{' '},Name))
         load(fullfile(path.MainFolder,'AnimalAnalyzed.mat'))
     elseif isequal(str,'R')
         disp(strcat('The Animal:',{' '},Name,{' '},'was not uploaded'))
         load(fullfile(path.MainFolder,'AnimalAnalyzed.mat'))
     else
         error('The answer must be D or R')
     end 

 end 

 clear T temp1 fig h s str prompt temp Name_temp all_fig ans