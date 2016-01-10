function [accuracyPitchType, accuracyBallStrike, accuracyBoth] = testModel(pathPitcher, pathBatter, alpha, beta)

dir = 'C:/Users/Nikhil/Pitch_Prediction/';

strikes = []; balls = []; pitchType = []; pitchResult = []; zones = []; batter = [];
for a = [3:5]
    p = strcat(pathPitcher,num2str(a),'.csv');
    [s, b, pType, pResult, z, bat] = getMatchups(p, pathBatter);
    strikes = [strikes; s];
    balls = [balls; b];
    pitchType = [pitchType; pType];
    pitchResult = [pitchResult; pResult];
    zones = [zones; z];
    batter = [batter; bat];
end

reference = {'FF', 'SL', 'CU', 'CH', 'FA'};
strike = {'Swinging Strike', 'Called Strike'};
dir = 'C:/Users/Nikhil/Pitch_Prediction/';

pitcherMatrix = load(strcat(dir,'Pitcher_Data/C_Kershaw/Markov_Matrix.mat'));

pitchTypeCorrect = 0;
pitchTypeIncorrect = 0;

correct = 0;
incorrect = 0;

ballStrikeCorrect = 0;
ballStrikeIncorrect = 0;

for a = 1:length(batter)
    disp(a);
    curr = batter{a};
    curr = strsplit(curr,'_');
    firstName = curr{1};
    lastName = curr{2};
    batterMatrix = load(strcat(dir,'Batter_Data/',firstName(1),'_',lastName,'/Markov_Matrix.mat'));
    
    if balls(a) == 0 && strikes(a) == 0
        column = 9;
    else
        %%Check to see which pitch was previously thrown
        pitch = strcmp(reference, pitchType(a - 1));
        column = 2*find(pitch == 1);
        
        %%Check to see if previous pitch was ball or strike
        if sum(strcmp(pitchResult(a - 1), strike)) || zones(a - 1) < 10
            column = column - 1;
        end
        
        %%Adjustment for FA abbreviation for fastball (as opposed to FF)
        if column > 8
            column = column - 8;
        end
    end
    
    if isempty(column)
        continue;
    end
    
    prediction = alpha*pitcherMatrix.Markov(:,column) + beta*batterMatrix.Markov(:,column);
    
    %%Check to see which pitch is thrown next
    pitch = strcmp(reference, pitchType(a));
    row = 2*find(pitch == 1);
        
    %%Check to see if next pitch is ball or strike
    if sum(strcmp(pitchResult(a), strike)) || zones(a) < 10
        row = row - 1;
    end
        
    %%Adjustment for FA abbreviation for fastball (as opposed to FF)
    if row > 8
        row = row - 8;
    end
    
    if isempty(row)
        continue;
    end
    
    
    pred = find(prediction == max(prediction));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    %%Check if both the ball/strike and pitch predictions are correct
    if row == pred
        correct = correct + 1;
    else
        incorrect = incorrect + 1;
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    %%Check if pitch prediction is correct
    if mod(pred,2) == 0
        pt = pred/2;
    else
        pt = (pred + 1)/2;
    end
 
    if strcmp(reference{pt}, pitchType(a)) || (strcmp(reference{pt},'FF') && strcmp(pitchType{a},'FA'))
        pitchTypeCorrect = pitchTypeCorrect + 1;
    else
        pitchTypeIncorrect = pitchTypeIncorrect + 1;
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    %%Check if ball/strike prediction is correct
    if sum(strcmp(pitchResult(a), strike)) || zones(a) < 10
        if mod(pred,2) == 1
            ballStrikeCorrect = ballStrikeCorrect + 1;
        else
            ballStrikeIncorrect = ballStrikeIncorrect + 1;
        end
    else
        if mod(pred,2) == 0
            ballStrikeCorrect = ballStrikeCorrect + 1;
        else
            ballStrikeIncorrect = ballStrikeIncorrect + 1;
        end
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    clearvars batterMatrix;
end

accuracyBoth = correct/(incorrect + correct);
accuracyPitchType = pitchTypeCorrect/(pitchTypeIncorrect + pitchTypeCorrect);
accuracyBallStrike = ballStrikeCorrect/(ballStrikeCorrect + ballStrikeIncorrect);

disp(strcat('Percent correct (pitch and ball/strike prediction): ', num2str(accuracyBoth)));
disp(strcat('Correct: ', num2str(correct),{'    '}, 'Incorrect: ', num2str(incorrect)));

disp(strcat('Percent correct (pitch prediction): ', num2str(accuracyPitchType)));
disp(strcat('Correct: ', num2str(pitchTypeCorrect),{'    '},'Incorrect: ',num2str(pitchTypeIncorrect)));

disp(strcat('Percent correct (ball/strike prediction): ', num2str(accuracyBallStrike)));
disp(strcat('Correct: ', num2str(ballStrikeCorrect),{'    '},'Incorrect: ',num2str(ballStrikeIncorrect)));

end