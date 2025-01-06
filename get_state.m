function state = get_state(board,version )
% GET_STATE - returns the state of the board baed on the state version
% passed in.

arguments
    board (1,1) TetrisBoard
    version (1,1) double = 1;
end

board.remove_shape();
% board.check_done();
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
            % the state is given by looking at the top two rows of the
            % board and treating those rows as a binary number. 1 if they
            % have an object and 0 otherwise. We then can also have 7
            % shapes so there are a total of 2^(2*cols)*7 total
            % possible states
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
            state = 1;
            for i = elems'
                state = state + 2^(i-1);
            end
            shape = board.shape.id*size(board.board,2) + 1; 
            state = state*7 + shape;% shape ID goes from 0 - 6 so we add 1 to not multiply by 0
        case 6
            % For this state we look at the highest three rows and then
            % add the peak height in each column. Each column can have a
            % value between 0-3. 
            % This gives a total of 4^(numCol)*7 total states because of
            % the 7 pieces. Same number of states as case 5, but with
            % potentially slightly richer information.
            [row,~] = find(board.board);
            elems = [];
            smallBoard = zeros(4,size(board.board,2));
            if ~isempty(row)
                min_row = min(row);
                if ((size(board.board,1)-2) < min_row) % minimum row is within 4 from bottom
                    smallBoard = board.board((size(board.board,1)-2):size(board.board,1),:); % Take bottom four rows of the board
                else % min row is a value between 0 and 16
                    smallBoard = board.board(min_row:min_row+2,:);
                end
            end
            % just so that find will return 3 for the row if the column is filled
            smallBoard = flip(smallBoard,1);
            shape = board.shape.id*4^10;
            state = 0;
            for i = 1:size(board.board,2)
                % elems will either be empty (0) or a value between 1-3
                elems = find(smallBoard(:,i),1,'last'); 
                if ~isempty(elems)
                    state = state + (elems*4^(i-1));
                end
            end
            state = state+shape;
        otherwise
            state = 0;
    end
end
board.put_shape();
end