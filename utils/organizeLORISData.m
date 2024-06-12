DataDictionary (DataDictionary.data_table)

    DataDictionary.Modality = 'Cognitive Evaluation';
    DataDictionary.data_table

rf = rowfilter(DataDictionary);
rf2 = (rf.data_table == "AD8");

Tar = nan(1,height(DataDictionary));
T = table (Tar.');
T.Properties.VariableNames(1) = "Modality";

DataDictionary = [DataDictionary T];
DataDictionary (rf,'Modality') = "Cognitive";

% Add the Modality column
DataDictionary.Modality = repmat({''}, height(DataDictionary), 1);
% Cognition
    % APS Alzheimer's Progression Score
    % AD8 Dementia Screening Score
    % EL_CAIDE - dementia risk
    % EL_CDR_MoCA - montreal cognitive assesment
    % DKEFS-CWIT 
    % RAVLT - auditory verbal learning - episodic memory
    % RBANS - immediate memory, visuospatial/constructional abilities, language, attention, and delayed memory
    % TMT - trial making test - measures attention, visual screening ability, and processing speed, and is a good measure of overall cognitive functioning

% Sensorimotor
    % Auditory_Processing
    % Smell_identification 

% Medical
     % BP_Pulse_Weight 
     % Med_use 
     % EL_Medical_history 
   
 % Histology
     % CSF_proteins 
     % Lab 

% Demographic
     % Demographics 
          
% Genetic
    % Genetics 

for k = 1:height(DataDictionary)
    if DataDictionary.data_table(k) == 'AD8' |  DataDictionary.data_table(k) == 'APS' |...
             DataDictionary.data_table(k) == 'EL_CAIDE'|  DataDictionary.data_table(k) == 'EL_CDR_MoCA' |...
                DataDictionary.data_table(k) == 'DKEFS-CWIT' | DataDictionary.data_table(k) == 'RAVLT'|...
                    DataDictionary.data_table(k) == 'RBANS' | DataDictionary.data_table(k) == 'TMT'
        DataDictionary.Modality(k) = "Cognition";
    end
end

for k = 1:height(DataDictionary)
    if DataDictionary.data_table(k) == 'Auditory_processing'...
     |  DataDictionary.data_table(k) == 'Smell_identification'
        DataDictionary.Modality(k) = "Sensorimotor";
    end
end

for k = 1:height(DataDictionary)
    if DataDictionary.data_table(k) == 'BP_Pulse_Weight'...
     |  DataDictionary.data_table(k) == 'Med_use' ...
     |  DataDictionary.data_table(k) == 'EL_Medical_history'
        DataDictionary.Modality(k) = "Medical";
    end
end

for k = 1:height(DataDictionary)
    if DataDictionary.data_table(k) == 'CSF_proteins'...
     |  DataDictionary.data_table(k) == 'Lab' 
        DataDictionary.Modality(k) = "Histological";
    end
end

for k = 1:height(DataDictionary)
    if DataDictionary.data_table(k) == 'Genetics'

        DataDictionary.Modality(k) = "Genetic";
    end
end


for k = 1:height(DataDictionary)
    if DataDictionary.data_table(k) == 'Demographics '

        DataDictionary.Modality(k) = "Demographic";
    end
end


