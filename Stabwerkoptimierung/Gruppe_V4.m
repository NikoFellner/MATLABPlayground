clear;
clc;


%% Aufgabe 1
load("V4_Input_Stabwerk.mat");
size_konn = size(konn);
num_stab = size_konn(1); %Anzahl der Stäbe

% Position und der Knoten und Längeninformation der Stäbe [pos1=x,pos2=y]
size_koord = size(koord);
num_knoten = size_koord(1); %Anzahl der knoten

% Position der Lager und Ordnung der Lager
% e.g. [3 1] : Lager an Knoten 3, Kraftaufnahme in x-Richtung
% e.g. [3 2] : Lager an Knoten 3, Kraftaufnahme in y-Richtung
size_lager = size(lager);
num_lager = size_lager(1);

% Knoten an denen die Kraft F wirkt, e.g. [Knoten=1, Fx=0, Fy=1]
size_forces = size(F);
num_forces = size_forces(1);

plot_Fachwerk(konn, num_knoten, F, num_forces, koord, num_stab, lager, num_lager)
hold on
parameter.E = 3 ;%kN/mm²
parameter.b = ones([num_stab,1]).*5; %mm
parameter.d = ones([num_stab,1]).*5; %mm
x_ax = zeros([num_knoten,1]);
y_ax = zeros([num_knoten,1]);

EA = ones([num_stab,1]).*(parameter.E.*parameter.b.*parameter.d);

[u,S] = Stabtragwerk(EA,num_knoten,num_stab,koord,konn,lager,F);

for i=1:num_knoten
    x_ax(i) = koord(i,1)+u(2*i-1);
    y_ax(i) = koord(i,2)+u(2*i);
end

plot_Fachwerk2(konn, num_knoten, F, num_forces, koord, num_stab, lager, num_lager, [x_ax,y_ax],2, ones([num_stab,1]));


%% Aufgabe 2
parameter.lowerbound = ones([num_stab,1]).*0.01 ;
parameter.upperbound = ones([num_stab,1]).*5;

x_start = rand([num_stab,1]);

u_F = Zielfunktion(x_start, EA, num_knoten, num_stab, koord, konn, lager, F, num_forces);

[x_opt, uF] = fmincon(@(x_opt)Zielfunktion(x_opt, EA, num_knoten, num_stab, koord, konn, lager, F, num_forces), ...
    x_start,[],[],[],[],parameter.lowerbound,parameter.upperbound, []);

[u,S] = Stabtragwerk(x_opt.*EA,num_knoten,num_stab,koord,konn,lager,F);
for i=1:num_knoten
    x_ax(i) = koord(i,1)+u(2*i-1);
    y_ax(i) = koord(i,2)+u(2*i);
end

plot_Fachwerk2(konn, num_knoten, F, num_forces, koord, num_stab, lager, num_lager, [x_ax,y_ax],3, x_opt);

%% Aufgabe 3
Aeq = transpose(EA);
beq = 825;

[x_opt2, uF2] = fmincon(@(x_opt2)Zielfunktion(x_opt2, EA, num_knoten, num_stab, koord, konn, lager, F, num_forces), ...
    x_start,[],[],Aeq,beq,parameter.lowerbound,parameter.upperbound, []);

[u,S] = Stabtragwerk(x_opt2.*EA,num_knoten,num_stab,koord,konn,lager,F);
for i=1:num_knoten
    x_ax(i) = koord(i,1)+u(2*i-1);
    y_ax(i) = koord(i,2)+u(2*i);
end

plot_Fachwerk2(konn, num_knoten, F, num_forces, koord, num_stab, lager, num_lager, [x_ax,y_ax],4, x_opt2);

%% Aufgabe 4
[u,S] = Stabtragwerk(x_start.*EA,num_knoten,num_stab,koord,konn,lager,F);
A = parameter.b.*parameter.d;
[x_opt3, uF3] = fmincon(@(x_opt3)Zielfunktion(x_opt3, EA, num_knoten, num_stab, koord, konn, lager, F, num_forces), ...
    x_start,[],[],[],[],parameter.lowerbound,parameter.upperbound, @(x_opt3)Nebenbedingungen(x_opt3,A,EA,S));

[u,S] = Stabtragwerk(x_opt3.*EA,num_knoten,num_stab,koord,konn,lager,F);

for i=1:num_knoten
    x_ax(i) = koord(i,1)+u(2*i-1);
    y_ax(i) = koord(i,2)+u(2*i);
end

plot_Fachwerk2(konn, num_knoten, F, num_forces, koord, num_stab, lager, num_lager, [x_ax,y_ax],5, x_opt3);

%% Aufgabe 5

options = optimoptions(@fmincon,'Display','iter','Algorithm','sqp');
[x_opt4, uF4] = fmincon(@(x_opt4)Zielfunktion(x_opt4, EA, num_knoten, num_stab, koord, konn, lager, F, num_forces), ...
    x_start,[],[],[],[],parameter.lowerbound,parameter.upperbound, @(x_opt4)Nebenbedingungen(x_opt4,A,EA,S), options);

[u,S] = Stabtragwerk(x_opt4.*EA,num_knoten,num_stab,koord,konn,lager,F);

for i=1:num_knoten
    x_ax(i) = koord(i,1)+u(2*i-1);
    y_ax(i) = koord(i,2)+u(2*i);
end

plot_Fachwerk2(konn, num_knoten, F, num_forces, koord, num_stab, lager, num_lager, [x_ax,y_ax],6, x_opt4);

options = optimoptions(@fmincon,'Display','iter','Algorithm','sqp','MaxIterations',3);

[x_opt41, uF41] = fmincon(@(x_opt41)Zielfunktion(x_opt41, EA, num_knoten, num_stab, koord, konn, lager, F, num_forces), ...
    x_start,[],[],[],[],parameter.lowerbound,parameter.upperbound, @(x_opt41)Nebenbedingungen(x_opt41,A,EA,S), options);

[u,S] = Stabtragwerk(x_opt41.*EA,num_knoten,num_stab,koord,konn,lager,F);

for i=1:num_knoten
    x_ax(i) = koord(i,1)+u(2*i-1);
    y_ax(i) = koord(i,2)+u(2*i);
end

plot_Fachwerk2(konn, num_knoten, F, num_forces, koord, num_stab, lager, num_lager, [x_ax,y_ax],7, x_opt41);

options = optimoptions(@fmincon,'Display','iter','Algorithm','sqp-legacy','MaxIterations',7);

[x_opt42, uF42] = fmincon(@(x_opt42)Zielfunktion(x_opt42, EA, num_knoten, num_stab, koord, konn, lager, F, num_forces), ...
    x_start,[],[],[],[],parameter.lowerbound,parameter.upperbound, @(x_opt42)Nebenbedingungen(x_opt42,A,EA,S), options);

[u,S] = Stabtragwerk(x_opt42.*EA,num_knoten,num_stab,koord,konn,lager,F);

for i=1:num_knoten
    x_ax(i) = koord(i,1)+u(2*i-1);
    y_ax(i) = koord(i,2)+u(2*i);
end

plot_Fachwerk2(konn, num_knoten, F, num_forces, koord, num_stab, lager, num_lager, [x_ax,y_ax],8, x_opt42);

%% Function for plot
function plot_Fachwerk(konn, num_knoten, F, num_forces, koord, num_stab, lager, num_lager)
    figure(1)
    x = koord(:,1);
    y = koord(:,2);
    hold on
    %Beschriftung und plotten der Stäbe
    for i=1:num_stab
        p1 = plot([x(konn(i,1)) x(konn(i,2))], [y(konn(i,1)) y(konn(i,2))], 'o-k', 'Color','b');        
        x_koord_text = (x(konn(i,1))+x(konn(i,2)))/2;
        y_koord_text = (y(konn(i,1))+y(konn(i,2)))/2;    
        text(x_koord_text-0.1, y_koord_text+0.1, string(i), 'Color',[0 0 1]);
    end
    
    
    %Beschriftung und plotten der Knoten
    for i=1:num_knoten
        p2 = plot(koord(i,1), koord(i,2), 'o', 'linewidth',1.5, 'Color',[0 0 0]);
        name_knoten = "Knoten " + i;
        text(koord(i,1),koord(i,2)-0.1, name_knoten);
    end
    
    %Beschriftung und plotten der Kräfte 
    for i=1:num_forces
        knoten_force = F(i,1);
        koord_force_x = koord(knoten_force, 1);
        koord_force_y = koord(knoten_force, 2);
        p3 = quiver(koord_force_x, koord_force_y, F(i,2), F(i,3), "MaxHeadSize", 1/norm(F(:,2:3)), 'LineWidth', 1.5, 'Color', [1 0 0]);
        name_Force = "Force" + i;
        text(koord_force_x,koord_force_y-0.5, name_Force, 'Color', [1 0 0]);
    end
    
    %Beschriftung und plotten der Lager
    for i=1:num_lager
        koord_lager_x = koord(lager(i,1),1);
        koord_lager_y = koord(lager(i,1),2);
        if lager(i,2)==1
            p4 = plot(koord_lager_x, koord_lager_y-0.01, '>','linewidth', 2, 'Color', [1 0.7 0]);
        else
            p4 = plot(koord_lager_x-0.1, koord_lager_y, '^', 'linewidth', 2, 'Color', [1 0.7 0]);
        end
    end
    


    %Legende, Titel, Achsenbeschriftung erstellen
    legend([p1, p2, p3, p4], "Stab", "Knoten", "Kräfte", "Lager", 'Location', 'eastoutside');
    grid on
    xlabel('x');
    ylabel('y');
    xlim('padded');
    ylim('padded');
end

function plot_Fachwerk2(konn, num_knoten, F, num_forces, koord, num_stab, lager, num_lager, deformed_koord, fig_nr, scale)
    figure(fig_nr)
    x = koord(:,1);
    y = koord(:,2);
    x_deformed = deformed_koord(:,1);
    y_deformed = deformed_koord(:,2);
    hold on
    %Beschriftung und plotten der Stäbe
    for i=1:num_stab
        p1 = plot([x(konn(i,1)) x(konn(i,2))], [y(konn(i,1)) y(konn(i,2))], 'o-k', 'Color','b');
        p5 = plot([x_deformed(konn(i,1)) x_deformed(konn(i,2))], [y_deformed(konn(i,1)) y_deformed(konn(i,2))], 'o-k', 'Color','m', 'LineWidth',scale(i));
        x_koord_text = (x(konn(i,1))+x(konn(i,2)))/2;
        y_koord_text = (y(konn(i,1))+y(konn(i,2)))/2;    
        text(x_koord_text-0.1, y_koord_text+0.1, string(i), 'Color',[0 0 1]);
    end
    
    
    %Beschriftung und plotten der Knoten
    for i=1:num_knoten
        p2 = plot(koord(i,1), koord(i,2), 'o', 'linewidth',1.5, 'Color',[0 0 0]);
        name_knoten = "Knoten " + i;
        text(koord(i,1),koord(i,2)-0.1, name_knoten);
    end
    
    %Beschriftung und plotten der Kräfte 
    for i=1:num_forces
        knoten_force = F(i,1);
        koord_force_x = koord(knoten_force, 1);
        koord_force_y = koord(knoten_force, 2);
        p3 = quiver(koord_force_x, koord_force_y, F(i,2), F(i,3), "MaxHeadSize", 1/norm(F(:,2:3)), 'LineWidth', 1.5, 'Color', [1 0 0]);
        name_Force = "Force" + i;
        text(koord_force_x,koord_force_y-0.5, name_Force, 'Color', [1 0 0]);
    end
    
    %Beschriftung und plotten der Lager
    for i=1:num_lager
        koord_lager_x = koord(lager(i,1),1);
        koord_lager_y = koord(lager(i,1),2);
        if lager(i,2)==1
            p4 = plot(koord_lager_x, koord_lager_y-0.01, '>','linewidth', 2, 'Color', [1 0.7 0]);
        else
            p4 = plot(koord_lager_x-0.1, koord_lager_y, '^', 'linewidth', 2, 'Color', [1 0.7 0]);
        end
    end
    


    %Legende, Titel, Achsenbeschriftung erstellen
    legend([p1, p2, p3, p4, p5], "Stab", "Knoten", "Kräfte", "Lager", "belastete/optimierte Stäbe", 'Location', 'eastoutside');
    grid on
    xlabel('x');
    ylabel('y');
    xlim('padded');
    ylim('padded');
end