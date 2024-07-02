% Programa para procesar datos de era5
% 2024/05/16 MA T-V 
% https://github.com/Mat-TV
aseo
%
%% Preámbulo
cd 'C:\Users\fredo\OneDrive\Documents\CHIC\Entorno\datos\ERA5'
nombre = 'PP_Month_NC.nc';
ncdisp(nombre);%,'headerlines',3); %,'Format','%s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%s');
bd=load('borderdata.mat');
blat_cl = cell2mat(bd.lat([33])); 
blon_cl = cell2mat(bd.lon([33]));
blat_ar = cell2mat(bd.lat([8]));
blon_ar = cell2mat(bd.lon([8]));
%% Fechas
horas =ncread(nombre,'time'); %fecha en minutos
inicio=datenum('01-01-1900 00:00','dd-mm-yyyy HH:MM'); %MONA
y=[];
for i=1:numel(horas) 
y=[y; addtodate(inicio,horas(i),'hour')];
end
fechas=y; %me gusta más este nombre
clear y horas inicio i
%
%% Ubicaciones
longitude = ncread(nombre, 'longitude');
latitude = ncread(nombre, 'latitude');
%
Core_ils = [ -36.75 -54.25;  % South Georgia
              37.75 -46.88;  % Marion & Prince Edward
              51.67 -46.38;  % Crozet Island
              69.16 -49.25;  % Kerguelen
              73.51 -53.10;  % Heard & McDonald
             158.86 -54.63]; % Mcquarie
DR_ils =   [ -68.73 -56.48]; % Diego Ramírez
Peri_ils = [ 166.53 -48.02;  % Snares
             169.15 -52.54;  % Campbell
             179.05 -47.75;  % Bounty
             -176.5 -44.00;  % Chathan
             -59.22 -51.73;  % Falklands
              -9.94 -40.32;  % Gough
              77.55 -37.83;  % Amsterdam & St. Paul
             -12.28 -37.12]; % Tristan da Cunha
%
%% Datos
pp_month_m = ncread(nombre, 'tp').*1000; % pp diaria promedio en el mes [mm]
pp_month = pp_month_m.*30; % pp mensual acumulada promedio cada mes
%
%% Previsualización
figure
m_proj('stereo','lat',-90,'long',-70,'radius',40)
m_pcolor(longitude,latitude,pp_month(:,:,1)');
m_coast('line','color','w');
title('Precipitación acumulada mensual (enero 1993)')
ax1=m_contfbar(.97,[.5 .9],pp_month(:,:,1)', ...
    [64],'edgecolor','none','endpiece','no');
title(ax1,{'Precipitación [mm]',''}); % Move up by inserting a blank line
m_grid('xaxis','top')
ax=gca;
ax.FontSize = 18;
%
%% Acumulado anual
c=1;
for i=1:12:length(pp_month(1,1,:))
    pp_year(:,:,c) = sum(pp_month(:,:,i:i+11),3);
    c=c+1;
end
pp_year_m = mean(pp_year,3);
% 
% MAPA DE COLOR
figure
m_proj('stereo','lat',-90,'long',-70,'radius',40)
m_pcolor(longitude,latitude,log10(pp_year_m'));
m_coast('line','color','w');
title('Yearly accumulated precipitation (1993-2023)')
% ax1=m_contfbar(.97,[.5 .9],pp_year_m', ...
%     [64],'edgecolor','none','endpiece','no');
% title(ax1,{'Rain [mm]',''}); % Move up by inserting a blank line
ax=gca;
ax.FontSize = 18;
m_grid('xaxis','top')

%
    num_of_ticks = 8;
    Ticks      = zeros(1,num_of_ticks);
    TickLabels = zeros(1,num_of_ticks);
    for n = 1:1:num_of_ticks
        Ticks(n+1)      = log10(round(6000)/num_of_ticks*n);
        TickLabels(n+1) = round(6000)/num_of_ticks*n;
    end
    Ticks(1)=1;
    TickLabels(1)=0;
    c=colorbar('Ticks',Ticks,'TickLabels',TickLabels);
    caxis([min(Ticks)*1.4 max(Ticks)])
% 
% CON ISOYETAS
figure
m_proj('stereo','lat',-90,'long',-70,'radius',53)
m_coast('line','color',[0 0 0],'linewidth',1.5);
% title('Yearly accumulated precipitation (1993-2023)')
% ax1=m_contfbar(.97,[.5 .9],pp_year_m', ...
%     [64],'edgecolor','none','endpiece','no');
% title(ax1,{'Rain [mm]',''}); % Move up by inserting a blank line
hold on;
m_colmap('diverging',256)
[cs,h]=m_contour(longitude,latitude,pp_year_m',[0:500:1500 100 250],'LabelSpacing',3500,'linewidth',1.5);
clabel(cs,h,'Margin',6,'fontsize',10);
% [cs2,h2]=m_contour(longitude,latitude,pp_year_m',[-3500:1500:6500],'LabelSpacing',2500,'linewidth',2.5);
% clabel(cs2,h2,'fontsize',12);
hold on
m_plot(Core_ils(:,1),Core_ils(:,2),'pr','linewidth',3.5)
m_plot(DR_ils(1,1),DR_ils(1,2),'pk','linewidth',7)
m_plot(Peri_ils(:,1),Peri_ils(:,2),'pb','linewidth',3.5)
hold off
ax=gca;
ax.FontSize = 12;
m_grid('ytick',[-50 -55 -60 -70 -80 -90],'xtick',[0 -90 180 90],'xaxis','top')



figure
m_proj('stereo','lat',-56.5,'long',-70,'radius',4)
hold on
m_plot(blon_cl,blat_cl,'color',[0.1 0.1 0.1],'linewidth',1)
m_plot(blon_ar,blat_ar,'color',[0.1 0.1 0.1],'linewidth',1)
% m_plot(trench(:,1),trench(:,2),'--black','linewidth',2)%plot de la fosa

% m_pcolor(longitude,latitude,log10(pp_year_m'));
% m_coast('line','color','r');
% title('Yearly accumulated precipitation (1993-2023)')
% ax1=m_contfbar(.97,[.5 .9],pp_year_m', ...
%     [64],'edgecolor','none','endpiece','no');
% title(ax1,{'Rain [mm]',''}); % Move up by inserting a blank line
hold on;
m_colmap('chlorophyle',256)
[cs,h]=m_contour(longitude,latitude,pp_year_m',[0:500:3500],'LabelSpacing',1050,'linewidth',1.5);
clabel(cs,h,'fontsize',14);
m_plot(-68.7333,-56.4833,'pk','linewidth',7)
hold off;
ax=gca;
ax.FontSize = 14;
m_grid('ytick',[ -56 -58 -60],'xtick',[-75 -70 -65 -60],'xaxis','top')
%
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% 
%% TEMPERATURAS
aseo
%
%% Preámbulo
cd 'C:\Users\fredo\OneDrive\Documents\CHIC\Entorno\datos\ERA5'
nombre = 'TEMP_Month_NC.nc';
ncdisp(nombre)
bd=load('borderdata.mat');
blat_cl = cell2mat(bd.lat([33])); 
blon_cl = cell2mat(bd.lon([33]));
blat_ar = cell2mat(bd.lat([8]));
blon_ar = cell2mat(bd.lon([8]));
% 
%% Fechas
horas =ncread(nombre,'time'); %fecha en minutos
inicio=datenum('01-01-1900 00:00','dd-mm-yyyy HH:MM'); %MONA
y=[];
for i=1:numel(horas) 
y=[y; addtodate(inicio,horas(i),'hour')];
end
fechas=y; %me gusta más este nombre
clear y horas inicio i
%
%% Ubicaciones
longitude = ncread(nombre, 'longitude');
latitude = ncread(nombre, 'latitude');
% 
Core_ils = [ -36.75 -54.25;  % South Georgia
              37.75 -46.88;  % Marion & Prince Edward
              51.67 -46.38;  % Crozet Island
              69.16 -49.25;  % Kerguelen
              73.51 -53.10;  % Heard & McDonald
             158.86 -54.63]; % Mcquarie
DR_ils =   [ -68.73 -56.48]; % Diego Ramírez
Peri_ils = [ 166.53 -48.02;  % Snares
             169.15 -52.54;  % Campbell
             179.05 -47.75;  % Bounty
             -176.5 -44.00;  % Chathan
             -59.22 -51.73;  % Falklands
              -9.94 -40.32;  % Gough
              77.55 -37.83;  % Amsterdam & St. Paul
             -12.28 -37.12]; % Tristan da Cunha
%
%% Datos
temp_month = ncread(nombre, 't2m')-273.15; % pp diaria promedio en el mes [mm]
%
%% Previsualización
figure
m_proj('stereo','lat',-90,'long',-70,'radius',40)
m_pcolor(longitude,latitude,temp_month(:,:,1)');
m_coast('line','color','w');
title('Temperatura promedio mensual (enero 1993)')
ax1=m_contfbar(.97,[.5 .9],temp_month(:,:,1)', ...
    [64],'edgecolor','none','endpiece','no');
title(ax1,{'Temperatura [°C]',''}); % Move up by inserting a blank line
m_grid('xaxis','top')
ax=gca;
ax.FontSize = 12;
% 
%% Acumulado anual
c=1;
for i=1:12:length(temp_month(1,1,:))
    temp_year(:,:,c) = mean(temp_month(:,:,i:i+11),3);
    c=c+1;
end
temp_year_m = mean(temp_year,3);
% 
% MAPA DE COLOR
figure
m_proj('stereo','lat',-90,'long',-70,'radius',40)
m_pcolor(longitude,latitude,temp_year_m');
m_coast('line','color','w');
title('Yearly mean Temperature (1993-2023)')
ax1=m_contfbar(.97,[.5 .9],temp_year_m', ...
    [64],'edgecolor','none','endpiece','no');
title(ax1,{'Temp [°C]',''}); % Move up by inserting a blank line
colormap("jet")
hold on
m_plot(DR_ils(1,1),DR_ils(1,2),'pk','linewidth',7)
hold off
ax=gca;
ax.FontSize = 12;
m_grid('xaxis','top')
% 
% CON ISOYETAS TEMPERATURA MEDIA 
figure
m_proj('stereo','lat',-90,'long',-70,'radius',53)
m_coast('line','color',[0.15 0.15 0.15]);
% title('Yearly accumulated precipitation (1993-2023)')
% ax1=m_contfbar(.97,[.5 .9],pp_year_m', ...
%     [64],'edgecolor','none','endpiece','no');
% title(ax1,{'Rain [mm]',''}); % Move up by inserting a blank line
hold on;
colormap("jet")
[cs,h]=m_contour(longitude,latitude,temp_year_m',[-50:10:-10 -5 -2.5:2.5:2.5 7.5:2.5:15],'LabelSpacing',2500,'linewidth',0.5);
clabel(cs,h,'fontsize',13);
[cs2,h2]=m_contour(longitude,latitude,temp_year_m',[-75:80:85],'LabelSpacing',2500,'linewidth',2.2);
clabel(cs2,h2,'fontsize',13);
hold on
m_plot(Core_ils(:,1),Core_ils(:,2),'pr','linewidth',3.5)
m_plot(DR_ils(1,1),DR_ils(1,2),'pk','linewidth',7)
m_plot(Peri_ils(:,1),Peri_ils(:,2),'pb','linewidth',3.5)
hold off
ax=gca;
ax.FontSize = 14;
m_grid('ytick',[-40 -50 -55 -60 -70 -80 -90],'xtick',[0 -90 180 90],'xaxis','top')



figure
m_proj('stereo','lat',-56.5,'long',-70,'radius',4)
% m_proj('lambert','lat',[],'long',-70,'radius',4)
hold on
m_plot(blon_cl,blat_cl,'color',[0.15 0.15 0.15],'linewidth',1)
m_plot(blon_ar,blat_ar,'color',[0.15 0.15 0.15],'linewidth',1)
% m_plot(trench(:,1),trench(:,2),'--black','linewidth',2)%plot de la fosa

% m_pcolor(longitude,latitude,log10(pp_year_m'));
% m_coast('line','color','r');
% title('Yearly accumulated precipitation (1993-2023)')
% ax1=m_contfbar(.97,[.5 .9],pp_year_m', ...
%     [64],'edgecolor','none','endpiece','no');
% title(ax1,{'Rain [mm]',''}); % Move up by inserting a blank line
hold on;
colormap("jet")
[cs,h]=m_contour(longitude,latitude,temp_year_m',[1:1:6],'LabelSpacing',650,'linewidth',1.5);
clabel(cs,h,'fontsize',14);
m_plot(-68.7333,-56.4833,'pk','linewidth',7)
hold off;
ax=gca;
ax.FontSize = 18;
m_grid('ytick',[ -56 -58 -60],'xtick',[-75 -70 -65 -60],'xaxis','top')
%



% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 









































