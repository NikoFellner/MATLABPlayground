function plot_fachwerk_result(konn, num_knoten, F, num_forces, koord, num_stab, lager, num_lager, filename, result)
    x = koord(:,1);
    y = koord(:,2);
    figure_name = filename + " - results";
    figure('Name', figure_name, 'NumberTitle','off');
    hold on
    % Beschriftung und plotten der Stäbe
    % erstellen von Plots für alle Stäbe um Fehlermeldungen beim erstellen der
    % Legende zu vermeiden
    p1 = plot(0, 0, 'o', 'linewidth',1.5, 'Color',[1 1 1]);
    p2 = plot(0, 0, 'o', 'linewidth',1.5, 'Color',[1 1 1]);
    p3 = plot(0, 0, 'o', 'linewidth',1.5, 'Color',[1 1 1]);
   

    for i=1:num_stab
        %plot([x(konn(i,1)) x(konn(i,2))], [y(konn(i,1)) y(konn(i,2))], 'o-k','linewidth',1.5, 'Color',[0 0 1]);
        if result(i+num_lager) < 10e-9 && result(i+num_lager)>-10e-9
            %  Nullstab
            p1 = plot([x(konn(i,1)) x(konn(i,2))], [y(konn(i,1)) y(konn(i,2))], 'linewidth',1.5, 'Color','b');
        elseif result(i+num_lager) > 10e-9
            % Zugstab            
            p2 = plot([x(konn(i,1)) x(konn(i,2))], [y(konn(i,1)) y(konn(i,2))], 'linewidth',1.5, 'Color','g');
        elseif result(i+num_lager) < -10e-9
            % Druckstab
            p3 = plot([x(konn(i,1)) x(konn(i,2))], [y(konn(i,1)) y(konn(i,2))], 'linewidth',1.5, 'Color','r');
        end
        x_koord_text = (x(konn(i,1))+x(konn(i,2)))/2;
        y_koord_text = (y(konn(i,1))+y(konn(i,2)))/2;
    
        text(x_koord_text-0.1, y_koord_text+0.1, string(i), 'Color',[0 0 1]);
    end
    
    %Beschriftung und plotten der Knoten
    for i=1:num_knoten
        p4 = plot(koord(i,1), koord(i,2), 'o', 'linewidth',1.5, 'Color',[0 0 0]);
        name_knoten = "Knoten " + i;
        text(koord(i,1),koord(i,2)-0.1, name_knoten);
    end
    
    %Beschriftung und plotten der Kräfte 
    for i=1:num_forces
        knoten_force = F(i,1);
        koord_force_x = koord(knoten_force, 1);
        koord_force_y = koord(knoten_force, 2);
        p5 = quiver(koord_force_x, koord_force_y, F(i,2), F(i,3), "MaxHeadSize", 1/norm(F(:,2:3)), 'LineWidth', 1.5, 'Color', [1 0 0]);
        name_Force = "Force" + i;
        text(koord_force_x,koord_force_y-0.5, name_Force, 'Color', [1 0 0]);
    end

    %Beschriftung und plotten der Lager
    for i=1:num_lager
        koord_lager_x = koord(lager(i,1),1);
        koord_lager_y = koord(lager(i,1),2);
        if lager(i,2)==1
            p6 = plot(koord_lager_x, koord_lager_y-0.01, '>','linewidth', 2, 'Color', [1 0.7 0]);
        else
            p6 = plot(koord_lager_x-0.1, koord_lager_y, '^', 'linewidth', 2, 'Color', [1 0.7 0]);
        end
    end
    
    %Legende, Titel, Achsenbeschriftung erstellen
    legend([p1, p2, p3, p4, p5, p6], "Nullstab", "Zugstab", "Druckstab", "Knoten", "Froce", "Lager", 'Location', 'eastoutside');
    grid on
    xlabel('x');
    ylabel('y');
    xlim('padded');
    ylim('padded');
    title(filename)
end