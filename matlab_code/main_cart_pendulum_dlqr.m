clc;
clear variables;
close all;

% Get linear model
[modelt,xbar,ubar]  = get_linear_model();

% Controlled output. 
% ycontrol = 1 means that the controlled output is the first output of
% "modelt"
ycontrol           = 1;

% Discrete time model
h                   = 0.01;
modelk              = c2d(modelt,h,'zoh');

% States gain and extended model
r                   = 1;
q                   = diag([1; 1; 1; 1; 5]);
[lstates,add_states]= get_states_gain(modelk,ycontrol,q,r);

% Optimal observer
qobs                = diag([1;1;1;1]);
robs                = 5*eye(2);
kobs                = dlqr(modelk.A',modelk.C',qobs,robs)';
observer            = ss(modelk.A-kobs*modelk.C,[kobs,modelk.B],eye(4),zeros(4,3),h);

% Simulation parameters
setpoint            = 0.5;   
x0                  = [0; deg2rad(60); 0; 0];

% Absolute value of the maximum force
maxforce            = 50;

% Force, angle, and position quantization
[qforce,qangle,qposition] = deal(0.01,0.01,0.01);

% Call to Simulink
compact             = 1;
if compact == 1
    % Controller represented as a transfer function
    control             = get_controller(modelk,ycontrol,add_states,lstates,kobs);
    results             = sim('cart_pendulum_compact',5);    
else    
    % Controller represented by the states feedback gain and the observer
    results             = sim('cart_pendulum',5);
end

% Plot simresults
time                = results.states.time;
pos                 = results.states.signals.values(:,1);
th                  = results.states.signals.values(:,2);
force               = results.force.signals.values; 
plot_simresults(time,pos,th,force);

% Animation
cart_pendulum_animation(pos,th);

% Floating point controller
state_space_to_ccode(control,'controller');
