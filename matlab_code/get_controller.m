function control    = get_controller(linmod_k,ycontrol,add_states,lstates,kobs)
% State space model of the controller that comprises the observer, the
% additional states generator, and the state feedback.

%% States gain
nx                  = size(linmod_k.A,1);
lx                  = lstates(:,1:nx);
lz                  = lstates(:,nx+1:end);

%% Dimensions of signals
nu                  = size(linmod_k.B,2);
nyc                 = length(ycontrol);
nz                  = length(lz);
nym                 = size(linmod_k.C,1);

%% Matrix with zeros
znz_nx              = zeros(nz,nx);
znx_nu              = zeros(nx,nu);
znx_nyc             = zeros(nx,nyc);
znz_nym             = zeros(nz,nym);

%% Dynamic matrix of the controller
acontrol            = [(linmod_k.A-kobs*linmod_k.C)-(linmod_k.B-kobs*linmod_k.D)*lx,  -(linmod_k.B-kobs*linmod_k.D)*lz; znz_nx, add_states.A];

%% Input matrix of the controller
bcontrol            = [znx_nu, kobs, znx_nyc; add_states.B, znz_nym, -add_states.B];

%% Output matrix of the controller
ccontrol            = [-lx, -lz];

%% Direct input to output matrix of the controller
dcontrol            = zeros(nu,nyc+nym+nyc);

%% Controller simplification
yc                  = ycontrol;
bcontrol(:,nz+yc)   = bcontrol(:,nz+yc) + bcontrol(:,nz+nym+1:end);
bcontrol            = bcontrol(:,1:nz+nym);
dcontrol(:,nz+yc)   = dcontrol(:,nz+yc) + dcontrol(:,nz+nym+1:end);
dcontrol            = dcontrol(:,1:nz+nym);

%% State space model of the controller
control             = ss(acontrol,bcontrol,ccontrol,dcontrol,linmod_k.Ts);
end