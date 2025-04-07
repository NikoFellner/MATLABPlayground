function communication(theta1, rot_z_01, theta2, rot_z_12,trans_z_23, d3)
    if abs(theta1-rot_z_01)<10e-1 
        fprintf("forward and inverse kinematics are right for the θ1 : %f \n", theta1);
    else
        fprintf("forward and inverse kinematics are wrong θ1 : %f \n -- should be %f \n", theta1, rot_z_01);
    end
    if abs(theta2-rot_z_12)<10e-1
        fprintf("forward and inverse kinematics are right for the θ2 : %f \n", theta2);
    else
        fprintf("forward and inverse kinematics are wrong θ2 : %f \n -- should be %f \n", theta2, rot_z_12)
    end
    if abs(trans_z_23-d3)<10e-1
        fprintf("forward and inverse kinematics are right for the d3 : %f \n", d3);
    else
        fprintf("forward and inverse kinematics are wrong d3 : %f \n -- should be %f \n", d3, trans_z_23)
    end
end