% Extraction of corrected, normalised experimental data from Stelling
% paper. 

FileName_Data = readtable('all_data_compensated.txt');
FileName_Data_ToUse = FileName_Data(:,1:3); 

FRY11_Citrine = FileName_Data_ToUse{strcmp(FileName_Data_ToUse.strain,{'FRY11'}),3};
FRY11_Citrine_Median = median(FRY11_Citrine);
yRG88_Citrine = FileName_Data_ToUse{strcmp(FileName_Data_ToUse.strain,{'yRG88'}),3};
yRG88_Citrine_Median = median(yRG88_Citrine);
ScalingF = (yRG88_Citrine_Median-FRY11_Citrine_Median);

FileName_Data_Tagged = FileName_Data_ToUse(strcmp(FileName_Data_ToUse.strain,{'yRG500'}),2:3);
IPTG = unique(FileName_Data_Tagged{:,1})';
Cit=cell(1,length(IPTG));

Citrine_Median = zeros(1,length(IPTG));
Citrine_Mean = zeros(1,length(IPTG));
Citrine_q25 = zeros(1,length(IPTG));
Citrine_q75 = zeros(1,length(IPTG));
Citrine_iqr = zeros(1,length(IPTG));

for i=1:length(unique(IPTG))
    Cit{i}=FileName_Data_Tagged{FileName_Data_Tagged.iptg == IPTG(i),2};
    Cit_corrected = (Cit{i}-FRY11_Citrine_Median)/ScalingF;
    Citrine_Median(i) = median(Cit_corrected);
    Citrine_Mean(i) = mean(Cit_corrected);
    Citrine_q25(i) = quantile(Cit_corrected, 0.25);
    Citrine_q75(i) = quantile(Cit_corrected, 0.75);
    Citrine_iqr(i) = iqr(Cit_corrected);
end

%save('Stelling_CorrExperimentalData.mat','IPTG','Citrine_Median','Citrine_iqr','Citrine_q25','Citrine_q75','ScalingF')

%%