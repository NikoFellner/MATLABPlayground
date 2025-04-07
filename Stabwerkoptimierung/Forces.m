a1 = 0.5;
a2 = 0.5;
q1 = 30;
q2 = 30;

J = [-a1*sin(q1)-a2*sin(q1+q2) -a2*sin(q1+q2) 0 0;
    a1*cos(q1)+a2*cos(q1+q2) a2*cos(q1+q2) 0 0;
    0 0 -1 0;
    0 0 0 0;
    0 0 0 0;
    1 1 0 -1];

% fx = 0;
% fy = 0;
% fz = 0;
% tx = 0;
% ty = 0;
% tz = -40;
% 
% h = [fx fy fz tx ty tz];
% gelenke = transpose(J) * transpose(h)

t1 = 0;
t2 = 0;
t3 = -50;
t4 = 20;

gelenke = [t1 t2 t3 t4];

h = pinv(transpose(J))*transpose(gelenke)
