function [c, ceq] = Nebenbedingungen(x_opt, A, EA, S)

c = -80.+abs(S)./(A.*x_opt);
ceq = -500.+transpose(EA)*x_opt;
end