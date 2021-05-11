function [Q,u_opt,num_apps] = QLearningBackProp(num_states,num_inputs,options)
% QLEARNINGBACKPROP Run the Q learning step, but use the TD(1) in order to
% edit the value of the state-input pair instead of relying on the Q value 
% of the next state.

arguments
    num_states (1,1) double = 201
    num_inputs (1,1) double = 44
    options.display = false
    options.Simulations = inf;
    options.Time = inf;
    options.StateVersion (1,1) double = 1;
    options.Q = zeros(num_states,num_inputs);
    options.N = zeros(num_states,num_inputs);
    options.Board_Size = [20,10]
    options.MaxPoints = 5000;
    options.Beta = 0.0;
end

if (options.Simulations == inf) && (options.Time == inf)
    options.Simulations = 100;
end
num_trans = (options.Board_Size(2)+1);
num_inputs = 4*num_trans;
Q = options.Q;
num_apps = options.N;

t = 0;
fprintf("Q Learning Started At %s\n",datetime);
fprintf("Running for %d simulations or %0.2f minutes\n",options.Simulations,options.Time/60);
fprintf("Simulation will finish at %s\n",datetime + options.Time/(24*60*60))
tic
while (t < options.Simulations) && (toc < options.Time)

    board = TetrisBoard(options.Board_Size(1),options.Board_Size(2));
    state = get_state(board,options.StateVersion);
    traj = [];
    while ~board.done && (toc < options.Time) && (board.total_points < options.MaxPoints)
        i = state+1;
        
        % Determine the input to the system
%         beta = options.Beta;
        beta = ((options.Time - toc)/5)^2/(options.Time)^2;
        if rand() < beta % Exploration
            u_i = randi(num_inputs);
        else % Use what we know
            [~,u_i] = max(Q(i,:)); % Get the index of highest cost [1...44]
        end
        traj = [traj, [i;u_i]];
        % have to subtract one off of u to put in range [0..43]
        u_vec = [floor((u_i-1)/num_trans),...
            mod(u_i-1,num_trans)-floor(num_trans/2)]; % [rotation;translation]

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Apply u
        [~,points] = SimulatePlacing(board,u_vec);
        next_state = get_state(board,options.StateVersion);
        j = next_state + 1;

        % Update Q Steps
        num_apps(i,u_i) = num_apps(i,u_i) + 1; 
        % Number of times the pair , u have appeared
        % This is where we have the back propogation
        for state_input = traj(:,1:end)
            i_0 = state_input(1);
            u_i_0 = state_input(2);
            % Learning Rate - must decay to 0 
            gamma = 1/num_apps(i_0,u_i_0);
            % Update Q using simulation based Bellman equation
            if j ~= 0
                Q(i_0,u_i_0) = Q(i_0,u_i_0) + gamma*(points + max(Q(j,:)) - Q(i,u_i));
            else
                Q(i_0,u_i_0) = Q(i_0,u_i_0) + gamma*(points - Q(i,u_i));
            end
        end

        % Update Trajectory
        if options.display
            display_grid(board.board);
        end
        state = next_state;
    end
    t = t + 1;
end
if (toc < options.Time)
    fprintf("Ended with %d simulations and it took %0.3f seconds\n",options.Simulations,toc);
else
    fprintf("Ended in %0.3f seconds and it ran %d simulations\n",toc,t);
end
[~,u_opt] = max(Q, [], 2);

end