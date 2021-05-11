function [all_games, all_costs] = simulate_games(u,options)
arguments
    u function_handle
    options.display (1,1) logical = false
    options.sims = 100;
end

all_games = cell(options.sims,1);
all_costs = cell(options.sims,1);
for t = 1:options.sims
    board = TetrisBoard();
    newObject = true;
    
    state = get_state(board);
    state_trajectory = state;
  
    cost_vec = [];
    while ~board.done
        [~,points] = SimulatePlacing(board,u(state));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        next_state = get_state(board);
        state_trajectory = [state_trajectory, next_state];
        cost_vec = [cost_vec, -points];
        if options.display
            display_grid(board.board);
        end
        state = next_state;
    end
    all_games{t,1} = state_trajectory;
    all_costs{t,1} = cost_vec;
end

end