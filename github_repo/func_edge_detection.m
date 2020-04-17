function [VPs,Vlines,lines_cpy] = func_edge_detection(filename)
I = imread(filename);
I = rgb2gray(I);
%% Edge Detection
% e = edge(I, 'canny');
% figure
% imshow(e,[])
% figure
% mesh(e)
Sobelx = [-1,0,1;-2,0,2;-1,0,1];
Sobely = Sobelx';
masky = [ -1, -1;  1, 1];
maskx = [ -1, 1; -1, 1];
cvy = conv2(Sobelx, I);
cvx = conv2(Sobely, I);
amp = abs(cvx) + abs(cvy);%amplitude
% histogram(amp)
% take 7% to be pixel for lines
arr = reshape(amp,1,[]);
arr_sorted = sort(arr, 'descend');
l_arr = length(arr);
thres = arr_sorted(int64(l_arr*0.2));
indamp = amp<=thres;
amp(indamp) = 0;%filter
% figure
% imshow(amp,[])
% figure
% imshow(cvy,[])
% figure
% imshow(cvx,[])
ang = atan2(cvy,cvx);
ang(indamp) = -pi;
ang = ang + pi;
% figure
% %mesh(ang)
% imshow(ang,[])
 ang = roundn(ang,-1);
 
 %% Unbiased Bucket
 ang1 = ang;
 ang1(ang1 ~= 0) = int64(ang1(ang1 ~= 0)./(pi/4))+1;
 ang1(ang1 == 9) = 1;
 ang1(ang1 >=5) = ang1(ang1 >=5) - 4;

%%%%% threshold %%%%%%%%%%%%%%%%
 thres_len = 15;
 %%%%%%%%%%%%%%%%%%%%%%%%%%%
 for i = 1:  length(unique(ang1))-1
    buff = zeros(size(ang1));
    ind = ang1 == i;
    buff(ind) = 1;
    [bw_inner, m]  = bwlabel(buff, 8);
    
    for j = 1:m
        len = length(bw_inner(bw_inner == j));
        if len <= thres_len
        ang1(bw_inner == j) =0;
        end
    end
 end
 

% histogram(ang1)
%  figure
% imshow(ang1,[])


 %% Biased Bucket
 ang2 = ang;
 ang2(ang2 ~= 0) = int64((ang2(ang2 ~= 0) + pi/8 )./(pi/4));
 %ang1(ang1 == 9) = 1;
 ang2(ang2 >=5) = ang2(ang2 >=5) - 4;
%  unique(ang)
%  length(unique(ang));
 for i = 1:  length(unique(ang2))-1
    buff = zeros(size(ang2));
    ind = ang2 == i;
    buff(ind) = 1;
    [bw_inner, m]  = bwlabel(buff, 8);
    
    for j = 1:m
        len = length(bw_inner(bw_inner == j));
        if len <= thres_len
        ang2(bw_inner == j) =0;
        end
    end
 end
 
%  figure
% imshow(ang2,[])
% figure
% histogram(ang2)

%% Begin of line length 
res = ang1&ang2;
resbuff = res;
res(:,1:2) = 0;
res(:,end-1:end) = 0;
res(1:2,:) = 0;
res(end-1:end,:) = 0;
%%%%%%%%%%%%%%%
res(ang1 == 1 & ang2 == 4) = 0;
%%%%%%%%%%%%%%%

%%%%%%%%%%%%% threshold %%%%%%
thres2 = 15;
%%%%%%%%%%%%%%%%%%%%%%%%%
[bwNew, numLines]  = bwlabel(res);
for i = 1:numLines
    len = length(bwNew(bwNew == i));
        if len <= thres2
        res(bwNew == i) =0;
        end
end

 figure
 imshow(res,[])
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %% Separate to different directions
 ang(~res) = 0;
  ang(ang~=0) = int64(ang(ang~=0)./(pi/4)) + 1;
  ang(ang == 9) = 1;
 ang(ang >=5) = ang(ang >=5) - 4;
 
 h = histogram(ang);
line_direcs = h.Values(2:end);
if find(line_direcs == min(line_direcs)) == 1
    dir1_ind = 2;
    dir2_ind = 3;
    dir3_ind = 4;
end
if find(line_direcs == min(line_direcs)) == 2
    dir1_ind = 1;
    dir2_ind = 3;
    dir3_ind = 4;
end
if find(line_direcs == min(line_direcs)) == 3
    dir1_ind = 1;
    dir2_ind = 2;
    dir3_ind = 4;
end
if find(line_direcs == min(line_direcs)) == 4
    dir1_ind = 1;
    dir2_ind = 2;
    dir3_ind = 3;
end
lines_dir1 = zeros(size(ang1));
lines_dir2 = zeros(size(ang1));
lines_dir3 = zeros(size(ang1));
lines_dir1(ang == dir1_ind) = 1;
lines_dir2(ang == dir2_ind) = 1;
lines_dir3(ang == dir3_ind) = 1;
lines_dir = {};
lines_dir{1} = lines_dir1;
lines_dir{2} = lines_dir2;
lines_dir{3} = lines_dir3;

%lines_dir_copy = lines_dir;
[VPs,Vlines,lines_cpy] = func_find_VP(ang, lines_dir);
%Bwlabel
% [bw, n] = bwlabel(ang, 8);
% figure 
% imshow(bw,[])


% for i = 1:n
%     len = length(bw(bw == i));
%     if len <= thres_len
%         ang(bw == i) =0;
%     end
% end
% % again
% [bw, n] = bwlabel(ang, 8);
% 
% figure 
% imshow(bw,[])

%% Segmentation
% linesNum = 0;
% Lines = [];
% for i = 1:n
%     ind = bw == i;
%     len = length(bw(bw == i));
%     for j = 1:len
%         innerLines = 0;
%         if j ==1
%             linesNum = linesNum + 1;
%             Lines(linesNum) = 
%         end
%         
%     end
% end
end
