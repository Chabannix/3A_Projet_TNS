function spectres_3filtres(N, nomFiltre1,num1, denom1,nomFiltre2,num2,denom2,nomFiltre3,num3,denom3,option,numeroFigure)
% N : nombre de points pour le calcul de la r�ponse fr�quentielle
% numW : num�rateur du filtre
% A1 : d�nominateur du filtre
% option : str qui vaut 'hold on' si on garde toutes les traces des r�ponses lors d'une boucle
%                       'hold off' si on fait �voluer la courbe avec la boucle
% numeroFigure : num�ro de la figure g�n�r�e



if strcmp(option,'hold on')==0 && strcmp(option,'hold off')==0
    error('erreur : option doit valoir "hold on" ou "hold off"');
end


figure(numeroFigure);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%   1er filtre   %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


[h,w]=freqz(num1,denom1,N);
modh=20*log10(abs(h));
phaseh=unwrap(angle(h));
f=w/(2*pi);

%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(2,3,1)
plot(f,modh)
str = {nomFiltre1,'R�ponse en amplitude'};
title(str,'FontSize',14);

xlabel('fr�quences num�riques');
ylabel('module');
ylim([-50 30]);
xlim([0 0.5]);
grid on
if strcmp(option,'hold on')==1
    hold on;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(2,3,4)
plot(f,phaseh)
str = {nomFiltre1,'R�ponse en phase'};
title(str,'FontSize',14);

xlabel('fr�quences num�riques');
ylabel('phase');
ylim([-3 3]);
xlim([0 0.5]);
grid on

if strcmp(option,'hold on')==1
    hold on;
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%   2�me filtre   %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


[h,w]=freqz(num2,denom2,N);
modh=20*log10(abs(h));
phaseh=unwrap(angle(h));
f=w/(2*pi);

%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(2,3,2)
plot(f,modh)
str = {nomFiltre2,'R�ponse en amplitude'};
title(str,'FontSize',14);

xlabel('fr�quences num�riques');
ylabel('module');
ylim([-50 30]);
xlim([0 0.5]);
grid on
if strcmp(option,'hold on')==1
    hold on;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(2,3,5)
plot(f,phaseh)
str = {nomFiltre2,'R�ponse en phase'};
title(str,'FontSize',14);

xlabel('fr�quences num�riques');
ylabel('phase');
ylim([-3 3]);
xlim([0 0.5]);
grid on

if strcmp(option,'hold on')==1
    hold on;
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%   3�me filtre   %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


[h,w]=freqz(num3,denom3,N);
modh=20*log10(abs(h));
phaseh=unwrap(angle(h));
f=w/(2*pi);

%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(2,3,3)
plot(f,modh)
str = {nomFiltre3,'R�ponse en amplitude'};
title(str,'FontSize',14);

xlabel('fr�quences num�riques');
ylabel('module');
ylim([-50 30]);
xlim([0 0.5]);
grid on
if strcmp(option,'hold on')==1
    hold on;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(2,3,6)
plot(f,phaseh)
str = {nomFiltre3,'R�ponse en phase'};
title(str,'FontSize',14);

xlabel('fr�quences num�riques');
ylabel('phase');
ylim([-3 3]);
xlim([0 0.5]);
grid on

if strcmp(option,'hold on')==1
    hold on;
end
end