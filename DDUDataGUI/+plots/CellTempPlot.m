function [ output_args ] = CellTempPlot( CoreData, fig )
%This function plots all of the valid cell temperatures (above 0C average).
%CoreData is the input file containing the run data, fig is an optional
%parameter of a figure handle for the plot to be made on.

set(gcf,'color','w'); set(gca,'fontsize',16); hold on;
% set(f,'name','Cell Temperatures','numbertitle','off')

for j=1:1:48
    dataname = ['CoreData.Powertrain.BatteryPack.CellTemp' num2str(j)];
    if min(eval(dataname)) > 0
        data = eval(dataname)/100;
        plot(data);
    end
end

xlabel('Time [s]');
ylabel('Temperature [^{\circ}C]');
title('Individual Cell Temperatures');
end

