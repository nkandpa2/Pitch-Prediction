function M = makeMarkovMatrix(frequencyMatrix)

totals = sum(frequencyMatrix);

for r = 1:8
    for c = 1:9
        M(r,c) = frequencyMatrix(r,c)/totals(c);
    end
end
end
