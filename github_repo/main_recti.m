clc
clear all
imgFileName = 'img_014_SRF_2_HR.png';
I = imread(imgFileName);
%[VPs,Vlines,lines_cpy] = func_edge_detection(imgFileName);
load('vpfile')

patch = I(300:400,340:440,:);
figure
imshow(patch)

patchg = rgb2gray(patch);

vp1 = VPs(:,1);
vp2 = VPs(:,2);
vp3 = VPs(:,3);
vanish_line12 = cross(vp1,vp2);
vanish_line13 = cross(vp1,vp3);
vanish_line23 = cross(vp2,vp3);

H12 = [1 0 0; 0 1 0; vanish_line12(1)/vanish_line12(3) vanish_line12( 2)/vanish_line12(3) 1];
H13 = [1 0 0; 0 1 0; vanish_line13(1)/vanish_line13(3) vanish_line13( 2)/vanish_line13(3) 1];
H23 = [1 0 0; 0 1 0; vanish_line23(1)/vanish_line23(3) vanish_line23( 2)/vanish_line23(3) 1];

sizeinput = size(patchg);
len = sizeinput(1)*sizeinput(2);
col =1:sizeinput(2);
row = 1:sizeinput(1);
[x, y] = meshgrid(col,row);
mat = ones(3, len);
mat(1,:) = reshape(x,1,len);
mat(2,:) = reshape(y,1,len);
matp = H * mat;
% matp(3,matp(3,:)<=2*10^-7) = 1;
matp(1,:) = matp(1,:)./matp(3,:);
matp(2,:) = matp(2,:)./matp(3,:);
matp(3,:) = 1;