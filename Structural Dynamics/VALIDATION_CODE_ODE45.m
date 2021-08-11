function VALIDATION_CODE_ODE45
% VALIDATION BY ODE45 SOLUTION

Tn = 1;
zeta = .02;
x0 = 0; xdot0 = 0; tmax = 5; T = 3;
wn = 2*pi./Tn;

tspan1 = [0 T]; ini1 = [x0 xdot0];
eqn1=@(t,x)([x(2);-wn^2*x(1)-2*zeta*wn*x(2)+(1-t/T)]);
[t1,x1]=ode45(eqn1,tspan1,ini1);

tspan2 = [T tmax]; ini2 = [x1(end,1) x1(end,2)];
eqn2=@(t,x)([x(2);-wn^2*x(1)-2*zeta*wn*x(2)]);
[t2,x2]=ode45(eqn2,tspan2,ini2);

figure (1), hold on ,plot([t1;t2],[x1(:,1);x2(:,1)],'k')
figure (2), hold on ,plot([t1;t2],[x1(:,2);x2(:,2)],'k')

end