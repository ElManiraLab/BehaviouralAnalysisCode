%% David Madrid . Last Rev 26/05/2022 

%% 1. Paths

path.MainFolder = pwd; % Main Path. Running from the rootpath
addpath(genpath(path.MainFolder)); % Adding all files and folders inside rootpath to the path

% Data folder. Where all the mat variables and figures will be store.
path.data  = fullfile(path.MainFolder(1:end-8),'Data'); % DATA path (where data will be stored)

if isfolder(path.data) % checking if Data folder is created
else
    mkdir (path.data) % Otherwise create the directory
end

% DLC_output folder. Where all the DLC output will be copied.
DLC_directory =  fullfile(path.MainFolder(1:end-8),'DLC_output'); % Directory where DLC output
% will be copy

if isfolder(DLC_directory) % checking if DLC_directory folder is created
else
    mkdir (DLC_directory) % Otherwise create the directory
end


% Checking for elements inside the DLC_output folder. 
CsvElements = dir([DLC_directory '/*.csv']); csv_num=length(CsvElements); % csv files
VideoLabelledElements = dir([DLC_directory  '/*.mp4']); VideoLabll_num=length(VideoLabelledElements); % Labelled videos
VideoElements = dir([DLC_directory  '/*.avi']); Video_num=length(VideoElements); % Original videos

% If the folder was just created it will be empty. Printing instruction for
% copying all the files inside the folder. 


if csv_num==0 && VideoLabll_num==0 && Video_num == 0
   fprintf([' There are no files inside the DLC_output folder. \n Please copy' ...
       ' all the files you want to analyze\n ' ...
       '(original video, labelled video and csv file) inside DLC_' ...
       'output folder.']); 
   return
else 
end 


% Once all files are copied--> Control: same number of files of each data
% format? To avoid errors, there must be the same number of files of each
% format (i.e.: .avi, .mp4, .csv)
equality_matrix = [ csv_num  VideoLabll_num Video_num ]; % Controling that for one video there are
% csv, original video and labelled video


if all(equality_matrix == equality_matrix(1))
    disp('Same number of .csv, .mp4 and .avi files.')
else
    fprintf(strcat(' Number of .csv files',' = ',num2str(csv_num),'\n Number'...
        ,' of .avi files',' = ',num2str(Video_num),'\n Number of .mp4 files',' = ',...
        num2str(VideoLabll_num),'\n'));
   error(' Different number of csv, mp4 and avi files. Check for missing files.') 
end  

%% 2. Directories and list variables. If everything before is correct the list will be created. 
%     For this list it will be use the name .csv elements

FirstVariable_cell = struct2cell(CsvElements); 
FirstVariable_cell = FirstVariable_cell(1,:)';
list = strings(length(FirstVariable_cell),1);

for i = 1:length(FirstVariable_cell)
 x = split(FirstVariable_cell(i,1),"DLC");
 list{i,1} = x{1};
end 


% Creating directories based on variable names divided by '_'

TempMatrix = cell(length(split(char(list(1)),'_')),length(list)); % All data will be store 
% in a cell matrix


% Creating variable that contains all the information about the Name of the
% animals 

for i = 1:length(list)
    Temp = split(char(list(i)),'_');
    TempDir = path.data;
    for ii = 1:length(Temp) % Each itearion subfolders are being created
        if isfolder(fullfile(TempDir,Temp{ii}))
            TempDir = fullfile(TempDir,Temp{ii});
        else
            mkdir(fullfile(TempDir,Temp{ii}))
            TempDir = fullfile(TempDir,Temp{ii});
        end
    end

    for j = 1:length(Temp)
        TempMatrix{j,i} = Temp(j,1);
    end
    
end 

% Loading or creating the variable list with all the animal 
% to keep record of which one have been already analyzed

if exist(fullfile(path.MainFolder, 'AnimalAnalyzed.mat'),'file') ==2
    load(fullfile(path.MainFolder, 'AnimalAnalyzed.mat'))
else
    AnimalAnalyzed = zeros(1,length(list));
    save(fullfile(path.MainFolder, 'AnimalAnalyzed.mat'),'AnimalAnalyzed');
end

clear Temp TempDir i j x equality_matrix 





