% Programa para procesar salidas del sistema Eddy covariance
% 2023/06/05 MA T-V 
% https://github.com/Mat-TV
aseo
%% Preámbulo
cd 'C:\Users\fredo\OneDrive\Documents\CHIC\Entorno\datos'
% nombre = 'eddypro_omora-peatland_biomet_2023-06-01';
nombre = 'agrometeorologia-2022.xlsx'
a = readtable(nombre);%,'headerlines',3); %,'Format','%s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%s');
%
fechas = datetime([string(datetime(a.Column1,'Format','yyyy-MM-dd')) + " " + string(datetime(a.Column2,'Format','HH:mm'))])

lluvia = [a(:,14)];% datos( )
lluvia.Column14(lluvia.Column14 == -9999)=NaN
%
%% Pre-visualización
figure(1)
subplot(2,1,1)
    plot(fechas,lluvia.Column14.*1000,'linewidth',2.5)
    title('Precipitación acumulada cada media hora: Turbera')
    grid minor
    axis tight
    ax=gca;
    ax.FontSize = 16;
subplot(2,1,2)
    plot(a.Var2,'linewidth',2.5)
    title('Precipitación acumulada cada día: Aeropuerto')
    ylabel('Precipitación [mm]')
    xlabel('Fecha')
    ax=gca;
    ax.FontSize = 16;
    grid minor
    axis tight
%
%% Guardado
Tabla = table(fechas,lluvia.Column14.*1000,'VariableNames',{'Fecha','Precipitacion_mm'});
    writetable(Tabla, 'Precipitacion_Turbera.xlsx')