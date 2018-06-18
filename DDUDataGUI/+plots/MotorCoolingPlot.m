function [ output_args ] = MotorCoolingPlot( CoreData )
%This function plots the temperatures in the motor cooling loop including
%the motor temperature and coolant and inlet and outlet temperatures vs
%time.  CoreData is the input file containing the run data, fig is an
%optional parameter of a figure handle for the plot to be made on.

% if ~exist('fig')
%     f=figure;
% else
%     f=figure(fig);
% end;

set(gcf,'color','w'); set(gca,'fontsize',16)
%set(f,'name','Motor Cooling Temperatures','numbertitle','off')
hold on;
plot(CoreData.Powertrain.Cooling.MotorLoopInletTempFiltered,'LineWidth',1);
plot(CoreData.Powertrain.Cooling.MotorLoopOutletTempFiltered,'LineWidth',1);
plot(CoreData.Powertrain.Cooling.MotorTemp,'LineWidth',1);
h=legend('Motor Inlet Temp', 'Motor Outlet Temp', 'Motor Temp');
set(h,'FontSize',10);
xlabel('Time [s]');
ylabel('Temperature [^{\circ}C]');
title('Motor Cooling Loop Temperatures');
ylim([-5 inf]);
xlim auto
end

