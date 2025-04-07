function save_Ergebnisse(input, filename, result, f, fa, fi, stab_winkel_deg, lineares_Gleichungssystem, force_vector)
input = input;
filename_results = "results_" + filename;
result = result;
f = f;
fa = fa;
fi = fi;
stab_winkel_deg = stab_winkel_deg;
lineares_Gleichungssystem = lineares_Gleichungssystem;
force_vector = force_vector;
save(filename_results);
end