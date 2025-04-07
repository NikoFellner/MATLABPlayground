function [stab_winkel_rad, stab_winkel_deg] = calculate_angle(koord, konn, num_stab)
stab_anfang_ende = [];
    stab_differenzen = [];
    
    for i=1:num_stab
        %definieren der stab anfangs und endpunkte 
        % [x_anfang x_ende y_anfang y_ende]
        stab_anfang_ende = [stab_anfang_ende; koord(konn(i,1),1),...
            koord(konn(i,2),1),koord(konn(i,1),2),  koord(konn(i,2),2)];
        % berechnen der Stablängen (differenz zwischen anfangs und
        % endpunkt) -> x_ende - x_anfag, y_ende - y_anfang
        stab_differenzen = [stab_differenzen;...
            stab_anfang_ende(i,2)-stab_anfang_ende(i,1), ...
            stab_anfang_ende(i,4)-stab_anfang_ende(i,3)];  
    end
    % berechnen der winkel über die atan2 und die stabdifferenzen 
    % atan2(y = y_ende - y_anfang; x = x_ende - x_anfag)
    % ergebnis in rad, für Grad muss der Faktor 180°/pi berücksichtigt
    % werden
    stab_winkel_rad = atan2(stab_differenzen(:,2), stab_differenzen(:,1));
    stab_winkel_deg = stab_winkel_rad *180/pi;
end