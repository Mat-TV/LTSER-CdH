% Programa para procesar salidas de la estación meteorológica Campbell
% 2022/10/20 MA T-V 
% https://github.com/Mat-TV
aseo
%% Preámbulo
cd 'C:\Users\fredo\OneDrive\Documents\CHIC\Entorno\datos\'
nombre = 'Lakutaia_IEB5.DAT';
a = readtable(nombre);%,'headerlines',3); %,'Format','%s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%s');
% Extraer datos que no interesan
a(:,2) = [];
%
variables = a;
variables = variables.Properties.VariableNames;
fechas(:,1) = datenum(a{:,1});
datos = cell2mat(table2cell(a(:,2:end)));
% datos(1record, 2batería, 3temp_batería, 4temp_C, 5vel_viento, 6dir_viento, 7desv_viento,
%       8rad_corta, 9rad_larga, 10rad_neta, 11total_flujo, 12dens_flujo, 13HR, 14rachas)
% rachas_momentos = datenum(a{:,end});
variables(1,1) = {'FechaYHora'}
%
%
%% Pre-visualización
figure(1)
for i=1:length(datos(1,:))
    subplot(4,5,i)
    plot(fechas,datos(:,i))
    title(variables(1+i))
    datetick('x', 'mm-yyyy','keepticks')
    axis tight
    grid minor
end
%
%% Corregir NaNs manual (subjetivo)
errores = find(datos(:,19)<11.9); % presión
datos(errores,:) = NaN;
% errores = find(datos(:,4)<-40); % temperatura
% datos(errores,:) = NaN;
% errores = find(datos(:,1)>300); % viento
% datos(errores,:) = NaN;
% errores = find(datos(:,6)<-10); % radiación solar
% datos(errores,:) = NaN;
% errores = find(datos(:,16)>10); % precipitación inst.
% datos(errores,:) = NaN;
% errores = find(datos(:,17)<960); % presión
% datos(errores,:) = NaN;
cuantosnan(datos) % 44554 datos faltantes luego de la limpieza
%fx disponible en: https://github.com/Mat-TV/MATLAB_useful/blob/main/cuantosnan.m
%
%%
Tabla = table(datestr(fechas),datos(:,1),datos(:,2),datos(:,3),datos(:,4),datos(:,5),datos(:,6),datos(:,7),...
    datos(:,8),datos(:,9),datos(:,10),datos(:,11),datos(:,12),datos(:,13),datos(:,14),datos(:,15),datos(:,16),...
    datos(:,17),datos(:,18),datos(:,19),'VariableNames',{variables{1},variables{2},...
    variables{3},variables{4},variables{5},variables{6},variables{7},variables{8},variables{9},...
    variables{10},variables{11},variables{12},variables{13},variables{14},variables{15},variables{16},...
    variables{17},variables{18},variables{19},variables{20}});
writetable(Tabla, "Lakutaia_clean.xlsx")


%%