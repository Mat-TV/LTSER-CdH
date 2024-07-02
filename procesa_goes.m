% Programa para procesar salidas de la estación meteorológica Campbell 
% que transmite sus datos a través del satélite GOES de la NOAA
% 2023/02/14 MA T-V 
% https://github.com/Mat-TV
aseo
%% Preámbulo
cd 'C:\Users\fredo\OneDrive\Documents\CHIC\Entorno'\datos\
nombre = 'Compendio_general_editado.xlsx'
% nombre = 'Compendio_GOESCH_20230619.xlsx'
a = readtable(nombre);%,'headerlines',3); %,'Format','%s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%s');
fechas = datenum(a{:,1},'mm/dd/yyyy HH:MM:SS');
b = readtable('Compendio_general_editado_datos.xlsx');%
datos = cell2mat(table2cell(b));

%
% nombre = 'Fechas_20230619.xlsx'
% b = readtable(nombre);%,'headerlines',3); %,'Format','%s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%s');
% a2= readtable('CompendioExport_20230328_fecha');
% Extraer datos que no interesan
% a(:,[1:8 10:17]) = [];
%
% Antes de pasarlo a celda hay que eliminar las columnas que no son datos
% [25,+inf[
% datos = cell2mat(table2cell(a{:,2:end}));
% fechas = datenum(b{:,1},'mm/dd/yyyy HH:MM:SS');
[fechas,I] = sort(fechas)
datos = datos(I,:)
  % writecell([fechas,datos], 'listo_20230829.csv')
datos(find(datos==9999))=NaN;
[b,c]=sort(fechas);
d = datos(c,:);
Tabla = table(datestr(b),d);
    % writetable(Tabla, 'Compendio_GOESCH_20230829.xlsx')

fechas = b;
datos = d;
clear a b c d a2 nombre Tabla ans
%
%% Pre-visualización
figure(1)
for i=1:length(datos(1,:))
    subplot(4,5,i)
    plot(fechas,datos(:,i))
    datetick('x', 'dd-mmm','keepticks')
    axis tight
    grid minor
end
%
%  find(datos(:,7)==[1206] | [1069] | [810])
%
%% Visualización
% Conversiones
 contracorreccion_presion =(1-(0.0065*2/(15+273.15+0.0065*2)))^(-5.257)
 correccion_presion=(1-(0.0065*215/(15+273.15+0.0065*215)))^(-5.257)
albedo=(datos(:,12)+datos(:,14))./(datos(:,11)+datos(:,13))
albedo = datos(:,16)./datos(:,15)
% VOLTAJE Y TEMPERATURA DATALOGGER
figure
 yyaxis left
plot(fechas,datos(:,1),'k','linewidth',2.5)
ylabel('Voltaje [V]')
 yyaxis right
plot(fechas,datos(:,2),'r','linewidth',2.5)
ylabel('Temperatura [°]')
title('Voltaje y temperatura datalogger')
axis tight
grid minor
xlabel('Fecha')
legend('Voltaje','Temperatura')
datetick('x', ' dd/mmm','keepticks')
 ax=gca;
 ax.FontSize = 20;
% PRESIÓN
figure
plot(fechas,datos(:,3)/contracorreccion_presion*correccion_presion,'k','linewidth',2.5)
title('Presión')
axis tight
grid minor
xlabel('Fecha')
ylabel('Presión al nivel del mar [hPa]')
datetick('x', ' dd/mmm','keepticks')
 ax=gca;
 ax.FontSize = 20;
% TEMPERATURA Y HUMEDAD RELATIVA
figure
 yyaxis left
plot(fechas,datos(:,5),'k','linewidth',2.5)
ylabel('Temperatura [°C]')
 yyaxis right
plot(fechas,datos(:,4),'r','linewidth',2.5)
ylabel('Humedad Relativa [%]')
title('Temperatura y HR')
axis tight
grid minor
xlabel('Fecha')
legend('Temperatura','Humedad Relativa')
datetick('x', ' dd/mmm','keepticks')
 ax=gca;
 ax.FontSize = 20;
% RAPIDEZ DEL VIENTO
figure
plot(fechas,datos(:,7),'k','linewidth',2.5)
title('Velocidad del viento')
axis tight
grid minor
xlabel('Fecha')
ylabel('Velocidad del viento [kmh]')
datetick('x', ' dd/mmm','keepticks')
 ax=gca;
 ax.FontSize = 20;
% PRECIPITACIÓN
figure
plot(fechas,datos(:,10),'k','linewidth',2.5)
title('Precipitación')
axis tight
grid minor
xlabel('Fecha')
ylabel('Lluvia [mm]')
datetick('x', ' dd/mmm','keepticks')
 ax=gca;
 ax.FontSize = 20;
% RADIACIÓN Y ALBEDO
figure
 yyaxis left
plot(fechas,datos(:,18),'k','linewidth',2.5)
ylabel('Radiación [W/m^2]')
 yyaxis right
plot(fechas,datos(:,17),'r','linewidth',2.5)
ylabel('Albedo [W/m^2]')
title('Radiación neta y albedo')
axis tight
grid minor
xlabel('Fecha')
legend('Radiación','Albedo')
datetick('x', ' dd/mmm','keepticks')
 ax=gca;
 ax.FontSize = 20;
% TEMPERATURAS DEL SUELO
figure
plot(fechas,datos(:,21),'k',fechas,datos(:,24),'r','linewidth',2.5)
title('Temperatura del suelo')
axis tight
grid minor
xlabel('Fecha')
ylabel('Temperatura [°C]')
legend('Sitio 1', 'Sitio 2')
datetick('x', ' dd/mmm','keepticks')
 ax=gca;
 ax.FontSize = 20;
% CONTENIDO VOLUMÉTRICO DE AGUA
figure
plot(fechas,datos(:,21),'k','linewidth',2.5)
title('Contenido volumétrico de agua')
axis tight
grid minor
xlabel('Fecha')
ylabel('Contenido de agua [m^3/m^3]')
datetick('x', ' dd/mmm','keepticks')
 ax=gca;
 ax.FontSize = 20;
 
%% Subplot
figure
 subplot(2,3,1)
plot(fechas,datos(:,3)/contracorreccion_presion*correccion_presion,'k','linewidth',2.2)
title('Presión')
axis tight
grid minor
% xlabel('Fecha')
ylabel('Presión al nivel del mar [hPa]')
xticks([738950,738975,739000,739 025,739050])
datetick('x', ' dd/mmm','keepticks')
 ax=gca;
 ax.FontSize = 14;
% TEMPERATURA
 subplot(2,3,2)
 % yyaxis left
plot(fechas,datos(:,5),'k','linewidth',2)
ylabel('Temperatura [°C]')
 % yyaxis right
% plot(fechas,datos(:,4),'r','linewidth',1.2)
% ylabel('Humedad Relativa [%]')
title('Temperatura')
axis tight
grid minor
% xlabel('Fecha')
% legend('Temperatura','Humedad Relativa')
datetick('x', ' dd/mmm','keepticks')
 ax=gca;
 ax.FontSize = 14;
% RAPIDEZ DEL VIENTO
 subplot(2,3,3)
plot(fechas,datos(:,7),'k','linewidth',2.2)
title('Velocidad del viento')
axis tight
grid minor
% xlabel('Fecha')
ylabel('Velocidad del viento [kmh]')
datetick('x', ' dd/mmm','keepticks')
 ax=gca;
 ax.FontSize = 14;
% HUMEDAD RELATIVA
 subplot(2,3,4)
plot(fechas,datos(:,4),'k','linewidth',2.2)
title('Humedad relativa')
axis tight
grid minor
% xlabel('Fecha')
ylabel('Humedad Relativa [%]')
datetick('x', ' dd/mmm','keepticks')
 ax=gca;
 ax.FontSize = 14;
% RADIACIÓN Y ALBEDO
 subplot(2,3,5)
 yyaxis left
plot(fechas,datos(:,18),'k','linewidth',2)
ylabel('Radiación [W/m^2]')
 yyaxis right
plot(fechas,datos(:,17),'r','linewidth',1.2)
ylabel('Albedo [W/m^2]')
title('Radiación neta y albedo')
axis tight
grid minor
xlabel('Fecha')
legend('Radiación','Albedo')
datetick('x', ' dd/mmm','keepticks')
 ax=gca;
 ax.FontSize = 14;
% TEMPERATURAS DEL SUELO
 subplot(2,3,6)
plot(fechas,datos(:,21),'k',fechas,datos(:,24),'r','linewidth',1.2)
title('Temperatura del suelo')
axis tight
grid minor
% xlabel('Fecha')
ylabel('Temperatura [°C]')
legend('Sitio 1', 'Sitio 2')
datetick('x', ' dd/mmm','keepticks')
 ax=gca;
 ax.FontSize = 14;


