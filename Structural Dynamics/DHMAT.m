function [A,B] = DHMAT(z,wn,dt)

A = zeros(2,2);
B = zeros(2,2);

e = exp(-z*wn*dt);
wd = wn*sqrt(1-z^2);
s = sin(wd*dt);
c = cos(wd*dt);

A(1,1) = e*(z*wn*s/wd+c);
A(1,2) = e*s/wd;
A(2,1) = -e*wn^2/wd*s;
A(2,2) = e*(c-wn*z/wd*s);

B(1,1) = e*((z/wn+(2*z^2-1)/dt/wn^2)*s/wd+(1/wn^2+2*z/dt/wn^3)*c)-2*z/dt/wn^3;
B(1,2) = -e*((2*z^2-1)/dt/wd/wn^2*s+2*z/wn^3/dt*c)+2*z/dt/wn^3-1/wn^2;
B(2,1) = -e*(c/wn^2/dt+(1+z/wn/dt)*s/wd)+1/wn^2/dt;
B(2,2) = e*(c/wn^2/dt+z/dt/wn/wd*s)-1/wn^2/dt; 

end