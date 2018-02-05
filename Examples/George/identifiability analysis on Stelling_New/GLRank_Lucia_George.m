results_folder = strcat('GalOpenLoop2',datestr(now,'yyyy-mm-dd-HHMMSS'));
short_name     = 'PLac12';

inputs.pathd.results_folder = results_folder;
inputs.pathd.short_name     = short_name;
inputs.pathd.runident       = 'Identifiability analysis';

inputs.model=Model_OpenLoop_Old_Lucia_George();
inputs=loadExperimentSettings_Lucia_George(inputs);
inputs=loadGrankSettings_Lucia_George(inputs);


AMIGO_Prep(inputs);                           
  
AMIGO_GRank(inputs)         % Calls the task for Global Rank

AMIGO_LRank(inputs)

inputs.model=Model_OpenLoop_NewPE_Lucia_George();
inputs=loadExperimentSettings_Lucia_George(inputs);
inputs=loadGrankSettings_Lucia_George(inputs);


AMIGO_Prep(inputs);                           
  
AMIGO_LRank(inputs)