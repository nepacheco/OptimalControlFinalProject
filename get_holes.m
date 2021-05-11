function holes = get_holes(board)
% GET_HOLES returns the number of columns that have holes in them.
arguments
    board (:,:) double
end

holes = 0;
h = size(board,1);
for col = 1:size(board,2)
   v = find(board(:,col));
   num_elems = length(v);
   if ~(sum(v) == (h*(h+1)/2 - (h-num_elems)*(h-num_elems+1)/2))
       holes = holes + 1;
   end
end
end