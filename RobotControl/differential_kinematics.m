function [angular_velocity, rank_Jacobian] = differential_kinematics(parameters, rot_z_01, rot_z_12)
% the complete jacobian matrix consists of 6xn Matrix where n denotes the
% number of joints. In the case of the SCARA robot we have 3: θ1, θ2, D3
% _         _        _      _
%|    dx     |      |        |   _      _
%|    dy     |      |   Jv   |  |   dθ1  |
%|    dz     | =    |        |* |   dθ2  |
%|    wx     |      |        |  |_  dD3 _|
%|    wy     |      |   Jw   |   
%|_   wz    _|      |_      _|
%
% 1. Jv for the linear velocities:
%   time derivative of the endeffector position.
%   Jv = [dOo->n/dq1 .... dOo->n/dqn]
%   a. for recolute joints      
%       dOo->n/dq1 = zi-1 x (On - Oi-1)
%                         ^ is the cross product
%   b. for prismatic joints
%       dOo->n/dq1 = zi-1
%
% 2. Jw for the angular velocities:
%   Jw = [p1 * z0 ... pn * zn-1]
%   a. if revolute joint 
%       pi = 1
%   b. if prismatic joint
%       pi = 0

% If the Jacobian matrix is calculated, we can use the knowledge of our
% transformation matrices, to create a numeric solution therefor.
% In our case, we want to get the correlation between the joint velocities 
% θ1, θ2, D3 and the cartesian velocities dx, dy and dz
% therefor the upper part of the jacobian is already sufficient.
% In the case of regulating the cartesian speed, so dx, dy and dz is given
% we need the inverse jacobian. By limitting then those velocities, we get
% the maximum speed of our joints.

    %rot_z_01                   θ1
    %parameters.trans_z_01      d1  
    %parameters.trans_x_01      l1
    %parameters. rot_x_01       a1
    
    %rot_z_12                   θ2   
    %parameters.trans_z_12      d2
    %parameters.trans_x_12      l2
    %parameters.rot_x_12        a2
    
    %parameters.rot_z_23	    θ3
    %trans_z_23                 d3
    %parameters.trans_x_23      l3     
    %parameters.rot_x_23        a3
    
    % q = [θ1, θ2, d3]
    
    deg_to_rad = pi/180;

Jacobian_linear = [
    -parameters.trans_x_12*cos(rot_z_12*deg_to_rad)*sin(rot_z_01*deg_to_rad)-parameters.trans_x_12*sin(rot_z_12*deg_to_rad)*cos(rot_z_01*deg_to_rad)-parameters.trans_x_01*sin(rot_z_01*deg_to_rad), -parameters.trans_x_12*sin(rot_z_12*deg_to_rad)*cos(rot_z_01*deg_to_rad)-parameters.trans_x_12*cos(rot_z_12*deg_to_rad)*sin(rot_z_01*deg_to_rad);
    parameters.trans_x_12*cos(rot_z_12*deg_to_rad)*cos(rot_z_01*deg_to_rad)-parameters.trans_x_12*sin(rot_z_12*deg_to_rad)*sin(rot_z_01*deg_to_rad)-parameters.trans_x_01*sin(rot_z_01*deg_to_rad), -parameters.trans_x_12*sin(rot_z_12*deg_to_rad)*sin(rot_z_01*deg_to_rad)+parameters.trans_x_12*cos(rot_z_12*deg_to_rad)*cos(rot_z_01*deg_to_rad)];

det_jacobian = det(Jacobian_linear);
rank_Jacobian = rank(Jacobian_linear);

inv_Jacobian = inv(Jacobian_linear);
det_inv_Jacobian = det(inv_Jacobian);
rank_inv_Jacobian = rank(inv_Jacobian);

%vector_lin_vel = [parameters.velocity_x; 
%    parameters.velocity_y];

%angular_velocity = inv(Jacobian_linear) * vector_lin_vel;


end