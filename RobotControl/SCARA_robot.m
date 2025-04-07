scenario = "d";
parameter = system_parameter;
%single hole position (case b)
desired_x = 100;
desired_y = 100;
desired_z = 40;
%hole positions -> [x y z; x y z; ...] (case c)
hole_positions = [100, 100, 30; 200, 100, 30; 200, 150, 30; 250, 180, 30; 280, 280, 30];
%user input (case d)
size = 500;
user_input = [randi([0 1], size/2, 2); randi([-1 0], size/2,2)];
starting_position = [100 100 0];

switch scenario
    case "a"
        %just doing forward and backward kinematics, plotting the movement
        %by increasing first the rotation parameter for joint one and the
        %increase the rotation parameter for joint two
        %most useful to understand the robot movement and the underlying
        %kinematics
        SCARA_robot_movement_cases(scenario, parameter);

    case "b"
        %using first the inverse kinematics to get the DH-parameters 
        %afterward calculate the forward kinematics to get the
        %positions of the joints
        %most useful to get a single position, e.g. specific hole
        scenario = "b";
        parameter.desired_x = desired_x;
        parameter.desired_y = desired_y;
        parameter.desired_z = desired_z;
        SCARA_robot_movement_cases(scenario, parameter)
    case "c"
        %the controller gets the information for more than one hole at the
        %same time, doing the same procedure as in case b just for couple 
        %desired position
        parameter.hole_positions = hole_positions;
        SCARA_robot_movement_cases(scenario, parameter);

    case "d"
        %user input from the haptic device, showing the correlation from
        %the input to the robot movement. The input looks like this:
        %         [
        %          1   0
        %          1   0
        %          1   0
        %          0  -1
        %          0  -1
        %          .   .
        %          .   .
        %          .   .
        %                 ]
        %the first column corresponds to the  x-axis, the second to the
        %y-axis
        parameter.user_input = user_input;
        parameter.starting_position = starting_position;
        SCARA_robot_movement_cases(scenario, parameter);
    case "e"
        parameter.starting_position = starting_position;
        parameter.time_constant = 0.25;
        parameter.displacement_x = randi([0 3],1,100);
        parameter.displacement_y = randi([0 3],1,100);
        SCARA_robot_movement_cases(scenario, parameter);
    case "f"
        parameters = system_parameter;
        rot_z_01 = 270;
        rot_z_12 = 270;
        differential_kinematics(parameters, rot_z_01, rot_z_12);
    case "g"
        parameter = system_parameter;
        SCARA_robot_movement_cases(scenario, parameter);
end