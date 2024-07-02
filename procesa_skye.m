% Programa para procesar salidas de la estación UV SkyeLynx
% 2022/11/23 MA T-V 
% https://github.com/Mat-TV
aseo
%% Preámbulo
cd 'C:\Users\fredo\OneDrive\Documents\CHIC\Entorno\datos/SkyE/'
nombre = 'datahog_20240201_compilado';
a = readtable(nombre);%,'headerlines',3); %,'Format','%s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%s');
%
fechas(:,1) = datetime([char(a{:,2}) + " " + char(a{:,1})]);
dato1 = double(strrep(string(table2cell(a(:,4))),',','.'));
dato2 = double(strrep(string(table2cell(a(:,6))),',','.'));
datos = [dato1,dato2];
clear dato1 dato2 a
% datos( )
%
%% Pre-visualización
figure
    plot(fechas,datos(:,1),'k*-',fechas,datos(:,2),'r*-','linewidth',2.5)
    title('Radiación UV: turbera')
    ylabel('Radiación [W/m^2]')
    datetick('x', 'dd/mmm','keepticks')
    xticks([datetime('2022-12-21') datetime('2023-03-21') datetime('2023-06-21') datetime('2023-09-21') datetime('2023-12-21')])
    xticklabels({'21 Dic 2022', '21 Mar 2023','21 Jun','21 Sep','21 Dic'})
    legend('UV-A','UV-B','location','northwest')
    axis tight
    grid minor
    ax=gca;
    ax.FontSize = 20;
%
%% Corregir NaNs manual (subjetivo)
cuantosnan(datos) % 2831 datos faltantes luego de la limpieza
%fx disponible en: https://github.com/Mat-TV/MATLAB_useful/blob/main/cuantosnan.m
%
%%
% Tabla = table(fechas,datos(:,1),datos(:,2),'VariableNames',{'Fecha','UVa','UVb'});
%     writetable(Tabla, 'RadiacionUV_Turbera.xlsx')
%
%% Proceso
% % Media móvil
% [time_movil,mediamovil,desviacionmovil] = DatosMoviles([datenum(fechas) datos(:,1)],50);
%
dias_medicion = datetime(year(fechas(1)),month(fechas(1)),day(fechas(1))):datetime(year(fechas(end)),month(fechas(end)),day(fechas(end)));
% Máxima diaria
c=1;
for i = dias_medicion
    este_dia = find(datetime([year(fechas),month(fechas),day(fechas)]) == i);
    if isempty(este_dia)
        maxim_A(c) = NaN;
        maxim_B(c) = NaN;
    else
        maxim_A(c) = max(datos(este_dia,1));
        maxim_B(c) = max(datos(este_dia,2));
    end
    c=c+1;
end
%
figure
plot(dias_medicion(4:end),maxim_A(4:end),dias_medicion(4:end),maxim_B(4:end),'linewidth',2.5)
    title('Máxima diaria radiación UV: turbera')
    ylabel('Radiación [W/m^2]')
    datetick('x', 'dd/mmm','keepticks')
    xticks([datetime('2022-12-21') datetime('2023-03-21') datetime('2023-06-21') datetime('2023-09-21') datetime('2023-12-21')])
    xticklabels({'21 Dic 2022', '21 Mar 2023','21 Jun','21 Sep','21 Dic'})
    legend('UV-A','UV-B','location','northwest')
    axis tight
    grid minor
    ax=gca;
    ax.FontSize = 20;
%
% Acumulado diario
c=1;
for i = dias_medicion
    este_dia = find(datetime([year(fechas),month(fechas),day(fechas)]) == i);
    if isempty(este_dia)
        acum_A(c) = NaN;
        acum_B(c) = NaN;
    else
        acum_A(c) = sum(datos(este_dia,1))/144*6;
        acum_B(c) = sum(datos(este_dia,2))/144*6;
    end
    c=c+1;
end
figure
plot(dias_medicion(4:end),acum_A(4:end),dias_medicion(4:end),acum_B(4:end),'linewidth',2.5)
    title('Acumulado (24 horas) diario radiación UV: turbera')
    ylabel('Radiación por hora [W/m^2 /h]')
    datetick('x', 'dd/mmm','keepticks')
    xticks([datetime('2022-12-21') datetime('2023-03-21') datetime('2023-06-21') datetime('2023-09-21') datetime('2023-12-21')])
    xticklabels({'21 Dic 2022', '21 Mar 2023','21 Jun','21 Sep','21 Dic'})
    legend('UV-A','UV-B','location','northwest')
    axis tight
    grid minor
    ax=gca;
    ax.FontSize = 20;
%

% mean(acum_A(1:15))
%
clear ans ax c datos este_dia fechas i nombre
close all


corr(acum_A,acum_B,'rows','complete')


% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 