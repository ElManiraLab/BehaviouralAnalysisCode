function [WeekVs] = Week_vs(path,Var)

files = dir(strcat(path.data,'\**\*.mat'));
NumberFiles = size(char(files.name),1);
NameFiles = char(files.name);
Path2Files = char(files.folder);

% JustWeek = cell(1,NumberFiles); 
% for i = 1:NumberFiles
% JustWeek{i} = NameFiles(i,[1:5]);
% end 
% 
% c = categorical(JustWeek);
% categories(c);
% Repet = countcats(c);

for i = 1:NumberFiles
    %   temp = load(fullfile(Path2Files(i,:),NameFiles(i,:)));
    temp = load(fullfile(Path2Files(i,:),NameFiles(i,:)), Var);
    WeekVs.(NameFiles(i,[1:5])) = temp; 

    %   temp.(Var)
end 
end
