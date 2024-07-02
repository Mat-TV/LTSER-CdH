% Programa para procesar datos de era5
% 2024/05/16 MA T-V 
% https://github.com/Mat-TV
aseo
%
%% Preámbulo
cd 'C:\Users\fredo\OneDrive\Documents\CHIC\Entorno\datos\ERA5'
nombre = 'PP_Month_NC.nc';
a = ncread(nombre);%,'headerlines',3); %,'Format','%s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%s');
%
fechas = datetime(a{:,1},'inputformat','dd-MMM-uuuu');
datos = a{:,2};
% a.Month = month(fecha);
%
%% Previsualización
figure
    bar(fechas,datos,'linewidth',5)












