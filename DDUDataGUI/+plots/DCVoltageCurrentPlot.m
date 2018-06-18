function [ output_args ] = DCVoltageCurrentPlot( CoreData, fig )
%This function plots the DC bus voltage and current on two subplots.
%CoreData is the input file containing the run data, fig is an optional
%parameter of a figure handle for the plot to be made on.

set(gcf,'color','w'); set(gca,'fontsize',16)
%set(f,'name','DC Bus Voltage and Current','numbertitle','off')
title('Battery Pack Current and Voltage');
hold on;
yyaxis left
% ax1=subplot(2,1,1);
plot(CoreData.Powertrain.Inverter.DCBusVoltage);
% title('DC Bus Voltage');
xlabel('Time [s]');
ylabel('Bus Voltage [V]');
yyaxis right
% ax2=subplot(2,1,2);
plot(CoreData.Powertrain.Inverter.DCBusCurrent);
% title('DC Bus Current');
% xlabel('Time [s]');
ylabel('Bus Current [A]');
% linkaxes([ax1,ax2],'x');

legend Vdc Idc;

end

