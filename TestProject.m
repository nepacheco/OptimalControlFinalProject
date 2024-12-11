
clc;clear;close all;
board = TetrisBoard(20,10);
% display_grid(board.board);
% board.board(end,:) = 1;
% display_grid(board.board);

newObject = true;
total_points = 0;
while ~board.done
    [~,points] = SimulatePlacing(board,[randi(5)-3;randi(9)-5],'Display',true);
    next_state = get_state(board,2)/7;
    total_points = total_points + points;
    fprintf("total points: %d\n",total_points);
end

fprintf("Rows Cleared: %0.0f\n",board.rowsCleared)

%%
clc;clear;close all;
board = TetrisBoard();
% policty iteration
u = @(state) [randi(5)-3;randi(9)-5];
counter = 0;
while (counter < 1)
    % policy evaluation
    tic
    [games,cost] = simulate_games(u,'Display',false);
    J = evaluate_simulation(games,cost,'num_states',201);
    counter = counter + 1;
    toc
    % policty improvement using 1 step dynamic programming
end

%% Q Learning Testing.
board_width = 10;
board_height = 20;
state_version = 6;
beta = 0.005; % Exploration parameter
useI = false;
switch(state_version)
    case 2
        num_states = 201*7;
        % value based on just dropping blocks with 0 input
        Q = zeros(num_states,44);
        for i = 1:504
            Q(i,:) = (18 - floor((i-1)/(28)))*(18-floor((i-1)/(28))+1)/2;
        end
    case 3
        num_states = 201*7*11;
        % value based on just dropping blocks with 0 input
        Q = zeros(num_states,44);
        for i = 1:504*11
            Q(i,:) = (18 - floor((i-1)/(28*11)))*(18-floor((i-1)/(28*11))+1)/2;
        end
    case 4
        num_states = 201*7*11*7;
        % value based on just dropping blocks with 0 input
        Q = zeros(num_states,44);
        for i = 1:504*11*7
            Q(i,:) = (18 - floor((i-1)/(28*11*7)))*(18-floor((i-1)/(28*11*7))+1)/2;
        end
    case 5 
        num_states = (2^(board_width*2))*7;
        Q = zeros(num_states,44);
    case 6 
        num_states = (4^(board_width))*7;
        Q = zeros(num_states,44);
end
%%
% tic
max_minutes = 5;
[Q,u_opt,num_apps] = QLearning(num_states,44,'Time',max_minutes*60,...
    'StateVersion',state_version,'Q',Q,...
    'useI',useI,'Board_Size',[board_height,board_width],'Beta',beta);
toc
% save
%% Test The output of Q learning

% load('Q_full_v3.mat');
% [~,u_opt] = max(Q,[],2);
% state_version = 3;
% useI = false;
% board_width = 10;
% board_height = 20;
total_points = 0;
num_examples = 1;
display_board = true;
for i = 1:num_examples
    board = TetrisBoard(board_height,board_width,useI);
    while ~board.done && (board.total_points < inf)
        state = get_state(board,state_version);
        u_i = u_opt(state+1);
        u_vec = [floor((u_i-1)/(board_width+1)),...
            mod(u_i-1,board_width+1)-floor((board_width+1)/2)];% [rotation;translation]
        [~,points] = SimulatePlacing(board,u_vec,'Display',display_board);
        total_points = total_points + points;
    end
    %     display_grid(board.board,size(board.board));
end
total_points = total_points/num_examples;

fprintf("Average Points: %0.2f\n",total_points);

%% Q Learning With Back Prop

tic
max_minutes = 30;
[Q,u_opt,num_apps] = QLearningBackProp(num_states,44,'Time',max_minutes*60,...
    'StateVersion',state_version,'Q',Q,'MaxPoints',10000,...
    'Board_Size',[board_height,board_width],'Beta',beta);
toc
% save

%% Me being awesome
total_points = 0;
board = TetrisBoard(20,5);
counter = 1;
while ~board.done
    state = get_state(board);
    if state == 4
        u_vec = [1,2];
    else
        u_vec = [0,-1];
    end
    
    counter = counter + 1;
    [~,points] = SimulatePlacing(board,u_vec,'Display',true);
    total_points = total_points + points;
    %     pause(1);
end