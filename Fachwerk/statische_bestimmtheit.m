function [freiheitsgrad, freiheitsgrad_ausen, freiheitsgrad_innen] = statische_bestimmtheit(num_knoten, num_auflage, num_stab)
% Formel für die Statische Bestimmtheit: 
% f = 2*num_knoten -(num_auflage + num_stäbe)

freiheitsgrad = 2*num_knoten -(num_auflage + num_stab);

% Bestimmung des äußeren Freiheitsgrades
% fa = 3 - num_auflage

freiheitsgrad_ausen = 3 - num_auflage;

% Bestimmung des innenen Freiheitsgrades
% fi = freiheitsgrad - freiheitsgrad_ausen

freiheitsgrad_innen = freiheitsgrad - freiheitsgrad_ausen;
end