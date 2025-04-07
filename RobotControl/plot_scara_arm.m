function plot_scara_arm(transform_matrices, color_input)
    pose_joint1 = [0, 0];
    A02 = transform_matrices.A01 * transform_matrices.A12;    
    pose_joint2 = transform_matrices.A01(1:2,4);
    pose_joint3 = A02(1:2,4);
    
    poses_scara_joints = [pose_joint1;pose_joint2';pose_joint3'];
    
    if color_input == "blue"
        plot(poses_scara_joints(:,1),poses_scara_joints(:,2), 'b-o');
        xlim([-700 700]);
        ylim([-700 700]);
    elseif color_input == "black"
        plot(poses_scara_joints(:,1),poses_scara_joints(:,2), 'k.');
        xlim([-700 700]);
        ylim([-700 700]);
        legend("endeffector positions")
    else
        plot(poses_scara_joints(:,1),poses_scara_joints(:,2), 'r-o');
        xlim([-350 350]);
        ylim([-350 350]);
    end
end