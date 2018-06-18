function [ output_args ] = CellTempPlot( CoreData, fig )
%This function plots all of the valid cell temperatures (above 0C average).
%CoreData is the input file containing the run data, fig is an optional
%parameter of a figure handle for the plot to be made on.

set(gcf,'color','w'); set(gca,'fontsize',16); hold on;
% set(f,'name','Cell Temperatures','numbertitle','off')
plot(CoreData.Powertrain.BatteryPack.CellTemp1 / 100.0,'LineWidth',1);
plot(CoreData.Powertrain.BatteryPack.CellTemp2 / 100.0,'LineWidth',1);
plot(CoreData.Powertrain.BatteryPack.CellTemp3 / 100.0,'LineWidth',1);
plot(CoreData.Powertrain.BatteryPack.CellTemp4 / 100.0,'LineWidth',1);
plot(CoreData.Powertrain.BatteryPack.CellTemp5 / 100.0,'LineWidth',1);
plot(CoreData.Powertrain.BatteryPack.CellTemp6 / 100.0,'LineWidth',1);
plot(CoreData.Powertrain.BatteryPack.CellTemp8 / 100.0,'LineWidth',1);
plot(CoreData.Powertrain.BatteryPack.CellTemp9 / 100.0,'LineWidth',1);
plot(CoreData.Powertrain.BatteryPack.CellTemp10 / 100.0,'LineWidth',1);
plot(CoreData.Powertrain.BatteryPack.CellTemp13 / 100.0,'LineWidth',1);
plot(CoreData.Powertrain.BatteryPack.CellTemp14 / 100.0,'LineWidth',1);
plot(CoreData.Powertrain.BatteryPack.CellTemp15 / 100.0,'LineWidth',1);
plot(CoreData.Powertrain.BatteryPack.CellTemp16 / 100.0,'LineWidth',1);
plot(CoreData.Powertrain.BatteryPack.CellTemp17 / 100.0,'LineWidth',1);
plot(CoreData.Powertrain.BatteryPack.CellTemp18 / 100.0,'LineWidth',1);
plot(CoreData.Powertrain.BatteryPack.CellTemp20 / 100.0,'LineWidth',1);
plot(CoreData.Powertrain.BatteryPack.CellTemp21 / 100.0,'LineWidth',1);
plot(CoreData.Powertrain.BatteryPack.CellTemp22 / 100.0,'LineWidth',1);
plot(CoreData.Powertrain.BatteryPack.CellTemp23 / 100.0,'LineWidth',1);
plot(CoreData.Powertrain.BatteryPack.CellTemp24 / 100.0,'LineWidth',1);
plot(CoreData.Powertrain.BatteryPack.CellTemp25 / 100.0,'LineWidth',1);
plot(CoreData.Powertrain.BatteryPack.CellTemp26 / 100.0,'LineWidth',1);
plot(CoreData.Powertrain.BatteryPack.CellTemp27 / 100.0,'LineWidth',1);
plot(CoreData.Powertrain.BatteryPack.CellTemp28 / 100.0,'LineWidth',1);
plot(CoreData.Powertrain.BatteryPack.CellTemp29 / 100.0,'LineWidth',1);
plot(CoreData.Powertrain.BatteryPack.CellTemp30 / 100.0,'LineWidth',1);
plot(CoreData.Powertrain.BatteryPack.CellTemp31 / 100.0,'LineWidth',1);
plot(CoreData.Powertrain.BatteryPack.CellTemp32 / 100.0,'LineWidth',1);
plot(CoreData.Powertrain.BatteryPack.CellTemp33 / 100.0,'LineWidth',1);
plot(CoreData.Powertrain.BatteryPack.CellTemp34 / 100.0,'LineWidth',1);
plot(CoreData.Powertrain.BatteryPack.CellTemp36 / 100.0,'LineWidth',1);
plot(CoreData.Powertrain.BatteryPack.CellTemp37 / 100.0,'LineWidth',1);
plot(CoreData.Powertrain.BatteryPack.CellTemp38 / 100.0,'LineWidth',1);
plot(CoreData.Powertrain.BatteryPack.CellTemp39 / 100.0,'LineWidth',1);
plot(CoreData.Powertrain.BatteryPack.CellTemp40 / 100.0,'LineWidth',1);
plot(CoreData.Powertrain.BatteryPack.CellTemp41 / 100.0,'LineWidth',1);
plot(CoreData.Powertrain.BatteryPack.CellTemp42 / 100.0,'LineWidth',1);
plot(CoreData.Powertrain.BatteryPack.CellTemp44 / 100.0,'LineWidth',1);
plot(CoreData.Powertrain.BatteryPack.CellTemp45 / 100.0,'LineWidth',1);
plot(CoreData.Powertrain.BatteryPack.CellTemp46 / 100.0,'LineWidth',1);
plot(CoreData.Powertrain.BatteryPack.CellTemp48 / 100.0,'LineWidth',1);

xlabel('Time [s]');
ylabel('Temperature [^{\circ}C]');
title('Individual Cell Temperatures');
ylim([-5 inf]);
xlim auto;
end

