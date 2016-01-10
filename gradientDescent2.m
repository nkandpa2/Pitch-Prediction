function [alphaArray, betaArray, costArray] = gradientDescent2(strikes, balls, pitchType, pitchResult, zones, batter)
dir = 'C:/Users/Nikhil/Pitch_Prediction/';
reference = {'FF', 'SL', 'CU', 'CH', 'FA'};
strike = {'Swinging Strike', 'Called Strike'};

pitcherMatrix = load(strcat(dir,'Pitcher_Data/C_Kershaw/Markov_Matrix.mat'));

alpha = rand(1)
beta = 1 - alpha
lr = 3;
costArray = [];
alphaArray = [alpha];
betaArray = [beta];
alphaRange = 10;

numUpdates = 0;
%%while (length(costArray) > 1 && abs(costArray(end)-costArray(end-1)) > 1) || numUpdates < 30
while alphaRange > 0.02
numUpdates = numUpdates + 1   
cost = 0;
gradient = [];
skippedEntries = 0;
for a = 1:50
    %%disp(a);
    index = ceil(rand(1)*length(batter));
    curr = batter{index};
    curr = strsplit(curr,'_');
    firstName = curr{1};
    lastName = curr{2};
    batterMatrix = load(strcat(dir,'Batter_Data/',firstName(1),'_',lastName,'/Markov_Matrix.mat'));
    %%disp(lastName);
    
    %%Beginning of count
    if balls(index) == 0 && strikes(index) == 0
        column = 9;
    else
        %%Check to see which pitch was previously thrown
        pitch = strcmp(reference, pitchType(index - 1));
        column = 2*find(pitch == 1);
        
        %%Check to see if previous pitch was ball or strike
        if sum(strcmp(pitchResult(index - 1), strike)) || zones(index - 1) < 10
            column = column - 1;
        end
        
        %%Adjustment for FA abbreviation for fastball (as opposed to FF)
        if column > 8
            column = column - 8;
        end
    end
    
    if isempty(column)
        skippedEntries = skippedEntries + 1
        continue;
    end
    
    P = pitcherMatrix.Markov(:,column);
    B = batterMatrix.Markov(:,column);
    prediction = alpha*P + beta*B;
        
    %%Check to see which pitch is thrown next
    pitch = strcmp(reference, pitchType(index));
    row = 2*find(pitch == 1);
        
    %%Check to see if next pitch is ball or strike
    if sum(strcmp(pitchResult(index), strike)) || zones(index) < 10
        row = row - 1;
    end
        
    %%Adjustment for FA abbreviation for fastball (as opposed to FF)
    if row > 8
        row = row - 8;
    end
    
    if isempty(row)
        skippedEntries = skippedEntries + 1
        continue;
    end
        
    expected = zeros(8,1);
    expected(row) = 1;
        
    cost = cost + norm(expected - prediction);
    %%disp(cost);
        
    syms a b 
        
    L = norm(expected - a*P - b*B);
    fa = subs(diff(L,a),[a b],[alpha beta]);
    fb = subs(diff(L,b),[a b],[alpha beta]);
    
    directionVector = [-1/sqrt(2), 1/sqrt(2)];
    
    derivative = dot([fa fb], directionVector);
    
    update = vpa(derivative*directionVector);
    
    gradient = [gradient; update];
    
    %%disp(update);
    
    clearvars batterMatrix;
end

gradient = mean(gradient);
costArray = [costArray; cost/(50 - skippedEntries)];
alpha = alpha - lr*gradient(1)
beta = beta - lr*gradient(2)
alphaArray = [alphaArray; alpha];
betaArray = [betaArray; beta];

if length(alphaArray) >  5
    max = 0;
    min = 10;
    for i = 0:3
        curr = alphaArray(end - i);
        if curr > max
            max = curr;
        end
        
        if curr < min
            min = curr;
        end
    end
    
    alphaRange = max - min;
end

        
end
end