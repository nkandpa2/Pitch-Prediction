function freqMatrix = makeFrequencyMatrix(strikes, balls, pitchType, pitchResult, zones)

%%Frequency matrix has columns in the order:
%%Fastball-strike, Fastball-ball, Slider-strike, Slider-ball, Curve-strike,
%%Curve-ball, Changeup-strike, Changeup-ball, No previous pitch

%%Row order is same as columns but without 'no previous pitch'
freqMatrix = zeros(8,9);

range = [1:length(strikes)];

reference = {'FF', 'SL', 'CU', 'CH', 'FA'};
strike = {'Swinging Strike', 'Called Strike'};

for a = range
    
    %%Find previous state (column index)
    if balls(a) == 0 && strikes(a) == 0
        column = 9;
    else
        pitch = strcmp(reference, pitchType(a - 1));
        column = 2 * (find(pitch == 1));
        
        if sum(strcmp(pitchResult(a - 1), strike)) || zones(a - 1) < 10
            column = column - 1;
        end
        
        %%adjustment for use of FA instead of FF for Fastball 
        if column > 8
            column = column - 8;
        end
        
    end
    
    %%Find current state (row index)
    pitch = strcmp(reference, pitchType(a));
    row = 2 * (find(pitch == 1));
    
    if sum(strcmp(pitchResult(a), strike)) || zones(a) < 10
        row = row - 1;
    end
    if row > 8
        row = row - 8;
    end
    
    
    %%Increment the correct entry of freqMatrix
    freqMatrix(row, column) = freqMatrix(row, column) + 1;
    
end

end