function J = evaluate_simulation(games,costs,options)
arguments
    games (:,1) cell
    costs (:,1) cell
    options.num_states (1,1) double = 201
end
J = zeros(options.num_states,1);
num_apps = zeros(options.num_states,1);

for t = 1:size(games,1)
    traj = games{t,1};
    cost_traj = costs{t,1};
    for i = 1:size(traj(1:end-1),2)
        state = traj(i);
        num_apps(state+1,1) = num_apps(state+1,1) + 1;
        J(state+1) = J(state+1) + 1/(num_apps(state+1))* (cost_traj(i) - J(state+1));
    end
end


end