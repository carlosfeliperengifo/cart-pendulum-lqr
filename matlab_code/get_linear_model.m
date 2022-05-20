function [MLint,XBar,UBar]  = get_linear_model()
%% Constants
M                   = sym('M','positive');
m                   = sym('m','positive');
J                   = sym('J','positive');
L                   = sym('L','positive');
g                   = sym('g','positive');
a                   = sym('a','positive');

%% States
% x1 = x, x2 = theta, x3 = xdot, x4 = thetadot
x1                  = sym('x1','real');
x2                  = sym('x2','real');
x3                  = sym('x3','real');
x4                  = sym('x4','real');
U                   = sym('U','real');

%% Nonlinear model
Th                  = x2;                                                   
Thdot               = x4;                                                   
% Inertia matrix
D                   = [M+m,-m*a*L*sin(Th);-m*a*L*sin(Th),m*a^2*L^2+J];      
% Coriolis and centrifugal forces
H                   = [-m*a*L*cos(Th)*Thdot^2; 0];
% Gravity force
G                   = [0; +m*a*L*g*cos(Th)];                                
% Inputs
E                   = [U; 0];                                               

%% Linearized model state space model
% x1 = x, x2 = theta, x3 = xdot, x4 = thetadot
Accel               = D\(E-H-G);
XDot                = [x3; x4; Accel];                                      

% Measured output
Ym                  = [x1; x2];

% Jacobians
X                   = [x1; x2; x3; x4];
ASym                = jacobian(XDot,X);
BSym                = jacobian(XDot,U);
CmSym               = jacobian(Ym,X);
DmSym               = jacobian(Ym,U);

%% Equilibrium point
x1bar               = 0.;
x2bar               = pi/2;
x3bar               = 0;
x4bar               = 0;
XBar                = [x1bar; x2bar; x3bar; x4bar];
UBar                = 0;
[x1,x2,x3,x4,U]     = deal(x1bar,x2bar,x3bar,x4bar,UBar);                   %#ok<ASGLU>
[M,m,J,L,a,g]       = deal(1,0.1,0.025,0.5,0.5,9.807);                      %#ok<ASGLU>

%% Numeric model
A                   = eval(ASym);
B                   = eval(BSym);
C                   = eval(CmSym);
D                   = eval(DmSym);
MLint               = ss(A,B,C,D);
end

