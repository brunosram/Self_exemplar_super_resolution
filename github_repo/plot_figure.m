I = imread('img_014_SRF_2_HR.png');
im_x = -1400:600;
im_y = -50:700;
%[im_x,im_y] = meshgrid(im_x,im_y);
im = ones(length(im_y),length(im_x));
im( find(im_y==1):find(im_y == 514),find(im_x==1):find(im_x == 514)) ...
= lines_dir{1};
figure
imshow(im)
%axis([xmin xmax ymin ymax]);
%axis([-1400 600 -50 600]);
hold on
plot(find(im_x == int64(VPs(1,1))),find(im_y == int64(VPs(2,1))),'ro')

figure
imshow(I)
hold on 
cpy1 = lines_cpy{3}(2:end-1,2:end-1);
cpy2 = lines_cpy{2}(2:end-1,2:end-1);
cpy3 = lines_cpy{1}(2:end-1,2:end-1);
im_x = 1:512;
im_y = 1:512;
[im_x,im_y] = meshgrid(im_x,im_y);
plot(im_x(logical(cpy1)),im_y(logical(cpy1)),'r.')
plot(im_x(logical(cpy2)),im_y(logical(cpy2)),'b.')
plot(im_x(logical(cpy3)),im_y(logical(cpy3)),'g.')




