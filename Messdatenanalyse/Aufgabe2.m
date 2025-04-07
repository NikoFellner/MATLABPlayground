%% Aufgabe 2 a)
syms b h E F x Iyy My w dw ddw;
Iyy = (b*h^3)/12 *(2-(x/1000));
My = F * x;
ddw = My/(E*Iyy); 

%% Aufgabe 2 b)
syms C1;
dw = int(ddw, x);
dw = dw + C1;
C1_solution = solve(subs(dw, x, 0) == 0, C1);
simplify(C1_solution)

%% Aufgabe 2 c)
dw = subs(dw, C1, C1_solution);

%% Aufgabe 2 d)
syms C2;
w = int(dw, x);
w = w + C2;
C2_solution = solve(subs(w,x,0) == 0,C2);
simplify(C2_solution);
w = subs(w, C2, C2_solution);

%% Aufgabe 2 e)

par.F = -1000;       %N
par.h = 25;         %mm
par.b = 15;         %mm
par.E = 210000;     %MPa
par.x = 0:1000;     %mm
par.w = zeros(size(par.x));

w_subs = subs(w, [F,h,b,E], [par.F, par.h, par.b, par.E]);
w_fct = matlabFunction(w_subs);
w_result = w_fct(par.x);
par.w = real(w_result);

%% Aufgabe 2 f)

plot(par.x,par.w)
xlabel("x-direction [mm]");
ylabel("deformation [mm]");
legend("Biegelinie")
title("Biegelinie für fest eingepsannten Träger")

%% Aufgabe 2 g)
syms uc uF uh;
par.uc_Verlauf = zeros(size(par.x));
par.uF = 50;        %N
par.uh = 1.5;       %mm

w_simplified = subs(w, [E, b], [par.E, par.b]);
uc = sqrt((diff(w_simplified, F))^2*uF^2 + (diff(w_simplified, h))^2*uh^2);
uc_subs = subs(uc, [uF, uh, F,h], [par.uF, par.uh, par.F, par.h]);
uc_fct = matlabFunction(uc_subs);
uc_result = uc_fct(par.x);
par.uc_Verlauf = real(uc_result);

par.positive_unsicherheit_w = par.w + par.uc_Verlauf;
par.negative_unsicherheit_w = par.w - par.uc_Verlauf;

figure(6);
hold on
p1 = plot(par.x,par.w, '-c');
p2 = plot(par.x,par.positive_unsicherheit_w, '--r');
p3 = plot(par.x,par.negative_unsicherheit_w, '-.r');
xlabel("x-direction [mm]");
ylabel("deformation [mm]");
legend([p1, p2, p3], ["Biegelinie" "positive Unsicherheit" "negative Unsicherheit"]);
title("Biegelinie für fest eingepsannten Träger mit Unsicherheiten")

%% Aufgabe 2 i)
w_simplified_x = subs(w_simplified, x, 1000);

F_rand = randn(1000,1);
h_rand = randn(1000,1);
w_simplified_fct = matlabFunction(w_simplified_x);
w_simplified_fct_result = w_simplified_fct(F_rand, h_rand);
par.w_simplified = real(w_simplified_fct_result);

figure(100);
subplot(2,3,1);
histogram(F_rand);
ylabel("F random");
subplot(2,3,2);
histogram(h_rand);
ylabel("h random");
subplot(2,3,3);
histogram(par.w_simplified);
ylabel("w Ergebnis");

F_rand_long = randn(10^6,1);
h_rand_long = randn(10^6,1);
w_simplified_fct_long = matlabFunction(w_simplified_x);
w_simplified_fct_result_long = w_simplified_fct(F_rand_long, h_rand_long);
par.w_simplified_long = real(w_simplified_fct_result_long);

subplot(2,3,4);
histogram(F_rand_long);
ylabel("F random long");
subplot(2,3,5);
histogram(h_rand_long);
ylabel("h random long");
subplot(2,3,6);
histogram(par.w_simplified_long);
ylabel("w Ergebnis long");

fprintf("------------DONE---------------")

%% Funktion für Aufgabe 2 e)
function x = X(x,i)
    x = x(1,i);
end