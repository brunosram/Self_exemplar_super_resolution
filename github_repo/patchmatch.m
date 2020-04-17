clc
clear all
tic
HR = imread('HR.png');
LR = imread('LR.png');
patchsize =8;

HR = rgb2ycbcr(HR);
LR = rgb2ycbcr(LR);
HR1 = HR(:,:,1);
LR1 = LR(:,:,1);

sizeHR1 = size(HR1);
sizeLR1 = size(LR1);
% %%%%%%%%%            Initialization        %%%%%%%%%%
f =zeros(sizeHR1(1) - patchsize + 1, sizeHR1(2) - patchsize + 1,2);
i = 1:sizeHR1(1) - patchsize + 1;
j = 1:sizeHR1(2) - patchsize + 1;
[one, two] = meshgrid(floor(j./2)+1,floor(i./2)+1);
f(:,:,1) = two;
f(:,:,2) = one;
%%%%%%%%            Iteration        %%%%%%%%%%
 for iter = 1:1
%%%%%%%%            Propagation        %%%%%%%%%%
%if mod(iter,2) == 1
for i1 = i
    for j1 = j
%         if i1 ==1 && j1 >= 497
%              b = 1;
%         end
        if j1 == 1 && i1 == 1
            continue
        end
        if j1 == 1&&i1~=1
            if f(i1,j1,1) + patchsize -1 > sizeLR1(1)&& ...
                        f(i1,j1,2) + patchsize -1 <= sizeLR1(2)
                        f(i1,j1,:) = f(i1-1,j1,:);
                        continue
            end
            SrcPat = HR1(i1: i1 + patchsize -1,j1: j1 + patchsize -1);
            TarPat = LR1(f(i1,j1,1): f(i1,j1,1) + patchsize -1, ...
                                    f(i1,j1,2): f(i1,j1,2) + patchsize -1);
            SrcPat = double(SrcPat);
            TarPat = double( TarPat);
            RPat = double(HR1(i1-1: i1 + patchsize -2, j1: j1 + patchsize -1));
            Rloss = sum(sum((RPat - TarPat).^2));
            if Rloss < Sloss
                f(i1,j1,:) = f(i1-1,j1,:);
            end
            continue           
        end
        
        if(i1==1&&j1~=1)%exceed boundary
            if f(i1,j1,2) + patchsize -1 > sizeLR1(2)&& ...
                        f(i1,j1,1) + patchsize -1 <= sizeLR1(1)
                        f(i1,j1,:) = f(i1,j1-1,:);
                        continue
            end
            SrcPat = HR1(i1: i1 + patchsize -1,j1: j1 + patchsize -1);
            TarPat = LR1(f(i1,j1,1): f(i1,j1,1) + patchsize -1, ...
                                    f(i1,j1,2): f(i1,j1,2) + patchsize -1);
            SrcPat = double(SrcPat);
            TarPat = double( TarPat);
            LPat = double(HR1(i1: i1 + patchsize -1,j1-1: j1 + patchsize -2));
            Sloss = sum(sum((SrcPat - TarPat).^2));
            Lloss = sum(sum((LPat - TarPat).^2));
            if Lloss < Sloss
                f(i1,j1,:) = f(i1,j1-1,:);
            end
            continue
        end
            
            SrcPat = HR1(i1: i1 + patchsize -1,j1: j1 + patchsize -1);
            if f(i1,j1,1) + patchsize -1 > sizeLR1(1)&& ...
                f(i1,j1,2) + patchsize -1 > sizeLR1(2)
                    f(i1,j1,:) = f(i1-1,j1-1,:);
%                     TarPat = zeros(patchsize);
%                     TarPat(1:sizeLR1(1) - f(i1,j1,1) + 1, 1:sizeLR1(2) - f(i1,j1,2) + 1) ...
%                     = LR1(f(i1,j1,1): end, f(i1,j1,2): end);
                
            else if f(i1,j1,2) + patchsize -1 > sizeLR1(2)&& ...
                        f(i1,j1,1) + patchsize -1 <= sizeLR1(1)
                    
                        f(i1,j1,:) = f(i1,j1-1,:);
                        continue
%                         TarPat = zeros(patchsize);
%                         TarPat(:,1:sizeLR1(2) - f(i1,j1,2)+1) = ...
%                         LR1(f(i1,j1,1): f(i1,j1,1) + patchsize -1, f(i1,j1,2): end);
                    
                
            else if f(i1,j1,1) + patchsize -1 > sizeLR1(1)&& ...
                        f(i1,j1,2) + patchsize -1 <= sizeLR1(2)
                        f(i1,j1,:) = f(i1-1,j1,:);
                        continue
%                         TarPat = zeros(patchsize);
%                         TarPat(1:sizeLR1(1) - f(i1,j1,1) + 1,:) = ...
%                         LR1(f(i1,j1,1): end, f(i1,j1,2): f(i1,j1, 2) + patchsize -1);

            else
             TarPat = LR1(f(i1,j1,1): f(i1,j1,1) + patchsize -1, ...
                                    f(i1,j1,2): f(i1,j1,2) + patchsize -1);
                end
             end
            end
            SrcPat = double(SrcPat);
            TarPat = double( TarPat);
            LPat = double(HR1(i1: i1 + patchsize -1,j1-1: j1 + patchsize -2));
            RPat = double(HR1(i1-1: i1 + patchsize -2, j1: j1 + patchsize -1));
            Sloss = sum(sum((SrcPat - TarPat).^2));
            Lloss = sum(sum((LPat - TarPat).^2));
            Rloss = sum(sum((RPat - TarPat).^2));
            m = [Sloss, Lloss, Rloss];
            
            if(max(m) == Sloss)%%update f(x,y)
                
            else if(max(m) == Lloss)
                    f(i1,j1,:) = f(i1,j1-1,:);
                    else if(max(m) == Rloss)
                            f(i1,j1,:) = f(i1-1,j1,:);
                            end
                   end
            end
        
        end
    end

% sizeLR1(1)
% sizeLR1(2)
% else
% for i1 = fliplr(i)
%     for j1 = fliplr(j)
%          if i1 == sizeHR1(1)-patchsize +1&& j1 == sizeHR1(2)-patchsize +1
%              continue
%          end
%          
%         if i1 == sizeHR1(1)-patchsize +1&& j1 ~= sizeHR1(2)-patchsize +1
%            if f(i1,j1,2) + patchsize -1 > sizeLR1(2)&& ...
%                         f(i1,j1,1) + patchsize -1 <= sizeLR1(1)
%                         f(i1,j1,:) = f(i1,j1+1,:);
%                         continue
%             end
%             SrcPat = HR1(i1: i1 + patchsize -1,j1: j1 + patchsize -1);
%             TarPat = LR1(f(i1,j1,1): f(i1,j1,1) + patchsize -1, ...
%                                     f(i1,j1,2): f(i1,j1,2) + patchsize -1);
%             SrcPat = double(SrcPat);
%             TarPat = double( TarPat);
%             LPat = double(HR1(i1: i1 + patchsize -1,j1+1: j1 + patchsize ));
%             Sloss = sum(sum((SrcPat - TarPat).^2));
%             Lloss = sum(sum((LPat - TarPat).^2));
%             if Lloss < Sloss
%                 f(i1,j1,:) = f(i1,j1+1,:);
%             end
%             continue
%         end
%         
%         
%         if j1 == sizeHR1(2)-patchsize +1&& i1~=sizeHR1(1)-patchsize +1
%            if f(i1,j1,1) + patchsize -1 > sizeLR1(1)&& ...
%                         f(i1,j1,2) + patchsize -1 <= sizeLR1(2)
%                         f(i1,j1,:) = f(i1+1,j1,:);
%                         continue
%             end
%             SrcPat = HR1(i1: i1 + patchsize -1,j1: j1 + patchsize -1);
%             TarPat = LR1(f(i1,j1,1): f(i1,j1,1) + patchsize -1, ...
%                                     f(i1,j1,2): f(i1,j1,2) + patchsize -1);
%             SrcPat = double(SrcPat);
%             TarPat = double( TarPat);
%             RPat = double(HR1(i1+1: i1 + patchsize , j1: j1 + patchsize -1));
%             Rloss = sum(sum((RPat - TarPat).^2));
%             if Rloss < Sloss
%                 f(i1,j1,:) = f(i1+1,j1,:);
%             end
%             continue           
%         end
%         
%         
% %         if(f(i1,j1,1)>sizeLR1(1)-patchsize +1|| f(i1,j1,2)>sizeLR1(2)-patchsize +1)%exceed boundary
% %             continue;
% %         else
%             
%             SrcPat = HR1(i1: i1 + patchsize -1,j1: j1 + patchsize -1);
%             if f(i1,j1,1) + patchsize -1 > sizeLR1(1)&& ...
%                 f(i1,j1,2) + patchsize -1 > sizeLR1(2)
%                         
%                         f(i1,j1,:) = f(i1+1,j1+1,:);
%                         continue
% %                     TarPat = zeros(patchsize);
% %                     TarPat(1:sizeLR1(1) - f(i1,j1,1) + 1, 1:sizeLR1(2) - f(i1,j1,2) + 1) ...
% %                     = LR1(f(i1,j1,1): end, f(i1,j1,2): end);
%                     
%             else if f(i1,j1,2) + patchsize -1 > sizeLR1(2)&& ...
%                         f(i1,j1,1) + patchsize -1 <= sizeLR1(1)
%                         f(i1,j1,:) = f(i1,j1+1,:);
%                         continue
% %                         TarPat = zeros(patchsize);
% %                         TarPat(:,1:sizeLR1(2) - f(i1,j1,2)+1) = ...
% %                         LR1(f(i1,j1,1): f(i1,j1,1) + patchsize -1, f(i1,j1,2): end);
%                     
%                 
%             else if f(i1,j1,1) + patchsize -1 > sizeLR1(1)&& ...
%                         f(i1,j1,2) + patchsize -1 <= sizeLR1(2)
%                         
%                         f(i1,j1,:) = f(i1+1,j1,:);
%                         continue
% %                         TarPat = zeros(patchsize);
% %                         TarPat(1:sizeLR1(1) - f(i1,j1,1) + 1,:) = ...
% %                         LR1(f(i1,j1,1): end, f(i1,j1,2): f(i1,j1, 2) + patchsize -1);
% 
%             else
%              TarPat = LR1(f(i1,j1,1): f(i1,j1,1) + patchsize -1, ...
%                                     f(i1,j1,2): f(i1,j1,2) + patchsize -1);
%                 end
%              end
%             end
%             SrcPat = double(SrcPat);
%             TarPat = double( TarPat);
%             LPat = double(HR1(i1: i1 + patchsize -1,j1+1: j1 + patchsize ));
%             RPat = double(HR1(i1+1: i1 + patchsize ,j1: j1 + patchsize -1));
%             Sloss = sum(sum((SrcPat - TarPat).^2));
%             Lloss = sum(sum((LPat - TarPat).^2));
%             Rloss = sum(sum((RPat - TarPat).^2));
%             m = [Sloss, Lloss, Rloss];
%             
%             if(max(m) == Sloss)%%update f(x,y)
%                 
%             else if(max(m) == Lloss)
%                     f(i1,j1,:) = f(i1,j1+1,:);
%                     else if(max(m) == Rloss)
%                             f(i1,j1,:) = f(i1+1,j1,:);
%                             end
%                    end
%             end
%         
%         end
%     end
% end

%%%%%%%%%            Search        %%%%%%%%%%
w = 0.5*max(sizeLR1(1),sizeLR1(2));

for i1 = i
    for j1 = j

        alpha = 0.5;
        while floor(w*alpha)>1
        %R = [rand*2-1,rand*2-1];
        startcol = floor(max(f(i1,j1,2) - w * alpha, 1));
        startrow = floor(max(f(i1,j1,1) - w * alpha, 1));
        endrow = floor(min(sizeLR1(1) - patchsize +1, f(i1,j1,1)+w * alpha -1 ));
        endcol = floor(min(sizeLR1(2) - patchsize +1, f(i1,j1,2)+w * alpha -1 ));
        if endrow<=startrow||endcol<=startcol
            alpha = alpha * 0.5;
            continue
        end
        
        row = startrow + floor(rand*(endrow - startrow));
        col = startcol + floor(rand * (endcol - startcol));
        SchPat = LR1(row + patchsize -1, col + patchsize -1);
        SrcPat = HR1(i1: i1 + patchsize -1,j1: j1 + patchsize -1);
        OrigPat = LR1(f(i1,j1,1): f(i1,j1,1) + patchsize -1, ...
                                     f(i1,j1,2): f(i1,j1,2) + patchsize -1);
            if sum(sum((SrcPat - OrigPat).^2))>sum(sum((SrcPat - SchPat).^2))
                f(i1,j1,1) = row;
                f(i1,j1,2) = col;
            end
        alpha = alpha * 0.5;
        
        end
    end
end
end

toc

