%% David Madrid . Last Rev 27/04/2022


if isequal(TypeExperiment,'SIE')

    AnimalAnalyzed (SelectedaCell) = 1; % Saving the animal on the list
    save(fullfile(path.MainFolder, 'AnimalAnalyzed.mat'),'AnimalAnalyzed'); % Saving list

    clear AnimalAnalyzed
    w = whos;

    for a = 1:length(w)
        Animal.(w(a).name) = eval(w(a).name);
    end
    filename = strcat(Name,'.mat'); % Creating the name
    save(fullfile(CurrentSavingPath,filename),'-struct','Animal'); % Saving in the correct folder
    % as a struct

elseif isequal(TypeExperiment,'SW')
% 
%     if std(wave) > MaxAcceptedStd
%     else

        AnimalAnalyzed (SelectedaCell) = 1; % Saving the animal on the list
        save(fullfile(path.MainFolder, 'AnimalAnalyzed.mat'),'AnimalAnalyzed'); % Saving list

        clear AnimalAnalyzed
        w = whos;

        for a = 1:length(w)
            Animal.(w(a).name) = eval(w(a).name);
        end
        filename = strcat(Name,'.mat'); % Creating the name
        save(fullfile(CurrentSavingPath,filename),'-struct','Animal'); % Saving in the correct folder
        % as a struct
% 
%     end
end