function [theta1, theta2, d3] = inverse_kinematics(desired_x, desired_y, desired_z, parameter)
    l1 = parameter.trans_x_01;
    l2 = parameter.trans_x_12;
    d1 = parameter.trans_z_01;
    d2 = parameter.trans_z_12;
    
    xd = desired_x;
    yd = desired_y;

    argument_cos_theta2 = (xd^2+yd^2-l1^2-l2^2) /(2*l1*l2);
    argument_cos_theta2_expressed_in_sin = sqrt(1- argument_cos_theta2^2);
    theta2_rad = atan2(argument_cos_theta2_expressed_in_sin,argument_cos_theta2);
    theta2 = theta2_rad * 180/pi;


    alpha = atan2(xd, yd);
    beta = atan2(argument_cos_theta2_expressed_in_sin*l2,l1+argument_cos_theta2*l2);
    theta1 = 90 - (alpha*180/pi + beta*180/pi);

    d3 = desired_z - d1 - d2;
end