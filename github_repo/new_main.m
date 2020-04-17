clc
clear all
imgFileName = 'img_014_SRF_2_HR.png';
[VPs,Vlines,lines_cpy] = func_edge_detection(imgFileName);

%% Gaussian Filtering
imgLinesPosMap1 = lines_cpy{1};
HfilterX = fspecial('gaussian', [1,100], 50);
HfilterY = HfilterX';
for k = 1:20
    imgLinesPosMap1 = imfilter(imgLinesPosMap1, HfilterX, 'conv', 'replicate');
end

