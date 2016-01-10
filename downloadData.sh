#!/bin/bash
firstName="$1";
lastName="$2";
fullName="$firstName,$lastName";
line=$(grep "$fullName" ./PLAYERIDMAP.csv);
playerID=$(echo $line | awk -F',' '{print $11}');

echo "Line is $line"
echo "PlayerID is $playerID"

for i in {0..5}
do
    year="201$i";
    initial=${firstName:0:1};
    batterName="${initial}_${lastName}";
    echo "Initial is $initial"
    
    curl -m 5 -o "C:/Users/Nikhil/Pitch_Prediction/Batter_Data/$batterName/$year.csv" "http://baseballsavant.com/csv.php?hfPT=&hfZ=&hfGT=R%7C&hfPR=&hfAB=&ddlStadium=&hfBB=&hfHL=&pid%5B%5D=$playerID&hfCount=&ddlYear=$year&ddlPlayer=batter&ddlMin=0&ddlPitcherHand=&ddlBatterHand=&ddlVGT=&ddlVLT=&ddlBBVGT=&ddlBBVLT=&ddlDistGT=&ddlDistLT=&txtAngleGT=&txtAngleLT=&txtGameDateGT=&txtGameDateLT=&ddlTeam=&ddlPosition=&hfRO=&ddlHomeRoad=&hfIN=&hfOT=&ddlGroupBy=name&ddlSort=desc&ddlMinABs=0&ddlSBSuccess=&txtPx1=&txtPx2=&txtPz1=&txtPz2=&ddlRPXGT_ft=&ddlRPXGT_in=&ddlRPXLT_ft=&ddlRPXLT_in=&ddlRPYGT_ft=&ddlRPYGT_in=&ddlRPYLT_ft=&ddlRPYLT_in=&txtBAGT=&txtBALT=&txtBLGT=&txtBLLT=&txtSRGT=&txtSRLT=&txtSDGT=&txtSDLT=&ddlPlayerHeightGT=&ddlPlayerHeightLT=&ddlPlayerWeightGT=&ddlPlayerWeightLT=&player_id=$playerID" -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: en-US,en;q=0.8' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H "Referer: http://baseballsavant.com/pitchfx_search.php?hfPT=&hfZ=&hfGT=R%7C&hfPR=&hfAB=&ddlStadium=&hfBB=&hfHL=&pid%5B%5D=$playerID&hfCount=&ddlYear=$year&ddlPlayer=batter&ddlMin=0&ddlPitcherHand=&ddlBatterHand=&ddlVGT=&ddlVLT=&ddlBBVGT=&ddlBBVLT=&ddlDistGT=&ddlDistLT=&txtAngleGT=&txtAngleLT=&txtGameDateGT=&txtGameDateLT=&ddlTeam=&ddlPosition=&hfRO=&ddlHomeRoad=&hfIN=&hfOT=&ddlGroupBy=name&ddlSort=desc&ddlMinABs=0&ddlSBSuccess=&txtPx1=&txtPx2=&txtPz1=&txtPz2=&ddlRPXGT_ft=&ddlRPXGT_in=&ddlRPXLT_ft=&ddlRPXLT_in=&ddlRPYGT_ft=&ddlRPYGT_in=&ddlRPYLT_ft=&ddlRPYLT_in=&txtBAGT=&txtBALT=&txtBLGT=&txtBLLT=&txtSRGT=&txtSRLT=&txtSDGT=&txtSDLT=&ddlPlayerHeightGT=&ddlPlayerHeightLT=&ddlPlayerWeightGT=&ddlPlayerWeightLT=" -H 'Cookie: _ga=GA1.2.446440501.1451269438' -H 'Connection: keep-alive' --compressed
done

