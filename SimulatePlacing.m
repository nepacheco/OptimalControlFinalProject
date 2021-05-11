function [newObject,points] = SimulatePlacing(board,u,options)
arguments
    board (1,1) TetrisBoard
    u (2,1) double
    options.Display (1,1) logical = false;
end

points = 0;
[newObject,stepPoints] = board.run_step(u,false);
points = points + stepPoints;

while (~newObject && ~board.done)
    [newObject,stepPoints] = board.run_step([0,0],options.Display);
    points = points + stepPoints;
end
end