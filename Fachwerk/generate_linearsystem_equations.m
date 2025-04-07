function [lineares_Gleichungssystem, force_vector] = generate_linearsystem_equations(stab_winkel_deg, konn, num_knoten, num_lager, lager,F, num_forces, num_stab)
    
    % forces kann in der Dimension [num_knoten*2, num_stäbe] deklariert
    % werden, der einfachheit halber wurde hier eine leere Matrix erstellt
    % und die jeweiligen Kraftgleichungen angeheftet
    forces = zeros(num_knoten*2,num_stab);
    % bestimmen der cos und sinus werte für jeden Stab in rad
    cos_stab = cos(stab_winkel_deg*pi/180);
    sin_stab = sin(stab_winkel_deg*pi/180);

    % bestimmen der Kräftegleichungen und füllen des force arrays
    for i=1:num_knoten
        % Bestimmen der Stäbe an den jeweiligen Knoten
        % steht die Zahl des Stabes an erster Stelle in der "konn"-variable, 
        % geht der Stab positiv in die Berechnung ein, in der zweiten
        % spalte muss das Vorzeichen umgekehrt werden
        % anschließend wird der für die jeweilige Achse zugrundeliegende
        % Winkel berücksichtigt : cos für x, sin für y
        % aussortieren von werten die gegen 0 gehen
        stab_an_Knoten = [[konn(:,1)==i] + -1*[konn(:,2)==i]]';
        Fx = stab_an_Knoten .* cos_stab';
        Fx2(:,find((Fx>0 & Fx<10e-9) | (Fx<0 & Fx>-10e-9)))=0;

        Fy = stab_an_Knoten .* sin_stab';
        Fy(:,find((Fy>0 & Fy<10e-9) | (Fy<0 & Fy>-10e-9)))=0;
        forces(i*2-1:i*2,:) = [Fx; Fy];
    end

    % erstellen der Lagerreaktionen
    lager_reaktion = zeros(num_knoten*2,num_lager);
    for i=1:num_lager
        % Wenn die Auflagerreaktion Horizontal ist, dann steht sie in der
        % ersten Zeile der Knotengleichung
        if lager(i,2) == 1
            lager_reaktion(lager(i,1)*2-1,i) = 1;
        elseif lager(i,2) == 2
            lager_reaktion(lager(i,1)*2,i) = 1;
        end
    end
    
    % erstellen des Kraftvektors
    lineares_Gleichungssystem = [lager_reaktion, forces];
    force_vector = zeros(num_knoten*2, 1);
    for i=1:num_forces
        force_vector(F(i,1)*2-1,1) = F(i,2);
        force_vector(F(i,1)*2,1) = F(i,3);
    end


end