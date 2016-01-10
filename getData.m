function [strikes, balls, pitchType, pitchResult, zones, varargout] = getData(path)

%%Find the number of rows in the spreadsheet
fileID = fopen(path);
if fileID >= 0
    file = textscan(fileID, '%s %*[^\n]');
    fileLength = length(file{1}) + 1;
    fileLength = num2str(fileLength);
    fclose(fileID);

    %%Reads in data from spreadsheet at given path
    [balls, text] = xlsread(path, strcat('R2:R',fileLength));
    [strikes, text] = xlsread(path, strcat('S2:S',fileLength));
    [num, pitchType] = xlsread(path, strcat('C2:C',fileLength));
    [num, pitchResult] = xlsread(path, strcat('D2:D',fileLength));
    [zones, text] = xlsread(path, strcat('Q2:Q',fileLength));
    
    %%If additional output argument is supplied, then the number of rows in
    %%file are output
    varargout{1} = fileLength;
    
    else
    strikes = 0; balls = 0; pitchType = 0; pitchResult = 0; zones = 0; varargout{1} = 0;
end
end









    
    
    
                
            
            
        
    
    
    
    
        
    


