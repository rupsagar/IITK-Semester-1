function VALIDATION_CODE
% VALIDATION BY ANALYTICAL SOLUTION

Tn = 1;
wn = 2*pi./Tn;
zeta = .02;
dt = 0.1;
x0 = 0;
xdot0 = 0;
tmax = 5;
T = 3;
t = 0:dt:T;
a_data = t./T-1;
g = 9.81;

% NIGAM & JENNINGS SOLUTION
[~,output] = NIGAM_JENNINGS(wn,zeta,dt,x0,xdot0,tmax,a_data,g);

% ANALYTICAL SOLUTION
wd = wn*sqrt(1-zeta^2);
C = (x0-1/wn^2-2*zeta/wn^3/T);
D = ((zeta*wn*x0+xdot0-zeta/wn-1/T/wn^2*(2*zeta^2-1))/wd);

xt1 = @(t)(exp(-zeta*wn*t).*(C*cos(wd*t)+D*sin(wd*t))+...
    (1-t/T)/wn^2+2*zeta/wn^3/T);

xdott1 = @(t)(exp(-zeta*wn*t).*((D*wd-C*zeta*wn)*cos(wd*t)-(C*wd+D*zeta*wn)*sin(wd*t))...
    -1/wn^2/T);

xt2 = @(t)(exp(-zeta*wn*(t-T)).*(xt1(T)*cos(wd*(t-T))+...
    (xdott1(T)+zeta*wn*xt1(T))/wd*sin(wd*(t-T))));

xdott2 = @(t)(exp(-zeta*wn*(t-T)).*(xdott1(T)*cos(wd*(t-T))-...
    (wn^2*xt1(T)+zeta*wn*xdott1(T))/wd*sin(wd*(t-T))));

% PLOT RESULTS
figure,
plot(0:dt:tmax,output.xv(1,:,1,1),'*-')
hold on, fplot(xt1,[0 T],'r')
hold on, fplot(xt2,[T tmax],'g')
grid on
ax = gca;
ax.XLim = [0 tmax];
title('Plot of Displacement Vs Time (s)')
xlabel ('Time (t) (s)'), ylabel('Displacement (x(t))')

figure,
plot(0:dt:tmax,output.xv(2,:,1,1),'*-')
hold on, fplot(xdott1,[0 T],'r')
hold on, fplot(xdott2,[T tmax],'g')
grid on
ax = gca;
ax.XLim = [0 tmax];
title('Plot of Velocity Vs Time (s)')
xlabel ('Time (t) (s)'), ylabel('Velocity (v(t))')

end