function [X, V] = generer_signal_bruite(S,Fs,RSB)
% g�n�re un signal bruit� X � partir d'une source s : x = s+v
% attention : RSB d�fini en dB et non en lin�aire

if size(S,1)~=1 && size(S,2)~=1
    error('Erreur : S n"est pas un vecteur !');
end


nS = length(S);    %nombre d'�chantillons de la source S
pS = var(S);        % puissance de la source
pB = pS*10^((-RSB)/10); %puissance du bruit

if size(S,1)==1
    V = sqrt(pB)*randn(1,nS);  %g�n�ration du bruit V en ligne

else if size(S,2)==1
    V = sqrt(pB)*randn(nS,1);  %g�n�ration du bruit V en colonne

else
    error('probleme de dimension');
    end
end


X = S+V;                    %g�n�ration du signal bruit� X
end
