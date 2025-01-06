clc;clear;close all;
board_width = 10;
board_height = 20;
state_version = 6;
beta = 0.05; % Exploration parameter
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
% load("QLearningFinal.mat");
%%
tic
max_minutes = 3*24*60;
[Q,u_opt,num_apps] = QLearningBackProp(num_states,44,'Time',max_minutes*60,...
    'StateVersion',state_version,'Q',Q,'MaxPoints',10000,...
    'Board_Size',[board_height,board_width],'Beta',beta,'N',num_apps);
toc
save("QLearningFinal.mat",'-v7.3');