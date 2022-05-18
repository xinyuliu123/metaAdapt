%FITS SIGMOID TO BASELINE DATA, RETURN FITTED MODEL
%BASEFIT.PSE_BASE IS THE PSE OF BASELINE

function[sigFit] = getPSE(rawResult,keyResponse)
%% CREATE AN OBJECT THAT STORES RESPONSES BASE ON STAIRCASE LEVELS
notNanIdx = ~isnan(rawResult); rawResult = rawResult(notNanIdx);
[allLevels,~,LevIdx] = unique(rawResult); respArry=cell(1,length(allLevels)); LevIdx = LevIdx.';
for counter = 1: length(rawResult)
    respArry{LevIdx(counter)}(end+1) = keyResponse(counter);
end


%% CALCULATE PERCENTAGE NARROW FOR EACH LEVEL
numNarrow=cell(1,length(allLevels)); percentNarrow=cell(1,length(allLevels));
for counter2 = 1: length(allLevels)
    numNarrow{counter2} = numel(respArry{counter2}) - nnz(respArry{counter2});
    percentNarrow{counter2} = numNarrow{counter2}./numel(respArry{counter2});
end


%% SIGMOID FIT
percentNarrow = cell2mat(percentNarrow);
[fitResult, goFit, xDataPts, yDataPts] = sig_fit(allLevels, percentNarrow);

sigFit.Levels = allLevels; sigFit.Result = fitResult; 
sigFit.xBase = xDataPts; sigFit.yBase = yDataPts;
pse_base = coeffvalues(fitResult); sigFit.pse_base = pse_base(2); 
