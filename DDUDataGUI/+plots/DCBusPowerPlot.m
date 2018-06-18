function [ output_args ] = DCBusPowerPlot( CoreData, fig )
%This function plots the DC bus power in kW vs time. CoreData is the input
%file containing the run data, fig is an optional parameter of a figure
%handle for the plot to be made on.

set(gcf,'color','w'); set(gca,'fontsize',16);hold on;
%set(f,'name','DC Bus Power','numbertitle','off')
title('DC Bus Power');
plot(CoreData.Powertrain.Inverter.CalculatedDCPower,'LineWidth',1);
xlabel('Time [s]');
ylabel('Power [W]');
end