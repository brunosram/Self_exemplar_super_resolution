%%%%%%%%%%     Reconstruction    %%%%%%%%
%%%%%%%%%%     Upsampling    %%%%%%%%
up = zeros(2*size(HR1));
sizeup = size(up);
indcodd = 1:2:sizeup(2);%column
%indceven = 2:2:sizeHR1(2);%row
indrodd = 1:2:sizeup(1);%row
%indreven = 
up(indrodd,indcodd) = HR1(:,:);
Fu = fft2(up);
Fu = fftshift(Fu);

H = zeros(sizeup);
H(sizeup(1)/4:sizeup(1)/4 + sizeup(1)/2,sizeup(2)/4:sizeup(2)/4 + sizeup(2)/2) = 4;
G = Fu.*H;
SR = ifft2(G);
SR = abs(SR);
% figure
% imshow(SR,[])
% figure
% imshow(HR1,[])
sizeSR = size(SR);
%SRzero = zeros(size(SR));
%%%%%%%%%%     Copy and Paste  %%%%%%%%%%%%%%
% 
% for i1 = i
%     for j1 = j
%         if f(i1,j1,2)*2 -1 +patchsize -1>sizeHR1(2) ...
%                 || f(i1,j1,1)*2 -1 +patchsize -1>sizeHR1(1)
%             continue
%         end
% %          if f(i1,j1,2)*2  +patchsize -1>sizeHR1(2) ...
% %                 || f(i1,j1,1)*2  +patchsize -1>sizeHR1(1)
% %             continue
% %         end
%         SR(2*i1 -1: 2*i1 -1 + patchsize -1, ...
%             2*j1 -1: 2*j1 -1 + patchsize -1) = ...
%             HR1(f(i1,j1,1)*2 -1:  f(i1,j1,1)*2 -1 +patchsize -1, ... 
%             f(i1,j1,2)*2 -1: f(i1,j1,2)*2 -1 +patchsize -1   );
%         
%         SR(2*i1 : 2*i1  + patchsize -1, ... 
%             2*j1 : 2*j1  + patchsize -1) = ...
%             HR1(f(i1,j1,1)*2 :  f(i1,j1,1)*2  +patchsize -1, ... 
%             f(i1,j1,2)*2 : f(i1,j1,2)*2  +patchsize -1   );
%         
%         SR(2*i1 -1: 2*i1 -1 + patchsize -1, ...
%             2*j1 : 2*j1  + patchsize -1) = ...
%             HR1(f(i1,j1,1)*2 -1:  f(i1,j1,1)*2 -1 +patchsize -1, ... 
%             f(i1,j1,2)*2 : f(i1,j1,2)*2  +patchsize -1   );
%         
%         SR(2*i1 : 2*i1  + patchsize -1, ...
%             2*j1 -1: 2*j1 -1 + patchsize -1) = ...
%             HR1(f(i1,j1,1)*2 :  f(i1,j1,1)*2  +patchsize -1, ... 
%             f(i1,j1,2)*2 -1: f(i1,j1,2)*2 -1 +patchsize -1   );
%         
%     end
% end
figure
imshow(SR, [])

faug = ones(sizeHR1(1),sizeHR1(2),2);
faug(1:sizeHR1(1)-patchsize+1,1:sizeHR1(2)-patchsize+1,:) = f(:,:,:);
% for i5 = sizeHR1(1)-patchsize+2: sizeHR1(1)
%     faug(i5,1:sizeHR1(2)-patchsize+1,:) ... 
%             = f(sizeHR1(1)-patchsize+1,1:sizeHR1(2)-patchsize+1,:);
% end
% for j5 = sizeHR1(2)-patchsize+2: sizeHR1(2)
%         faug(1:sizeHR1(1)-patchsize+1,j5,:) ... 
%             = f(1:sizeHR1(1)-patchsize+1,sizeHR1(2)-patchsize+1,:);
% end
% 
% faug(sizeHR1(1)-patchsize+2: sizeHR1(1),sizeHR1(2)-patchsize+2: sizeHR1(2),1) ... 
%         = f(sizeHR1(1)-patchsize+1,sizeHR1(2)-patchsize+1,1);
% faug(sizeHR1(1)-patchsize+2: sizeHR1(1),sizeHR1(2)-patchsize+2: sizeHR1(2),2) ... 
%         = f(sizeHR1(1)-patchsize+1,sizeHR1(2)-patchsize+1,2);

nphori = sizeSR(2)/(2*patchsize);
npvert = sizeSR(1)/(2*patchsize);
fp = faug*2;
line = zeros(2,patchsize*patchsize);
copied = 0;
for m1 = 1:nphori
    for n1 = 1:npvert
        line(1,:) = reshape(fp(1+(n1-1)*patchsize:n1*patchsize, ... 
            1+(m1-1)*patchsize:m1*patchsize,1),1,[]);
        line(2,:) = reshape(fp(1+(n1-1)*patchsize:n1*patchsize, ... 
            1+(m1-1)*patchsize:m1*patchsize,2),1,[]);
        loss = zeros(1,length(line));
        SRPat = SR(1+(n1-1)*2*patchsize:n1*2*patchsize, ... 
            1+(m1-1)*2*patchsize:m1*2*patchsize);
        SRPat = double(SRPat);
        for i = 1:length(line)
            HRPat = HR(line(1,i)-1:line(1,i)+2*patchsize-2, ... 
                line(2,i)-1:line(2,i)+2*patchsize-2);
            HRPat = double(HRPat);
            loss(i) = sum(sum((SRPat - HRPat).^2));
        end
        
        ind = find(loss == min(loss));
        if length(ind)>1
            ind = ind(1);
        end
        if min(loss) <= 5*10^5
         SR(1+(n1-1)*2*patchsize:n1*2*patchsize, ... 
            1+(m1-1)*2*patchsize:m1*2*patchsize) = ...
            HR(line(1,ind)-1:line(1,ind)+2*patchsize-2, ... 
                line(2,ind)-1:line(2,ind)+2*patchsize-2);
        end
    end
end
figure
imshow(SR,[])




