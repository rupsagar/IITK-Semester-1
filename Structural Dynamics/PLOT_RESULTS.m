function PLOT_RESULTS(input,output,fig1,fig2,fig3,fig4)

wn = input.wn;
zeta = input.zeta;
dt = input.dt;
tmax = input.tmax;
a_data = input.a_data;
xv = output.xv;
spectral_data = output.spectral_data;

% fig1 = {[2 4],[3 5]};

fig_data = ["SD   ";"SV  ";"SA (in g)  ";"PSV";"PSA (in g)"];
num_fig = numel(fig1);
figax = gobjects(num_fig,2);

for i = 1:num_fig
    figax(i,1) = figure('visible','off'); figax(i,2) = gca;
    for j = 1:numel(zeta)
        semilogx(figax(i,2),2*pi./wn,spectral_data(fig1{i},:,j)), hold on
    end
    
    leg_data_1 = repmat(fig_data(fig1{i}),numel(zeta),1);
    leg_data_2 = repmat(' \zeta = ',numel(zeta)*numel(fig1{i}),1);
    leg_data_3 = repmat(zeta(:)',numel(fig1{i}),1); leg_data_3 = num2str(leg_data_3(:));
    leg = strcat(leg_data_1,leg_data_2,leg_data_3);
    legend(leg)
    
    grid on, xlabel('Natural time period (T_n) (s)'), ylabel(fig_data(fig1{i}))
    set(figax(i,1),'visible','on');
end

if numel(fig2)~=0
    T = (numel(a_data)-1)*dt; figure, plot(0:dt:T,a_data), grid on % plot given ground acceleration
    title ('Ground acceleration due to earthquake motion vs Time','interpreter','latex')
    xlabel('Time (t) (s)','interpreter','latex'), ylabel('Ground acceleration $\stackrel{..}{a}$(t)','interpreter','latex')
end

% this part plots all the displacement and velocity response graphs for all zeta and wn and should
% be uncommented for specific values of zeta and wn
% otherwise it can hang the computer if a lot of plots are generated at a time

if numel(fig3)~=0
    for k = 1:numel(zeta)
        for l = 1:numel(wn)
            figure('visible','on') % turn visibility off to avoid hanging of PC and for only saving figures
            plot(0:dt:tmax,xv(1,:,l,k)), grid on
            title (['Displacement vs Time \zeta = ',num2str(zeta(k)),', \omega_n = ',num2str(wn(l)),' rad/s'])
            xlabel('Time (t) (s)'), ylabel('Displacement (x(t))')        
        end
    end
end

if numel(fig4)~=0
    for k = 1:numel(zeta)
        for l = 1:numel(wn)
            figure('visible','on') % turn visibility off to avoid hanging of PC and for only saving figures
            plot(0:dt:tmax,xv(2,:,l,k)), grid on
            title (['Velocity vs Time \zeta = ',num2str(zeta(k)),', \omega_n = ',num2str(wn(l)),' rad/s'])
            xlabel('Time (t) (s)'), ylabel('Velocity (v(t))')        
        end
    end
end

end