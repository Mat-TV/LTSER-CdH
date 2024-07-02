% Programa para procesar salidas de AQUATROLL 
% 2023/03/22 MA T-V 
% https://github.com/Mat-TV
aseo
%
%% Preproceso y unión datos
cd 'C:\Users\fredo\OneDrive\Documents\CHIC\Entorno\datos/AQUATROLL'
nombre = 'VuSitu_20240702.xlsx';
a = readtable(nombre);%,'headerlines',3); %,'Format','%s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%s');
fechas(:,1) = datenum(a{:,1});
datos = cell2mat(table2cell(a(:,[2:end])));
% LIMPIAR LOS NaN DEL FINAL
% datos(find(datos==9999))=NaN;
% variables = a;
% variables = variables.Properties.VariableNames;
% 
% variables = {'Fecha','pH [pH]','pH [mV]','ORP [mV]','RDO [mg/L]','RDO saturación [%]',...
%     'PP Oxígeno [Torr]','Temperatura [°C]','Voltaje externo [V]','Batería [%]',...
%     'Presión barométrica [mm Hg]','Presión [psi]','Profundidad [cm]'};
% Tabla = table(datestr(fechas),datos(:,1),datos(:,2),datos(:,3),datos(:,4),datos(:,5),datos(:,6),datos(:,7),...
%     datos(:,8),datos(:,9),datos(:,10),datos(:,11),datos(:,12),'VariableNames',{variables{1},variables{2},...
%     variables{3},variables{4},variables{5},variables{6},variables{7},variables{8},variables{9},...
%     variables{10},variables{11},variables{12},variables{13},});
%     writetable(Tabla, "new" + nombre)
%
%% Preámbulo Proceso
% cd 'C:\Users\fredo\OneDrive\Documents\CHIC\Entorno\datos/AQUATROLL'
% nombre = 'Aquatroll_2022ene-2023mar.csv';
% a = readtable(nombre);%,'headerlines',3); %,'Format','%s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%s');
% % Extraer datos que no interesan
% % a(:,[1:8 10:17]) = [];
% %
% fechas(:,1) = datenum(a{:,1});
% datos = cell2mat(table2cell(a(:,[2:end])));
% % datos(find(datos==9999))=NaN;
% % variables = a;
% % variables = variables.Properties.VariableNames;
variables = {'Fecha','pH [pH]','pH [mV]','ORP [mV]','RDO [mg/L]','RDO saturación [%]',...
    'PP Oxígeno [Torr]','Temperatura [°C]','Voltaje externo [V]','Batería [%]',...
    'Presión barométrica [mm Hg]','Presión [psi]','Profundidad [cm]'};
%
%% Pre-visualización
figure
title('Mediciones AQUATROLL Río Róbalo 2022ene-2023mar')
for i=1:length(datos(1,:))
    subplot(3,4,i)
    plot(fechas,datos(:,i),'.','linewidth',1.25)
    title(variables(1+i))
    datetick('x', 'dd/mmm','keepticks')
    if i==9
        axis([fechas(1) fechas(end) 0 100])
    else
        axis tight
    end
    grid minor
    ax=gca;
    ax.FontSize = 16;
end



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