function [ output_args ] = VelocityPlot( CoreData, fig )
%This function plots the calculated vehicle speed in mph vs time based on
%gearing and wheel circumference.  CoreData is the input file containing
%the run data, fig is an optional parameter of a figure handle for the plot
%to be made on.

set(gcf,'color','w'); set(gca,'fontsize',16); hold on;
%set(f,'name','Vehicle Speed','numbertitle','off');
gearing=58/21;
wheel_circ=2.082; %m
mps=CoreData.Powertrain.Motor.ActualMotorRPM.data/gearing*wheel_circ/60;
mph=mps*2.237;
plot(CoreData.Powertrain.Motor.ActualMotorRPM.time, mph,'LineWidth',1);
%plot(CoreData.Vehicle.GPS.GPSVelocity);
%h=legend('Calculated Speed', 'GPS Speed');
%set(h,'FontSize',10);
xlabel('Time [s]');
ylabel('Vehicle Speed [mph]');
title('Vehicle Speed vs Time');
end

