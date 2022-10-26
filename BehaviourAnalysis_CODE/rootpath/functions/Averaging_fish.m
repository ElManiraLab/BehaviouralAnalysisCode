function [] = Averaging_fish()

files = dir(strcat(path.data,'\**\*.mat'));
NumberFiles = size(char(files.name),1);
NameFiles = char(files.name);
Path2Files = char(files.folder);



for i = 1:NumberFiles
    %   temp = load(fullfile(Path2Files(i,:),NameFiles(i,:)));
    temp = load(fullfile(Path2Files(i,:),NameFiles(i,:)), Var);
    WeekVs.(NameFiles(i,[1:5])) = temp; 

    %   temp.(Var)
end 

end

