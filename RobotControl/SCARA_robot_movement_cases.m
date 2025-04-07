function SCARA_robot_movement_cases(scenario, parameter)
    
    switch scenario
        case 'a'
            %just doing forward and backward kinematics, plotting the movement
            %by increasing first the rotation parameter for joint one and the
            %increase the rotation parameter for joint two
            rot_z_01        = 5; %θ1
            rot_z_12        = 5; %θ2
            trans_z_23      = 40; %d3
            count_ = 0;
            color_input = "blue";
            
            while rot_z_12<90
                count_ = count_ +1;
                fprintf("----------------------------------------------\n run %f \n", count_);
                [A03, transform_matrices] = forward_kinematics(parameter, rot_z_01, rot_z_12, trans_z_23);
                desired_x = A03(1,4);
                desired_y = A03(2,4);
                desired_z = A03(3,4);
                
                [theta1, theta2, d3] = inverse_kinematics(desired_x, desired_y, desired_z, parameter);
                    
                communication(theta1, rot_z_01, theta2, rot_z_12,trans_z_23, d3);
                hold on
                plot_scara_arm(transform_matrices, color_input);
                
                if rot_z_01 < 90
                    rot_z_01 = rot_z_01 + 15;
                end
                if (rot_z_01 >= 90) && (rot_z_12 < 90)
                    color_input = "red";
                    rot_z_12 = rot_z_12 + 5;
                end
            end
            hold off
    
        case 'b'
            %using first the inverse kinematics to get the DH-parameters 
            %afterward calculate the forward kinematics to get the
            %positions of the joints
            color_input ="blue";
            [theta1, theta2, d3] = inverse_kinematics(parameter.desired_x, parameter.desired_y, parameter.desired_z, parameter);
            [A03, transform_matrices] = forward_kinematics(parameter, theta1, theta2, d3);
            plot_scara_arm(transform_matrices, color_input);
        
        case 'c'
            num_holes = size(parameter.hole_positions,1); 
            color_input = "blue";
            hold on
            for i=1: num_holes
                desired_x = parameter.hole_positions(i,1);
                desired_y = parameter.hole_positions(i,2);
                desired_z = parameter.hole_positions(i,3);                
                [theta1, theta2, d3] = inverse_kinematics(desired_x, desired_y, desired_z, parameter);
                [A03, transform_matrices] = forward_kinematics(parameter, theta1, theta2, d3);
                plot_scara_arm(transform_matrices, color_input);
            end
            hold off

        case 'd'
            num_user_input = size(parameter.user_input,1);
            x_start = parameter.starting_position(1);
            y_start = parameter.starting_position(2);
            z_start = parameter.starting_position(3);
            color_input = "blue";
            
            
            videoMovement = VideoWriter('videoMovement_Szenario_d','MPEG-4');
            videoMovement.FrameRate = 30;
            open(videoMovement);
            set(gca,'YDir','reverse');

            grid on;
            for i=1:num_user_input                
                if i==1
                    desired_x = x_start + parameter.user_input(i,1);
                    desired_y = y_start + parameter.user_input(i,2);
                else
                    desired_x = desired_x + parameter.user_input(i,1);
                    desired_y = desired_y + parameter.user_input(i,2);
                end
                desired_z = z_start;
                [theta1, theta2, d3] = inverse_kinematics(desired_x, desired_y, desired_z, parameter);
                [A03, transform_matrices] = forward_kinematics(parameter, theta1, theta2, d3);
                plot_scara_arm(transform_matrices, color_input);              
                    
                 fr = getframe(gcf);
                 writeVideo(videoMovement, fr);         

            end            
            close(videoMovement);


        case "e"            
            x_start = parameter.starting_position(1);
            y_start = parameter.starting_position(2);
            z_start = parameter.starting_position(3);
            color_input = "blue";
            desired_z = z_start;            

            
            [theta1, theta2, d3] = inverse_kinematics(x_start, y_start, z_start, parameter);
            for r=1:3
                for i=1:size(parameter.displacement_x,2)                
                    if i==1
                        desired_x = x_start + parameter.displacement_x(i);
                        desired_y = y_start + parameter.displacement_y(i);
                    else
                        desired_x = desired_x + parameter.displacement_x(i);
                        desired_y = desired_y + parameter.displacement_y(i);
                    end
                    parameter.velocity_x = parameter.displacement_x(i) / parameter.time_constant;
                    parameter.velocity_y = parameter.displacement_y(i) / parameter.time_constant;
                    [angular_velocity, rank] = differential_kinematics(parameter, theta1, theta2);
                    theta1 = theta1+angular_velocity(1)*parameter.time_constant *180/pi;
                    theta2 = theta2+angular_velocity(2)*parameter.time_constant *180/pi;
                    fprintf("theta 1: %f    theta2: %f  rank: %f \n", theta1,theta2, rank);
                    [A03, transform_matrices] = forward_kinematics(parameter, theta1, theta2, d3);
                    plot_scara_arm(transform_matrices, color_input);
                    pause(parameter.time_constant);
                end
            end

        case "g"
            rot_z_01        = 20; %θ1
            rot_z_12        = 0; %θ2
            trans_z_23      = 40; %d3
            count_ = 0;
            color_input = "black";

            videoMovement = VideoWriter('videoMovement_Szenario_g','MPEG-4');
            videoMovement.FrameRate = 60;
            open(videoMovement);
            set(gca,'YDir','reverse');

            grid on;
            
            while rot_z_01 <340   
                rot_z_12 = 40;
                while rot_z_12 < 320
                    rot_z_12 = rot_z_12 + 10;
                    count_ = count_ +1;
                    fprintf("----------------------------------------------\n run %f \n", count_);
                    [A03, transform_matrices] = forward_kinematics(parameter, rot_z_01, rot_z_12, trans_z_23);
    
                    hold on
                    plot_scara_arm(transform_matrices, color_input);
                    
                    fr = getframe(gcf);
                    writeVideo(videoMovement, fr);
                   
                end
                rot_z_01 = rot_z_01 +10;
            end           
            hold off
            close(videoMovement);
          end
            

end

