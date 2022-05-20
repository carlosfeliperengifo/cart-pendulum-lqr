function cart_pendulum_animation(X,Q)
% Parameters of the cart
CartWidth                       = +0.30;
CartHeight                      = +0.20;
WheelRadius                     = +0.05;
WheelPos                        = +0.15;
PendLength                      = +1.00;
PendWidth                       = +0.02;
FreeSpace                       = +4.00;

%% 
figure;
hold on;
axis equal;

%% Rectangle representing the ground
XGround                         = (0.2 + FreeSpace/2)*[+1; +1; -1; -1];
YGround                         = 0.05*[-1;  0;  0; -1];
fill(XGround,YGround,'k');

%% Rectangle representing the left wall
XLeftWall                       = -FreeSpace/2 + [0; 0; -0.05; -0.05];
YLeftWall                       = [0; 1.5; 1.5; 0];
fill(XLeftWall,YLeftWall,'r');

%% Rectangle representing the right wall
XRightWall                       = FreeSpace/2 + [0; 0; 0.05; 0.05];
YRightWall                       = [0; 1.5; 1.5; 0];
fill(XRightWall,YRightWall,'r');

%% Variables to draw circles
Point                           = linspace(0,2*pi,10);
SinPoint                        = sin(Point);
CosPoint                        = cos(Point);

% Back wheel
XWheel1                         = WheelRadius * SinPoint - WheelPos;
YWheel1                         = WheelRadius * CosPoint + WheelRadius;

% Front wheel
XWheel2                         = WheelRadius * SinPoint + WheelPos;
YWheel2                         = WheelRadius * CosPoint + WheelRadius;

% Rectangle representing the cart
XCart                           = CartWidth  * [+1; +1; -1; -1];
YCart                           = CartHeight * [ 0; +1; +1;  0] + WheelRadius;

% Rectangle representing the pendulum
XPend                           = PendLength * [+0.95; +0.95; -0.05; -0.05];
YPend                           = PendWidth  * [-1.00; +1.00; +1.00; -1.00];

% Rotation matrix
Rot                             = @(Angle) [cos(Angle), -sin(Angle); sin(Angle), cos(Angle)];

%% First draw
% Cart
HCart                           = fill(XCart   + X(1),YCart,'b');
% Back wheel
HWheel1                         = fill(XWheel1 + X(1),YWheel1,'r');
% Front wheel
HWheel2                         = fill(XWheel2 + X(1),YWheel2,'r');
% Pendulum
Pend                            = Rot(Q(1)) * [XPend'; YPend'];
XPendR                          = Pend(1,:)';
YPendR                          = Pend(2,:)' + CartHeight + WheelRadius;
HPend                           = fill(XPendR + X(1),YPendR,'g');
grid on;
frames(1)                       = getframe;
for i = 2:length(Q)
    % Cart
    set(HCart,'XData',XCart + X(i));
    % Back wheel
    set(HWheel1,'XData',XWheel1 + X(i));
    % Front wheel
    set(HWheel2,'XData',XWheel2 + X(i));
    % Pendulum
    Pend                            = Rot(Q(i)) * [XPend'; YPend'];
    XPendR                          = Pend(1,:);
    YPendR                          = Pend(2,:) + CartHeight + WheelRadius;
    set(HPend,'XData',XPendR + X(i),'YData',YPendR);
    % Delay
    pause(0.01);
    drawnow();    
    frames(i)                       = getframe;                             %#ok<AGROW>
end

%% Export to AVI
video = VideoWriter('cart-pendulum.avi');
open(video);
writeVideo(video,frames);
close(video);
end

    
    



