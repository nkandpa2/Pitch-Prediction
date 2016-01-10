function [alpha, beta] = computeCoefficients(pathPitcher, pathBatter)
pathPitcher = 'C:/Users/Nikhil/Pitch_Prediction/Pitcher_Data/C_Kershaw/201';
pathBatter = 'C:/Users/Nikhil/Pitch_Prediction/Batter_List.csv';

strikes = []; balls = []; pitchType = []; pitchResult = []; zones = []; batter = [];
for a = [0:2]
    p = strcat(pathPitcher,num2str(a),'.csv');
    [s, b, pType, pResult, z, bat] = getMatchups(p, pathBatter);
    strikes = [strikes; s];
    balls = [balls; b];
    pitchType = [pitchType; pType];
    pitchResult = [pitchResult; pResult];
    zones = [zones; z];
    batter = [batter; bat];
end

alphas = [];
for a = 1:3
    [alphaArray, betaArray, costArray] = gradientDescent2(strikes, balls, pitchType, pitchResult, zones, batter);
    alphas = [alphas; alphaArray(end)];
    figure;
    plot(alphaArray);
end

alpha = mean(alphas);
beta = 1 - alpha;

end
    
    

    


