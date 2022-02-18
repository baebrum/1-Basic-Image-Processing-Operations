clc;	% Clear command window.
clear;
close all;	% Close all figure windows except those created by imtool.
workspace;	% Make sure the workspace panel is showing.

counter = 1;
one_to_18 = (5:15:200);
six_by_six = zeros(6,6);
for row_idx = 1:2:5
    for col_idx =1:2:5
         six_by_six(row_idx, col_idx) = one_to_18(counter);
         counter = counter + 1;
    end
end



%
rcr_cr = six_by_six;
rcr_cb = six_by_six;
li_cr = six_by_six;
li_cb = six_by_six;

upscaleFactor = 2;
% linear interpolation
% compute odd rows
% tic
% for rows = 1:upscaleFactor:(height(li_cr))
%     for cols = 2:upscaleFactor:width(li_cr)
%         if cols+1>width(li_cr)  % edge case for out of bounds indexing
%             li_cr(rows,cols) = li_cr(rows,cols-1);
%             li_cb(rows,cols) = li_cb(rows,cols-1);
%         else % truncate down for dec answers
%             li_cr(rows,cols) = floor((li_cr(rows,cols-1) + li_cr(rows, cols+1))/upscaleFactor);
%             li_cb(rows,cols) = floor((li_cb(rows,cols-1) + li_cb(rows, cols+1))/upscaleFactor);
%         end
%     end
% end
% 
% % compute even rows
% for rows = 2:upscaleFactor:(height(li_cr))
%     for cols = 1:width(li_cr)
%         if rows+1>height(li_cr)  % edge case for out of bounds indexing
%             li_cr(rows,cols) = li_cr(rows-1,cols);
%             li_cb(rows,cols) = li_cb(rows-1,cols);
%         else % truncate down for dec answers
%             li_cr(rows,cols) = floor((li_cr(rows-1,cols) + li_cr(rows+1, cols))/upscaleFactor);
%             li_cb(rows,cols) = floor((li_cb(rows-1,cols) + li_cb(rows+1, cols))/upscaleFactor);
%         end
%     end
% end
% toc

tic
for cols = 2:upscaleFactor:width(li_cr)-1
    li_cr(:,cols) = floor((li_cr(:,cols-1) + li_cr(:, cols+1))/upscaleFactor);
    li_cb(:,cols) = floor((li_cb(:,cols-1) + li_cb(:, cols+1))/upscaleFactor);
end
li_cr(:,cols+2) = li_cr(:,cols+1);
li_cb(:,cols+2) = li_cb(:,cols+1);

for rows = 2:upscaleFactor:width(li_cr)-1
    li_cr(rows,:) = floor((li_cr(rows-1,:) + li_cr(rows+1, :))/upscaleFactor);
    li_cb(rows,:) = floor((li_cb(rows-1,:) + li_cb(rows+1, :))/upscaleFactor);
end
li_cr(rows+2,:) = li_cr(rows+1,:);
li_cb(rows+2,:) = li_cb(rows+1,:);
toc

matrix_1 = (1:10)';
matrix_2 = (1:2:20)';
diff_matrix =  ((matrix_2-matrix_1)./(abs(matrix_1)))*100;