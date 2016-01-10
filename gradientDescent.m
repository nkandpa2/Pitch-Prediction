function [alpha, beta, costArray] = gradientDescent(strikes, balls, pitchType, pitchResult, zones, batter)
dir = 'C:/Users/Nikhil/Pitch_Prediction/';
reference = {'FF', 'SL', 'CU', 'CH', 'FA'};
strike = {'Swinging Strike', 'Called Strike'};

pitcherMatrix = load(strcat(dir,'Pitcher_Data/C_Kershaw/Markov_Matrix.mat'));

alpha = rand(1);
beta = 1 - alpha;
lr = 0.1;
costArray = [];

numUpdates = 0;
while (length(costArray) > 1 && abs(costArray(end)-costArray(end-1)) < 1) || numUpdates < 30
numUpdates = numUpdates + 1   
cost = 0;
gradient = [];
for a = 1:30
    disp(a);
    index = round(rand(1)*length(batter));
    curr = batter{index};
    curr = strsplit(curr,'_');
    firstName = curr{1};
    lastName = curr{2};
    batterMatrix = load(strcat(dir,'Batter_Data/',firstName(1),'_',lastName,'/Markov_Matrix.mat'));
    
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
        
    expected = zeros(8,1);
    expected(row) = 1;
        
    cost = cost + norm(expected - prediction);
    disp(cost);
        
    syms a b l
        
    L = norm(expected - a*P - b*B) + l*(a + b - 1);
    f1 = diff(L,a);
    f2 = diff(L,b);
    f3 = diff(L,l);
    
    %%disp('solving system');
    sol = vpasolve([f1==0 f2==0 f3==0], [a b l]);
    %%disp('solved');
    if abs(sol.a) < 10
        gradient = [gradient; sol.a, sol.b]
    end
    clearvars batterMatrix;
end

gradient = mean(gradient);
costArray = [costArray; cost/30];
alpha = alpha + lr*(gradient(1) - alpha)
beta = beta + lr*(gradient(2) - beta)
end
end







        
        
        
    
    
    
    
