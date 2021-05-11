function [Q,num_apps] = UpdateQ(Q,num_apps,num_inputs,num_states,options)
arguments
    Q (:,:) double
    num_apps (:,:) double
    num_inputs = 44
    num_states = 201
    options.StateVersion = 2;
    options.display = false;
end

board = TetrisBoard();
state = get_state(board,options.StateVersion);

while ~board.done
    beta = num_inputs/(sum(num_apps(state + 1,:))+1);
    if rand() < beta % Exploration
        u = randi(44);
    else % Use what we know
        [~,u] = max(Q(state+1,:)); % Get the index of highest cost [1...44]
    end
    u = u - 1; % keep u between 0 and 43
    u_vec = [floor(u/11),mod(u,4)]; % [rotation;translation]
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Apply u
    [~,points] = SimulatePlacing(board,u_vec);
    next_state = get_state(board,options.StateVersion);
    
    % Update Q
    num_apps(state+1,u+1) = num_apps(state+1,u+1) + 1;
    gamma = 1/num_apps(state + 1,u+1);
    [~,u_j] = max(Q(next_state+1,:));
    Q(state+1,u+1) = (1-gamma)*Q(state+1,u+1) + gamma*(points + Q(next_state+1,u_j));
    
    % Update Trajectory
    if options.display
        display_grid(board.board);
    end
    state = next_state;
end

end
