classdef TetrisBoard < handle
    % TETRISBOARD - class for tetris board that handles inputs as well as
    % the score of the game.
    properties
        
        board (:,:) double
        shape (1,1) Shape = IShape([1,4])
        done = false
        rowsCleared (1,1) double = 0
        total_points (1,1) double = 0
        init_loc (1,2) double = [1,4]
        useI (1,1) logical = false;
        prev_shape (1,1) Shape = EmptyShape([0,0])
    end
    
    methods
        
        function obj = TetrisBoard(height, width,useI)
            % TETRISBOARD - class constructor for width and heigh of tetris
            % board
            arguments
                height (1,1) double = 20
                width (1,1) double = 10;
                useI = false;
            end
            obj.board = zeros(height,width);
            obj.init_loc = [1, floor(width/2)-1];
            obj.useI = useI;
            obj.generate_shape();
            obj.done = false;
            obj.rowsCleared = 0;        
        end
        
        function obj = generate_shape(obj)
            % GENERATE_SHAPE -  Generates a random shape and initializes it
            %   to the top of the board.
            arguments
                obj (1,1) TetrisBoard
            end
            shape_list = {'i','j','l','o','s','t','z'};
            shape_char = shape_list{randi(size(shape_list,2))};
            switch(shape_char)
                case 'i'
                    obj.shape = IShape(obj.init_loc);
                case 'j'
                    obj.shape = JShape(obj.init_loc);
                case 'l'
                    obj.shape = LShape(obj.init_loc);
                case 'o'
                    obj.shape = OShape(obj.init_loc);
                case 's'
                    obj.shape = SShape(obj.init_loc);
                case 't'
                    obj.shape = TShape(obj.init_loc);
                case 'z'
                    obj.shape = ZShape(obj.init_loc);
                otherwise
                    obj.shape = LShape(obj.init_loc);
            end
            if obj.useI
                obj.shape = IShape(obj.init_loc);
            end
            obj.put_shape();
        end
        
        function [newObject, stepPoints, obj] = run_step(obj,u,use_display)
            % RUN_STEP - runs a single step of the tetris game
            %   Running a single step means first responding to user
            %   input (rotation and translation), and then applying gravity
            %   to the object. If gravity can't be applied because of
            %   collision or out of bounds, then the piece remains in its
            %   location and a new piece is generated.
            newObject = false;
            stepRowsCleared = 0;
            stepPoints = 0;
            
            if ~obj.done 
                obj.rotate_shape(u(1));
                obj.move_shape(u(2));
                
                [contact, oob] = obj.use_gravity(true);
                if contact||oob
                    [~,stepPoints] = obj.check_rows();
                    obj.check_done();
                    if ~obj.done
                        obj.prev_shape = obj.shape;
                        obj.generate_shape();
                        newObject = true;
                    end
                else
                    stepPoints = stepPoints + 1;
                end
                if use_display
                    display_grid(obj.board,size(obj.board));
                end
                
                obj.total_points = obj.total_points + stepPoints;
            end
            
        end
        
        function obj = rotate_shape(obj,u)
            % ROTATE_SHAPE - simply rotate the object specified by u
            %   If the object when rotated would collide with another
            %   object, the rotation is canceled
            obj.remove_shape();
            u_range = linspace(0,u,abs(u)+1);
            for i = u_range
                new_shape = obj.shape.rotate(u);
                [collision, out_of_bounds] = obj.check_collision(new_shape);
                if (collision||out_of_bounds)
                    break;
                elseif (~(collision||out_of_bounds))&&(i==u)
                    obj.shape = obj.shape.rotate(u);
                end
            end
            obj.put_shape();
        end
        
        function obj = move_shape(obj,u)
            % MOVE_SHAPE  - simply move the object specified by u
            %   If the object when translated would collide with another
            %   object, the translation is canceled
            obj.remove_shape();
            u_range = linspace(0,u,abs(u)+1);
            for i = u_range
                new_shape = obj.shape.move(i);
                [collision, out_of_bounds] = obj.check_collision(new_shape);
                if (collision||out_of_bounds)
                    break;
                elseif (~(collision||out_of_bounds))&&(i==u)
                    obj.shape = obj.shape.move(u);
                end
            end
            obj.put_shape();
        end
        
        function [collision, out_of_bounds, obj] = use_gravity(obj,move)
            % USE_GRAVITY - performs the gravity step by moving the object
            % down by 1 cell
            obj.remove_shape();
            if move
                new_shape = obj.shape.gravity();
                [collision, out_of_bounds] = obj.check_collision(new_shape);
                if (~(collision||out_of_bounds))
                    obj.shape = obj.shape.gravity();
                    
                end
            else
                [collision, out_of_bounds] = obj.check_collision(obj.shape);
            end
            obj.put_shape();
        end
        
        function [collision,out_of_bounds, obj] = check_collision(obj,new_shape)
            % CHECK_COLLISION - checks to see if the object passed in would
            % colide with any of the existing terrain
            out_of_bounds = obj.check_bounds(new_shape);
            collision = false;
            
            if ~out_of_bounds
                [row_tot,col_tot] = find(new_shape.structure); % Find all the locations that must be empty
                start_row = new_shape.loc(1)-1;
                start_col = new_shape.loc(2)-1;
                for elem = [row_tot';col_tot']
                    %                     elem(2) = elem(2)
                    if(obj.board(elem(1)+start_row,elem(2)+start_col) == 1)
                        collision = true;
                        break
                    end
                end
            end
        end
        
        function [out_of_bounds, obj] = check_bounds(obj,new_shape)
            % CHECK_BOUNDS - checks to see if the object passed in would
            % not be contained within the boards grid.
            out_of_bounds = false;
            
            [row,col] = find(new_shape.structure);
            
            min_row_check = new_shape.loc(1) + min(row)-1;
            max_row_check = new_shape.loc(1) + max(row)-1;
            min_col_check = new_shape.loc(2) + min(col)-1;
            max_col_check = new_shape.loc(2) + max(col)-1;
            
            if (min_row_check < 1 || max_row_check > size(obj.board,1) || ...
                    min_col_check < 1 || max_col_check > size(obj.board,2))
                out_of_bounds = true;
            end
        end
        
        function obj = remove_shape(obj)
            % REMOVE_SHAPE - remove the current shape from the grid to
            % check alternate shape positions
            [row,col] = find(obj.shape.structure);
            start_row = obj.shape.loc(1)-1;
            start_col = obj.shape.loc(2)-1;
            for elem = [row';col']
                obj.board(elem(1)+start_row,elem(2)+start_col) = 0;
            end
        end
        
        function obj = put_shape(obj)
            % PUT_SHAPE - put the shape back in the grid
            [row,col] = find(obj.shape.structure);
            start_row = obj.shape.loc(1)-1;
            start_col = obj.shape.loc(2)-1;
            for elem = [row';col']
                obj.board(elem(1)+start_row,elem(2)+start_col) = 1;
            end
        end
        
        function obj = check_done(obj)
            % CHECK_DONE - check to see if the game should be terminated
            if size(find(obj.board(2,:)),2) >= 1
                obj.done = true;
            end
        end
        
        function [stepRowsCleared,points, obj] = check_rows(obj)
            % CHECK_ROWS - Check to see if the any rows should be cleared
            emptied = [];
            stepRowsCleared = 0;
            for row = size(obj.board,1):-1:1
                if size(find(obj.board(row,:)),2) == size(obj.board,2)
                    obj.board(row,:) = 0;
                    emptied = [row,emptied];
                    stepRowsCleared = stepRowsCleared + 1;
                end
            end
            obj.rowsCleared = obj.rowsCleared + stepRowsCleared;

            for row = emptied
                % this before had 'emptied' instead of 'row' inside the for
                % loop. 
                obj.board(2:row,:) = obj.board(1:row-1,:);
            end
            % How many points do we get
            switch (stepRowsCleared)
                case 1
                    points = 40;
                case 2
                    points = 100;
                case 3
                    points = 300;
                case 4
                    points = 1200;
                otherwise
                    points = 0;
            end
        end
        
        function obj = reset(obj)
            obj.board = zeros(size(obj.board));
            obj.done = false;
            obj.rowsCleared = 0;
            obj.generate_shape();
        end
        
    end
    
end
