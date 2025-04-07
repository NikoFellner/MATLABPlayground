function [u_F] = Zielfunktion(x_opt, EA,num_knoten,num_stab,koord,konn,lager,F, num_forces)
    
    u_F = zeros([num_forces,1]);
    [u,S] = Stabtragwerk(x_opt.*EA,num_knoten,num_stab,koord,konn,lager,F);
    
    for i = 1: num_forces
        koord_F = F(i,1);
        u_F(i) = abs(u(2*koord_F));        
    end
end