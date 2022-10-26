%% David Madrid . Last Rev 05/05/2022 

%% 1. Coordinates Extraction

% Path to the CSV file

PathCSV = char(FirstVariable_cell(SelectedaCell,:)); 

CSV_file = table2array(readtable(fullfile(DLC_directory,PathCSV),'NumHeaderLines',3)); %@ SET number of Headers

% Frame vector

frames = CSV_file(1:end,1); 
light.likehood = round(CSV_file(:,4));
laserframeON = find( light.likehood,1,'first');
laserframeOFF = find( light.likehood,1,'last');

laserframe = laserframeON:laserframeOFF;

% Coordinates

Head.x = CSV_file(:,5);
Head.y = CSV_file(:,6);
Hindbrain.x = CSV_file(:,8);
Hindbrain.y = CSV_file(:,9);
SC1.x = CSV_file(:,11); 
SC1.y = CSV_file(:,12);
SC2.x = CSV_file(:,14);
SC2.y = CSV_file(:,15);
SC3.x = CSV_file(:,17);
SC3.y = CSV_file(:,18);
SC4.x = CSV_file(:,20); 
SC4.y = CSV_file(:,21);
SC5.x = CSV_file(:,23);
SC5.y = CSV_file(:,24);
SC6.x = CSV_file(:,26);
SC6.y = CSV_file(:,27);
SC7.x = CSV_file(:,29); 
SC7.y = CSV_file(:,30);
SC8.x = CSV_file(:,32); 
SC8.y = CSV_file(:,33);

%3D matrix with coordinates for the ploting

Coor3D = NaN(10,2,length(frames)); % 10 points, 2 colums (x,y), length frames
for i = 1:length(frames)
    Coor3D(:,1,i) = [Head.x(i);Hindbrain.x(i);SC1.x(i);SC2.x(i);SC3.x(i) ;...
        SC4.x(i);SC5.x(i);SC6.x(i);SC7.x(i);SC8.x(i)]; % xcolumn
    Coor3D(:,2,i) = [Head.y(i);Hindbrain.y(i);SC1.y(i);SC2.y(i);SC3.y(i) ;...
        SC4.y(i);SC5.y(i);SC6.y(i);SC7.y(i);SC8.y(i)]; % ycolumn
end 




%Path for the LABELLED video

x = split(PathCSV ,'.csv');
PathLBvideo = strcat(x{1},'_id_labeled.mp4'); 

%Path for the ORIGINAL video

PathORVideo = strcat(Name,'.avi');

clear x 