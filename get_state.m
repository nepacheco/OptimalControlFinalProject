function state = get_state(board,version )
% GET_STATE - returns the state of the board baed on the state version
% passed in.

arguments
    board (1,1) TetrisBoard
    version (1,1) double = 1;
end

board.remove_shape();
board.check_done();
if board.done
    state = -1;
else
    switch version
        case 1
            %   currently using the aggregate height of the board as the sole
            %   representation of state. so the state value can be a number between 0
            %   and 200 giving us 201 states.
            elems = find(board.board);
            state = size(elems,1);
        case 2
            %   currently using the aggregate height of the board and the piece
            %   that is currently falling. This means we have 201 states for
            %   board position and 7 states for shape, so we have 1407 options.
            elems = find(board.board);
            shape = board.shape.id;
            state = size(elems,1)*7+shape;
        case 3
            elems = size(find(board.board),1)*7*(size(board.board,2)+1);
            shape = board.shape.id*size(board.board,2);
            holes = get_holes(board.board);
            state = elems + shape + holes;
        case 4
            elems = size(find(board.board),1)*7*(size(board.board,2)+1)*7;
            shape = board.shape.id*size(board.board,2)*7;
            holes = get_holes(board.board)*7;
            prev_shape =  board.prev_shape.id*size(board.board,2);
            state = elems + shape + holes + prev_shape;
            
        case 5
            [row,~] = find(board.board);
            elems = [];
            if ~isempty(row)
                min_row = min(row);
                if min_row == 20
                    elems = find(board.board(min_row-1:min_row,:));
                else
                    elems = find(board.board(min_row:min_row+1,:));
                end
            end
            state = 0;
            for i = elems'
                state = state + 2^(i-1);
            end
            shape = board.shape.id*size(board.board,2);
            state = state*7 + shape;
        otherwise
            state = 0;
    end
end
board.put_shape();
end