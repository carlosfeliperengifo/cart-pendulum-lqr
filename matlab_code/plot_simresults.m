function plot_simresults(Time,Pos,Th,F)
figure;
subplot(2,1,1);
plot(Time,rad2deg(Th),'Linewidth',2);
grid on;
title('Cart-pendulum closed loop response','Fontsize',12);
xlabel('Time [seconds]','Fontsize',12);
ylabel('Angle [degres]','Fontsize',12);

%% Position
subplot(2,1,2);
plot(Time,Pos,'Linewidth',2);
grid on;
title('Linear position','Fontsize',12);
xlabel('Time [seconds]','Fontsize',12);
ylabel('[meters]','Fontsize',12);

%% Force
figure;
plot(Time,F,'Linewidth',2);
grid on;
title('Force pushing the car','Fontsize',12);
xlabel('Time [seconds]','Fontsize',12);
ylabel('[Newton]','Fontsize',12);
end
