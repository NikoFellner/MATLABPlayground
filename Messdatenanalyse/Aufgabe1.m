%% Aufgabe 1
target_file = "C:\10_Studium\Masterstudium\20_StudienSemester\03_WiSe22_23\Praktikum_MatLab\4 Versuch `Messdatenanalyse' FMT\Unterlagen zur Versuchsdurchfuehrung\Daten_Schwingungssensor.xlsx";
num = xlsread(target_file, "B:C");
xValues = num(:,1);
yValues = num(:,2);
figure(3)
plot(xValues,yValues, 'c');
title('Data Plot');
xlabel('x-Values');
ylabel('y-Values');
grid on;
fileName = 'Niko_Abgabe_1.png';
saveas(figure(3), fileName);
uniqueness = unique(gradient(xValues));

% information to colon-notation
% "To counteract such error accumulation, the algorithm of the COLON operator dictates that:
% 1. The first half of the output vector (in this example .v.) is calculated by adding integer...
%     multiples of the step .d. to the left-hand endpoint .a.. 2. The second half is calculated ...
%     by subtracting multiples of the step ‘d’ from the right-hand endpoint."


%% Aufgabe 2 (i)
num_unique_values = size(uniqueness, 1);
mittel_unique_values = sum(uniqueness)/num_unique_values;
fprintf("Number of unique values %f /n arithemtic middel %f \n", num_unique_values, mittel_unique_values);

%% Aufgabe 2 (ii)
xValues2 = round(xValues, 1);
uniqueness2 = unique(gradient(xValues2));
num_unique_values2 = size(uniqueness2, 1);
mittel_unique_values2 = sum(uniqueness2)/num_unique_values2;
fprintf("Number of unique values %f /n arithemtic middel %f \n", num_unique_values2, mittel_unique_values2);


%% Aufgabe 2 (iii)
xValues3 = round(xValues, 3);
comparison = zeros([999,1]);
for i= 1: size(xValues,1)-1
    comparison(i) = xValues3(i+1)-xValues3(i);
end
uniqueness_comparison = unique(comparison);
comparison_mittel = sum(uniqueness_comparison)/size(uniqueness_comparison,1);

%% Aufgabe 3
samplingFrequency = 1/comparison_mittel;
figure(4)
Y = fft(yValues);
Y_abs = abs(Y)/(size(yValues,1)/2);
f = (0:size(yValues,1)-1)*(samplingFrequency/size(yValues,1));
p = plot(f, Y_abs, '-o');
p.MarkerEdgeColor = 'r';
p.MarkerFaceColor = 'r';
xlabel("[Hz]");
ylabel("Amplitude");

%% Aufgabe 3 
grenz_amplitude = 1;
indx_dominant_frequencies = find(Y_abs(:,:)>grenz_amplitude);
dominant_frequencies = f(Y_abs(:,:)>grenz_amplitude);
zero_complex = complex(0,0);
bereinigter_yVektor = zeros(size(yValues));

for i=1:size(yValues,1)
    if any(indx_dominant_frequencies == i)    
        
        bereinigter_yVektor(i) = Y(i);
    else
        bereinigter_yVektor(i) = zero_complex;
    end
end

figure(5)
Y_bereinigt = ifft(bereinigter_yVektor);
hold on
p2 = plot(xValues,yValues);
p3 = plot(xValues,Y_bereinigt);
legend("ursprüngliches Signal", "bereinigtes Signal")
hold off
