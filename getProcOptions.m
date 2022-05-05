function [objThresh, strelSize] = getProcOptions (imgSize)

m = imgSize(1);
n = imgSize(2);

if (m*n*10^(-5)) < 100
    objThresh = 1000;
    strelSize = 2;
else
    objThresh = 10000;
    strelSize = 5;
end