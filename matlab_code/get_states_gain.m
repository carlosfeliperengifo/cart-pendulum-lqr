function [L,MAdd]   = get_states_gain(modelk,Yc,q,r)
%% Modelo linealizado de tiempo discreto
[A,B,C]             = deal(modelk.A,modelk.B,modelk.C);
% Salida controlada
Cc                  = C(Yc,:);

%% Modelo del generador de estados adicionales de tiempo discreto
s                   = tf('s');
MAdd                = c2d(1/s,modelk.Ts,'zoh');
MAdd                = ss(MAdd);
[Az,Bz]             = deal(MAdd.A,MAdd.B);

%% Modelo extendido de tiempo discreto
% Numero de estados fisicos
nx                  = size(A,1);
% Numero de estados adicionales debidos a la referencia
nz                  = size(Az,1);
% Numero de entradas
nu                  = size(B,2);
% Numero de salidas medidas
%nym                 = size(Cm,1);
% Numero de salidas controladas
%nyc                 = length(YControl,1);
% Matrices del modelo extendido en espacio de estados
Znx_nz              = zeros(nx,nz);
Znz_nu              = zeros(nz,nu);
Ae                  = [A, Znx_nz; -Bz*Cc, Az];
Be                  = [B; Znz_nu];

%% Control LQR para el modelo extendido de tiempo discreto
L                   = dlqr(Ae,Be,q,r);
end
