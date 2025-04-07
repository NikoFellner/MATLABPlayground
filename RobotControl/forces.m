a1 =0.500;
a2 =0.500;
theta1 = 45;
theta2 = 45; 

tau1 = 100; %Nm
tau2 = 100; %Nm
Tau3 = 10;%Nm
S = 0.1;%m / Spindelsteigung
F3 = 2*pi()*Tau3/S;%N
tau4 = 0;%Nm

internal_forces = [tau1;tau2;F3;tau4];

Jacobian = [-a1*sin(theta1)-a2*sin(theta1+theta2), -a2*sin(theta1+theta2), 0, 0;
    a1*cos(theta1)+a2*cos(theta1+theta2), a2*cos(theta1+theta2), 0, 0;
    0, 0, -1, 0;
    0, 0, 0, 0;
    0, 0, 0, 0;
    1, 1, 0, -1];

Jacobian_inverse = pinv(Jacobian);

external_forces = transpose(Jacobian_inverse) * internal_forces