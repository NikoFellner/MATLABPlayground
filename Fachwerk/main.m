%% Aufgabe 2: Einladen der Daten
% get filename
filename = uigetfile();
%filename = "Fachwerk_3.mat";

% load the chosen file
input = load(filename);

% Konnektivität der einzelnen Knoten -> Stabanzahl [Knoten1 Knoten2]
konn = input.konn;
size_konn = size(konn);
num_stab = size_konn(1); %Anzahl der Stäbe

% Position und der Knoten und Längeninformation der Stäbe [pos1=x,pos2=y]
koord = input.koord;
size_koord = size(koord);
num_knoten = size_koord(1); %Anzahl der knoten

% Position der Lager und Ordnung der Lager
% e.g. [3 1] : Lager an Knoten 3, Kraftaufnahme in x-Richtung
% e.g. [3 2] : Lager an Knoten 3, Kraftaufnahme in y-Richtung
lager = input.lager;
size_lager = size(lager);
num_lager = size_lager(1);

% Knoten an denen die Kraft F wirkt, e.g. [Knoten=1, Fx=0, Fy=1]
F = input.F;
size_forces = size(F);
num_forces = size_forces(1);

%% Aufgabe 3: Visualisieren des Fachwerks
fprintf("Plot timbering.\n")
plot_Fachwerk(konn, num_knoten, F, num_forces, koord, num_stab, lager, num_lager, filename);

%% Aufgabe 4: prüfen der Bedingung für statische Bestimmtheit
fprintf("Check static certainty.\n")
[f, fa, fi] = statische_bestimmtheit(num_knoten, num_lager, num_stab);

if f == 0
    %% Aufgabe 5: bestimmen der Winkel zwischen den Stäben
    fprintf("Calculating angles.\n")
    [stab_winkel_rad, stab_winkel_deg] = calculate_angle(koord, konn, num_stab);

    %% Aufgabe 6: Erstellen und Lösen des Linearen Gleichungssystem
    %dimension of the array [num_knoten num_stäbe+num_lager]
    fprintf("Creating linear system of equations.\n")
    [lineares_Gleichungssystem, force_vector] = generate_linearsystem_equations(stab_winkel_deg, konn, num_knoten, num_lager, lager, F, num_forces, num_stab);
    
    result = -inv(lineares_Gleichungssystem) * force_vector;
    %result2 = lineares_Gleichungssystem\force_vector;

    %% Aufgabe 7: Plotten der Ergebnisse
    fprintf("Plotting results.\n")
    plot_fachwerk_result(konn, num_knoten, F, num_forces, koord, num_stab, lager, num_lager, filename, result);
    
    %% Aufgabe 8: Speichern der Ergebnisse
    fprintf("Saving Data.\n")
    save_Ergebnisse(input, filename, result, f, fa, fi, stab_winkel_deg, lineares_Gleichungssystem, force_vector);

    fprintf("All data saved. End of Script.\n")
else
    warning("Die Bedingung f=0 ist für das gegebene System nicht erfüllt, dass Script wird beendet!");
    
    result = 'None';
    stab_winkel_deg = 'None';
    force_vector = 'None';
    lineares_Gleichungssystem = 'None';
    save_Ergebnisse(input, filename, result, f, fa, fi, stab_winkel_deg, lineares_Gleichungssystem, force_vector);
end
clear;