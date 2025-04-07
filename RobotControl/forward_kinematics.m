function [complete_forward_kinematic, seperated_Transformations] = forward_kinematics(parameter, rot_z_01, rot_z_12, trans_z_23)
    
    A01 = denavit_Hartenberg(rot_z_01, parameter.trans_z_01, parameter.rot_x_01, parameter.trans_x_01);
    A12 = denavit_Hartenberg(rot_z_12, parameter.trans_z_12, parameter.rot_x_12, parameter.trans_x_12);
    A23 = denavit_Hartenberg(parameter.rot_z_23, trans_z_23, parameter.rot_x_23, parameter.trans_x_23);
    
    seperated_Transformations.A01 = A01;
    seperated_Transformations.A12 = A12;
    seperated_Transformations.A23 = A23;
    
    %differential_kinematics(parameter, rot_z_01, rot_z_12);

    complete_forward_kinematic = A01 * A12 * A23;
    complete_forward_kinematic(find((complete_forward_kinematic<10e-10) & (complete_forward_kinematic>-10e-10)))=0;
    
end