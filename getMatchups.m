function [strikes, balls, pitchType, pitchResult, zones, batter] = getMatchups(pathPitcher, pathBatters)

strikes = []; balls = []; pitchType = []; pitchResult = []; zones = []; batter = [];


[num, batterList] = xlsread(pathBatters,'A1:B38');

[s, b, pType, pResult, z, l] = getData(pathPitcher);
[num, plays] = xlsread(pathPitcher,strcat('U2:U',l));

for i = (1:length(plays))
    i
    curr = strsplit(cell2mat(plays(i)),' ');
    for j = [1:length(batterList)]
        if strcmp(curr{1},batterList(j,1)) && strcmp(curr{2},batterList(j,2))
            strikes = [strikes; s(i)];
            balls = [balls; b(i)];
            pitchType = [pitchType; pType(i)];
            pitchResult = [pitchResult; pResult(i)];
            zones = [zones; z(i)];
            batter = [batter; {strcat(curr{1},'_',curr{2})}];
        end
    end
end
end

            