function [board, curr_shape] = run_step(board,curr_shape, u)

height = size(board,1);
width = size(board,2);

if norm(curr_shape) > 0

else
    curr_shape = generateShape();
end


end