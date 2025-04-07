function transform_matrix = denavit_Hartenberg(rot_z, trans_z, rot_x, trans_x)
    rot_z_rad = rot_z *pi/180;
    rot_x_rad = rot_x * pi/180;
    
    RotationMatrix_z = [cos(rot_z_rad) -sin(rot_z_rad) 0 0; 
        sin(rot_z_rad) cos(rot_z_rad) 0 0; 
        0 0 1 0; 
        0 0 0 1];
    TranslationMatrix_z = [1 0 0 0; 
        0 1 0 0; 
        0 0 1 trans_z; 
        0 0 0 1];
    RotationMatrix_x = [1 0 0 0; 
        0 cos(rot_x_rad) -sin(rot_x_rad) 0; 
        0 sin(rot_x_rad) cos(rot_x_rad) 0; 
        0 0 0 1];
    TranslationMatrix_x = [1 0 0 trans_x; 
        0 1 0 0; 
        0 0 1 0; 
        0 0 0 1];
    
    transform_matrix = RotationMatrix_z * TranslationMatrix_z * TranslationMatrix_x * RotationMatrix_x;
end
