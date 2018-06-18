function [ output_args ] = GPS_LapAnalysis(CoreData, fig)
%This function plots the GPS data Longitude, Latitude, and speed in a 2D
%plot. CoreData is the input file containing the run data, fig is an
%optional parameter of a figure handle for the plot to be made on. 

%launch dialog box with input selection
list = {'Time [sec]','Speed [mph]','Altitude [m]', ...
    'Lateral Acceleration [G]', 'Corner Radius [m]'};
[indx,tf] = listdlg('ListString',list,'PromptString','Select Z-Axis Data');

if tf == 0
    return
else
end
progressPct = 0;
f = waitbar(progressPct,'Please wait while this bitchin data is converted to floating point...');

%filtering
min_corner_radius = 7;  %minimum corner radius of track in meters
max_lat_accel_g = 1.5;  %max allowable lat accel (used for filtering)
corner_pt_ct = 20;      %number of points used in corner radius cicle fit
rolling_ave_pt_ct = 5;  %size of filtering window
std_dev_allowed = 0.8;  %number of std dev allowed from rolling ave
min_HDOP = 0.1;         %GPS horiz DOP   
max_HDOP = 1.5;         %GPS horiz DOP

%% Floating Pt Conversion
lat = CoreData.Uncategorized.Latitude.data;
long = CoreData.Uncategorized.Longitude.data;
alt = CoreData.Uncategorized.Altitude.data;
speed = CoreData.Uncategorized.Speed.data;
HDOP = CoreData.Uncategorized.HDOP.data;
time = CoreData.Uncategorized.Latitude.time;

data_bin(1, :, :) = dec2bin(lat, 32);
data_bin(2, :, :) = dec2bin(long, 32);
data_bin(3, :, :) = dec2bin(alt, 32);
data_bin(4, :, :) = dec2bin(speed, 32);
data_bin(5, :, :) = dec2bin(HDOP, 32);

[c h w] = size(data_bin);

for i=1:5
    for j=1:h
            s_bin(j, :) = data_bin(i, j, 1);
            e_bin(j, :) = data_bin(i, j, 2:9);
            m_bin(j, :) = data_bin(i, j, 10:32);       
            e_dec(i, j) = bin2dec(e_bin(j, :)) - 127;
            m_dec(i, j) = 1 + (bin2dec(m_bin(j, :)) / (2^23));
            data_float(i, j) = (-1)^s_bin(j) * m_dec(i, j) * 2^e_dec(i, j);
            progressPct = ((((j/h) / 5) + (i*0.2)) * 0.35);
            waitbar(progressPct,f);
    end
end
    
e_dec = e_dec.';
m_dec = m_dec.';
data_float = data_float.';

k = 1;
GPS_HDOP = data_float(:, 5);
for i=1:h
    if GPS_HDOP(i) > min_HDOP && GPS_HDOP(i) < max_HDOP
        GPSlat(k) = data_float(i, 1) / 100;
        GPSlong(k) = data_float(i, 2) / -100;
        GPSalt(k) = data_float(i, 3);
        GPSspeed_mph(k) = data_float(i, 4);
        GPS_HDOP_filtered(k) = data_float(i, 5);
        GPStime(k) = time(i);
        k = k+1;
        progressPct = (((i/h)* 0.05) + 0.35);
        waitbar(progressPct,f);
    else
    end
end


%% Data Processing
earth_radius =  6371000;
GPSdist_m(1) = 0;

%find center point and extremas
GPSlat_max = max(GPSlat);
GPSlat_min = min(GPSlat);
GPSlat_maxdelta = GPSlat_max - GPSlat_min;
GPSlat_center = GPSlat_min + (GPSlat_maxdelta/2);
GPSlong_max = max(GPSlong);
GPSlong_min = min(GPSlong);
GPSlong_maxdelta = GPSlong_max - GPSlong_min;
GPSlong_center = GPSlong_min + (GPSlong_maxdelta/2);
maxDim = max(GPSlong_maxdelta, GPSlat_maxdelta);


for i=1:length(GPSlat)
    GPS_xpos_m(i) = (earth_radius + GPSalt(i)) * sind(GPSlong(i) - GPSlong_min);
    GPS_ypos_m(i) = (earth_radius + GPSalt(i)) * sind(GPSlat(i) - GPSlat_max);
end

for i=1:(length(GPSlat) - 1)
    GPS_dx_m(i+1) = GPS_xpos_m(i+1) - GPS_xpos_m(i);
    GPS_dy_m(i+1) = GPS_ypos_m(i+1) - GPS_ypos_m(i);
    GPSdist_delta(i+1) = sqrt(GPS_dx_m(i+1)^2 + GPS_dy_m(i+1)^2);
    GPSdist_m(i+1) = GPSdist_m(i) + GPSdist_delta(i+1);
    progressPct = (((i/(length(GPSlat)-1))* 0.05) + 0.4);
    waitbar(progressPct,f);
end
GPSdist_mi = GPSdist_m / 1609.344;

%curve fit constant radius to rolling point group
pt_ct = corner_pt_ct;
for i=1:length(GPSlat)
    if i < (pt_ct+1)
        xPts = GPS_ypos_m(1:i);
        yPts = GPS_ypos_m(1:i);
    else
        xPts = GPS_xpos_m((i-pt_ct):i);
        yPts = GPS_ypos_m((i-pt_ct):i);  
    end
    x=xPts(:); 
    y=yPts(:);
    a=[x y ones(size(x))]\[-(x.^2+y.^2)];
    xc = -.5*a(1);
    yc = -.5*a(2);
    R  =  sqrt((a(1)^2+a(2)^2)/4-a(3));
    corner_radius(i) = R;
    progressPct = (((i/length(GPSlat))* 0.35) + 0.45);
    waitbar(progressPct,f);
end

%filter corner radii below min
%remove if below min and interpolate to match common time vector
%corner_radius_filtered(time, radius)
k=1;
for i=1:length(GPStime)
    if corner_radius(i) >= min_corner_radius
        corner_radius_filtered(1, k) = GPStime(i);
        corner_radius_filtered(2, k) = corner_radius(i);
        k = k+1;
    else
    end
    progressPct = (((i/length(GPStime))* 0.05) + 0.8);
    waitbar(progressPct,f);
end
corner_radius = interp1(corner_radius_filtered(1,:), corner_radius_filtered(2,:), GPStime);

%filter corner radii outside of 1 std dev from rolling ave
%interpolate to match common time vector
%corner_radius_filtered(time, radius)
k=1;
for i=1:length(GPStime)
    if i < (rolling_ave_pt_ct+1)
        corner_rad_ave = mean(corner_radius(1:i));
        corner_rad_std = std(corner_radius(1:i));
    else
        corner_rad_ave = mean(corner_radius((i-rolling_ave_pt_ct):i));
        corner_rad_std = std(corner_radius((i-rolling_ave_pt_ct):i));
    end
    if corner_radius(i) >= (corner_rad_ave - std_dev_allowed*corner_rad_std) && corner_radius(i) <= (corner_rad_ave + std_dev_allowed*corner_rad_std)
        corner_radius_filtered2(1, k) = GPStime(i);
        corner_radius_filtered2(2, k) = corner_radius(i);
        k = k+1;
    else
    end
    progressPct = (((i/length(GPStime))* 0.05) + 0.85);
    waitbar(progressPct,f);
end
corner_radius = interp1(corner_radius_filtered2(1,:), corner_radius_filtered2(2,:), GPStime);

%calculate lateral acceleration
GPSspeed_ms = GPSspeed_mph / 2.23694; 
for i=1:length(corner_radius)
    lat_accel(i) = (GPSspeed_ms(i)^2) / corner_radius(i);
    progressPct = (((i/length(corner_radius))* 0.05) + 0.9);
    waitbar(progressPct,f);
end
lat_accel_g = lat_accel / 9.81;

%filter lateral acceleration and interpolate to fit common time vector
k=1;
for i=1:length(GPStime)
    if lat_accel_g(i) <= max_lat_accel_g
        lat_accel_g_filtered(1, k) = GPStime(i);
        lat_accel_g_filtered(2, k) = lat_accel_g(i);
        k = k+1;
    else
    end
    progressPct = (((i/length(GPStime))* 0.05) + 0.95);
    waitbar(progressPct,f);
end
lat_accel_g = interp1(lat_accel_g_filtered(1,:), lat_accel_g_filtered(2,:), GPStime);

%close loading dialog box
close(f)

%% Plotting
%assign z axis data 
if indx(1) == 1
    GPSzaxis = GPStime;
elseif indx(1) == 2
    GPSzaxis = GPSspeed_mph;
elseif indx(1) == 3
    GPSzaxis = GPSalt;
elseif indx(1) == 4
    GPSzaxis = GPSdist_mi;
elseif indx(1) == 5
    GPSzaxis = lat_accel_g;
elseif indx(1) == 6
    GPSzaxis = corner_radius;
end

%Animate full coord plot to find start and end index for lap definition
fig0 = figure('Visible','off', 'pos', [50 50 600 600]);
s = scatter(GPSlong, GPSlat, 50, GPSzaxis, 'filled');
xlim([(GPSlong_center - (maxDim/1.75)), (GPSlong_center + (maxDim/1.75))])
ylim([(GPSlat_center - (maxDim/1.75)), (GPSlat_center + (maxDim/1.75))])
pbaspect([1 1 1])
c = colorbar;
c.Label.String = 'Run Time [sec]';
title 'GPS position on course';
% Create start and end sliders
sld1 = uicontrol('Style', 'slider',...
    'Min',1,'Max',length(GPStime),'Value',length(GPStime),...
    'Position', [335 9 140 20]);
sld2 = uicontrol('Style', 'slider',...
    'Min',1,'Max',length(GPStime),'Value',1,...
    'Position', [135 9 140 20]);
sld1.Callback = @(es,ed) endindex_adjust(sld1, sld2, s, GPSlong, GPSlat, GPStime);
sld2.Callback = @(es,ed) startindex_adjust(sld1, sld2, s, GPSlong, GPSlat, GPStime);
% Add a text uicontrol to label the slider.
txt1 = uicontrol('Style','text',...
    'Position',[475 6 60 20],...
    'String','End Index');
txt2 = uicontrol('Style','text',...
    'Position',[65 6 60 20],...
    'String','Start Index');
% Make figure visble after adding all components
fig0.Visible = 'on';

%% UIcontrol Functions
%update end index on main plot
function endindex_adjust(source1,source2,s1, x, y, z)
    %update end index
    s1.XData = x(int32(source2.Value):int32(source1.Value));
    s1.YData = y(int32(source2.Value):int32(source1.Value));
    s1.CData = z(int32(source2.Value):int32(source1.Value));
    
    %display end index value
    txt = uicontrol('Style','text',...
    'Position',[535 6 40 20],...
    'String',num2str(int32(source1.Value)));
end

%update start index on main plot
function startindex_adjust(source1,source2,s1, x, y, z)
    %update start index
    s1.XData = x(int32(source2.Value):int32(source1.Value));
    s1.YData = y(int32(source2.Value):int32(source1.Value));
    s1.CData = z(int32(source2.Value):int32(source1.Value));
    
    %display start index value
    txt = uicontrol('Style','text',...
    'Position',[25 6 40 20],...
    'String',num2str(int32(source2.Value)));
end

end