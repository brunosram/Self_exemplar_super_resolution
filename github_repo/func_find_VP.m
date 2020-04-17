function [VPs, Vlines,lines_cpy]  = func_find_VP(ang, lines_dir)
%% Find VP
%Preparation
sizeImg = size(ang);
a = 1: sizeImg(1);%rows, y
b = 1: sizeImg(2);%columns, x
[x,y] = meshgrid(b,a);
Vlines = {};
lines_cpy = {};
  %Begin
  for dirs = 1:3
    [bwNew, numLines]  = bwlabel(lines_dir{dirs});
    lines_dir_copy = lines_dir{dirs};
    test_eigenvalues = [];
    final_lines = 0;
    for i = 1:numLines
        ind = find(bwNew == i);
        meanx = mean(x(ind));
        meany = mean(y(ind));
        X(:,1) = x(ind) - meanx;
        X(:,2) = y(ind) - meany;
        D = X' * X;
        clear X
        [V, Eigen] = eig(D);
        [ eigenvalues, eigen_ind] = sort(diag(Eigen),'descend');
        ratio = eigenvalues(2)/eigenvalues(1);
        %test_eigenvalues(i,:) = [eigenvalues(1),eigenvalues(2),ratio];
        if ratio>= 0.08||length(ind)<=5
            lines_dir_copy(ind) = 0;
            continue
        end
        final_lines = final_lines + 1;
        dir_vec = V(:,eigen_ind(1));
        theta = atan2(dir_vec(2),dir_vec(1));
        if theta == pi/2
            Vlines{dirs}(final_lines,: ) = [1,0,-meanx];
        else
            k = dir_vec(2)/dir_vec(1);
            Vlines{dirs}(final_lines,: ) = [k/(-k*meanx+meany), 1/(k*meanx-meany),1];
        end
        
        %Vlines{dirs}(final_lines,: ) = [meanx,meany,theta,eigenvalues(1),eigenvalues(2),ratio,i];

    end
%     if dirs == 2
%              imshow(lines_dir_copy,[])
%     end
    lines_cpy{dirs} = lines_dir_copy;  
  end
 VPs = [];
  for dirs = 1:3
      len_in_dir = size(Vlines{dirs},1);
      iters = 0;
      VP = [];
      for i = 1:len_in_dir - 1
          for j = i+1:len_in_dir
              iters = iters + 1;
              vp = cross(Vlines{dirs}(i,:), Vlines{dirs}(j,:));
              normed_vp = vp;
              normed_vp(1) = vp(1)/sqrt( vp(1)^2 + vp(2)^2 + vp(3)^2 );
              normed_vp(2) = vp(2)/sqrt( vp(1)^2 + vp(2)^2 + vp(3)^2 );
              normed_vp(3) = vp(3)/sqrt( vp(1)^2 + vp(2)^2 + vp(3)^2 );
              VP(:,iters) = normed_vp;
%               if vp(3) == 0
%                 VP(:,iters) = vp;
%               else
%                 vp(1) = vp(1)/vp(3);
%                 vp(2) = vp(2)/vp(3);
%                 vp(3) = 1;
%              	VP(:,iters) = vp;
%               end
          end
      end
      
      prod = Vlines{dirs} * VP;
      loss = sum(abs(prod));
      min_VP_ind = find(loss == min(loss));
      final_VP = VP(:,min_VP_ind);
      final_VP(1) = final_VP(1)/final_VP(3);
      final_VP(2) = final_VP(2)/final_VP(3);
      final_VP(3) = 1;
      VPs(:,dirs) = final_VP;
  end
  
  
end
