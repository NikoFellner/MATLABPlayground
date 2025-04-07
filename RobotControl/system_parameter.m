function parameters = system_parameter()
    %main system parameters
    max_robot_acceleration = 10;
    max_velocity_x     = 10;
    max_velocity_y = 10;
    max_velocity_z = 10;
    
    %translations in z and x direction between 1 and 2 joint
    trans_z_01 =       20; %d1
    trans_x_01 =       250;%l1
    rot_x_01 =         0; %a1
    
    %translations in z and x direction between 2 and 3 joint
    trans_z_12 =       5; %d2
    trans_x_12 =       350;%l2
    rot_x_12 =         0;%a2
    
    %rotation around the x-axis to achieve to corresponding coordinate system
    trans_x_23 =       0; %l3
    rot_z_23 =         0; %θ3
    rot_x_23 =         0; %a3
    
    parameters.max_robot_acceleration = max_robot_acceleration;
   
    parameters.max_velocity_x = max_velocity_x; 
    parameters.max_velocity_y = max_velocity_y;
    parameters.max_velocity_z = max_velocity_z;
    
    parameters.trans_z_01 = trans_z_01;   
    parameters.trans_x_01 = trans_x_01;    
    parameters. rot_x_01 = rot_x_01;   
    
    
    parameters.trans_z_12 = trans_z_12;
    parameters.trans_x_12 = trans_x_12;
    parameters.rot_x_12 = rot_x_12;
    
    parameters.trans_x_23 = trans_x_23;
    parameters.rot_z_23 = rot_z_23;
    parameters.rot_x_23 = rot_x_23;

    parameters.desired_x = [];
    parameters.desired_y = [];
    parameters.desired_z = [];

    parameters.hole_positions = [];

    parameters.user_input = [];
    parameters.starting_position = [];

end