function [input,output] = NIGAM_JENNINGS(wn,zeta,dt,x0,xdot0,tmax,a_data,g)
% NIGAM_JENNINGS calculates the response and spectral values for a given accelerogram data

time_steps = tmax/dt+1; % number of iterations for each zeta and wn

xv = zeros(2,time_steps,numel(wn),numel(zeta)); % initializing displacement and velocity vectors
spectral_data = zeros(5,numel(wn),numel(zeta)); % initializing SD, SV, SA, PSV and PSA vectors

% fileID = fopen('NIGAM_JENNINGS_OUTPUT.txt','w'); % create output file for printing result and return its handle

for i = 1:numel(zeta)
    for j = 1:numel(wn)
        [A,B] = DHMAT(zeta(i),wn(j),dt); % DHMAT calculates A & B matrix for each zeta and wn
        xv(:,1,j,i) = [x0;xdot0]; % initial conditions
        
        for k = 2:time_steps
            t = (k-1)*dt;
            f = EXCIT(t,dt); % EXCIT gives ground acceleration values for each time step
            xv(:,k,j,i) = A*xv(:,k-1,j,i)+B*f(:); % calculates displacement and velocity            
        end
        
%         fprintf(fileID,['\nzeta=',num2str(zeta(i)),', wn=',num2str(wn(j)),'rad/s\n']); % print output to file
%         fprintf(fileID,'   t        x(t)          xdot(t)\n'); % print output to file
%         fprintf(fileID,'%3.4f   % 3.10f  % 3.10f\n',[0:dt:tmax;xv(1,:,j,i);xv(2,:,j,i)]); % print output to file
        
        spectral_data(1:2,j,i) = max(abs(xv(:,:,j,i)),[],2); % calculates SD and SV
        spectral_data(3,j,i) = max(abs(-2*zeta(i)*wn(j)*xv(2,:,j,i)-wn(j)^2*xv(1,:,j,i))); % calculates SA
        spectral_data(3,j,i) = spectral_data(3,j,i)./g; % SA expressed in g
    end
    spectral_data(4:5,:,i) = [wn(:)'; wn(:)'.^2./g].*spectral_data(1,:,i); % calculates PSV and PSA, PSA expressed in g 
end

% fclose(fileID); % close handle to output file

input.wn = wn;
input.zeta = zeta;
input.dt = dt;
input.tmax = tmax;
input.a_data = a_data;
output.xv = xv; % output all xv as structure
output.spectral_data = spectral_data; % output all spectral data as structure

    function f = EXCIT(t,dt)
        f = [0,0];
        m = round(t/dt); % round off value to integer
        if m<numel(a_data)
            f = a_data(m:m+1);
        elseif m==numel(a_data)
            f(1) = a_data(m);
        end
    end

end