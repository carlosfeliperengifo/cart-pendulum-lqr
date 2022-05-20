# cart-pendulum-lqr
MATLAB and Processing programs to simulate a linear quadratic control for an inverted pendulum on a cart.

The "matlab_code" folder contains MATLAB and Simulink files for designing and simulating a linear quadratic control for an inverted pendulum mounted on a cart. The main script, called "main_cart_pendulum_dlqr.m", performs the following tasks:

1) Linearizes the nonlinear model of the cart-pendulum system.
2) Calculates the discrete time linear quadratic controller, which comprises a state feedback gain and a Luenberger observer.
3) Calls the Simulink file that tests the linear quadratic controller on a nonlinear model of the cart-pendulum system.
4) Displays an animation of the cart-pendulum system.
5) Convert the controller to C language code.

The "processing_code" folder contains a file that simulates a linear quadratic control for an inverted pendulum mounted on a cart. The controller calculates at each sampling time (0.01 seconds) the force necessary to move the car towards the position indicated by the user with the mouse. The controller moves the car while keeping the pendulum upright. The simulator solvers the nonlinear closed loop equation using a third order Runge-Kutta algorithm.

The Matlab file requires MATLAB 2020b and Simulink R2020b.
The processing file requeres Processing 4.0.
