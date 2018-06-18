function [ output_args ] = GPSPlot(CoreData, fig)
%This function plots the GPS data Longitude, Latitude, and speed in a 2D
%plot. CoreData is the input file containing the run data, fig is an
%optional parameter of a figure handle for the plot to be made on. 

progressPct = 0;
f = waitbar(progressPct,'Please wait while data is converted to floating point...');

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
            progressPct = ((((j/h) / 5) + (i*0.2)) * 0.75);
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
        progressPct = (((i/h)* 0.25) + 0.75);
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

%close loading dialog box
close(f)

%plot speed colormap
set(gcf,'color','w'); set(gca,'fontsize',16); hold on;
scatter(GPSlong, GPSlat, 100, GPSspeed_mph, 'filled')
xlim([(GPSlong_center - (maxDim/1.75)), (GPSlong_center + (maxDim/1.75))])
ylim([(GPSlat_center - (maxDim/1.75)), (GPSlat_center + (maxDim/1.75))])
pbaspect([1 1 1])
c = colorbar;
c.Label.String = 'Vehicle Speed [MPH]';
title 'GPS speed on course';
end