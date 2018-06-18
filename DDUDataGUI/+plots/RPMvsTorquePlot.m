function [ output_args ] = RPMvsTorquePlot( CoreData )
%This function plots the motor torque and RPM seen in the data as a
%scaterplot with the bounds of the set rider control limits.  CoreData is
%the input file containing the run data, fig is an optional parameter of a
%figure handle for the plot to be made on.

set(gcf,'color','w'); set(gca,'fontsize',16); hold on;
scatter(CoreData.Powertrain.Motor.ActualMotorRPM.data,abs(CoreData.Powertrain.Inverter.TorqueFeedback.data));
xlabel('Motor Velocity [RPM]');
ylabel('Motor Torque [Nm]');
title('Torque vs RPM');
xlim([0 4500]);
ylim([0 600]);
end

