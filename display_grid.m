function p = display_grid(grid,im_ratio)
arguments
    grid (:,:)
    im_ratio = [20,10]; % ratio of height to width
end
max_height = 20*im_ratio(1);
max_width = 20*im_ratio(2);

grid_width = size(grid,2);
grid_height = size(grid,1);
inter_width = max_width/grid_width;
inter_height = max_height/grid_height;

disp_grid = zeros(max_height,max_width);
for col = 1:grid_width
    for row = 1:grid_height
        x_start = (col-1)*inter_width+1;
        x_end = col*inter_width;
        y_start = (row-1)*inter_height+1;
        y_end = row*inter_height;
        disp_grid(y_start:y_end,x_start:x_end) = grid(row,col)*ones(inter_width,inter_height);
    end
end

imshow(disp_grid)
pause(0.015);
end
