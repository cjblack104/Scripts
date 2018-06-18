function [ output_args ] = ControllerCoolingPlot( CoreData, fig )
%This function plots the temperatures in the controller cooling loop
%including the controller phase temperatures and coolant and inlet and
%outlet temperatures vs time.  CoreData is the input file containing the
%run data, fig is an optional parameter of a figure handle for the plot to
%be made on.

set(gcf,'color','w'); set(gca,'fontsize',16); hold on;
plot(CoreData.Powertrain.Cooling.ControllerLoopInletTemp,'LineWidth',1);
plot(CoreData.Powertrain.Cooling.ControllerLoopOutletTemp,'LineWidth',1);
plot(CoreData.Powertrain.Cooling.ControlBoardTemp,'LineWidth',1);
plot(CoreData.Powertrain.Cooling.ModuleATemp,'LineWidth',1);
plot(CoreData.Powertrain.Cooling.ModuleBTemp,'LineWidth',1);
plot(CoreData.Powertrain.Cooling.ModuleCTemp,'LineWidth',1);
plot(CoreData.Powertrain.Cooling.GateDriverBoardTemperature,'LineWidth',1);
h=legend('Controller Inlet Temp', 'Controller Outlet Temp', 'Control Board Temp', 'Controller Module A Temp', 'Controller Module B Temp','Controller Module C Temp','Gate Driver Board Temp');
set(h,'FontSize',10);
xlabel('Time [s]');
ylabel('Temperature [^{\circ}C]');
title('Controller Cooling Loop Temperatures');
ylim([-5 inf])
xlim auto
end

