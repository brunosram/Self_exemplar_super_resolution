clc
clear all
imgFileName = 'img_014_SRF_2_HR.png';
I = imread(imgFileName);
[VPs,Vlines,lines_cpy] = func_edge_detection(imgFileName);

imgLinesPosMap1 = lines_cpy{1}(2:end-1,2:end-1);
imgLinesPosMap2 = lines_cpy{2}(2:end-1,2:end-1);
imgLinesPosMap3 = lines_cpy{3}(2:end-1,2:end-1);
HfilterX = fspecial('gaussian', [1,100], 50);
HfilterY = HfilterX';
for k = 1:10
    imgLinesPosMap1 = imfilter(imgLinesPosMap1, HfilterX, 'conv', 'replicate');
    imgLinesPosMap2 = imfilter(imgLinesPosMap2, HfilterX, 'conv', 'replicate');
    imgLinesPosMap3 = imfilter(imgLinesPosMap3, HfilterX, 'conv', 'replicate');
end
for k = 1:10
    imgLinesPosMap1 = imfilter(imgLinesPosMap1, HfilterY, 'conv', 'replicate');
    imgLinesPosMap2 = imfilter(imgLinesPosMap2, HfilterY, 'conv', 'replicate');
    imgLinesPosMap3 = imfilter(imgLinesPosMap3, HfilterY, 'conv', 'replicate');
end
%imshow(imgLinesPosMap1,[])
plane_prob12 = imgLinesPosMap1.*imgLinesPosMap2;
plane_prob13 = imgLinesPosMap1.*imgLinesPosMap3;
plane_prob23 = imgLinesPosMap2.*imgLinesPosMap3;
% figure
% imshow(imgLinesPosMap1,[])
% figure
% imshow(imgLinesPosMap2,[])
% figure
% imshow(imgLinesPosMap3,[])
% figure
% imshow(plane_prob12 ,[])
% figure
% imshow(plane_prob13 ,[])
% figure
% imshow(plane_prob23 ,[])
extracted_plane1 = I;
for c = 1:3
    extr_buff = extracted_plane1(:,:,c);
    extr_buff(plane_prob12<=0.00015) = 0;
    extracted_plane1(:,:,c) = extr_buff;
end
figure
imshow(extracted_plane1)

extracted_plane2 = I;
for c = 1:3
    extr_buff = extracted_plane2(:,:,c);
    extr_buff(plane_prob13<=0.00015) = 0;
    extracted_plane2(:,:,c) = extr_buff;
end
figure
imshow(extracted_plane2)

extracted_plane3 = I;
for c = 1:3
    extr_buff = extracted_plane3(:,:,c);
    extr_buff(plane_prob23<=0.0005) = 0;
    extracted_plane3(:,:,c) = extr_buff;
end
figure
imshow(extracted_plane3)