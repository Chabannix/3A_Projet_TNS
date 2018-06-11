function spectres_1filtre(N, nomFiltre, numW, A1,option,numeroFigure)
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

[h,w]=freqz(numW,A1,N);
modh=20*log10(abs(h));
phaseh=unwrap(angle(h));
f=w/(2*pi);

%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(2,1,1)
plot(f,modh)
str = {nomFiltre,'R�ponse en amplitude'};
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
subplot(2,1,2)
plot(f,phaseh)
str = {nomFiltre,'R�ponse en phase'};
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