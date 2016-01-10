#!/bin/bash
for i in {1..50}
do
    player=$(sed -n "${i}p" Batter_List.txt)
    ./downloadData.sh $player
done
