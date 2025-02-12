% Incarcam datasetul
file_path = 'C:\Users\Asus\Desktop\Facultate\An 3\Sem 1\SBC\Proiect\14 - Control of a Smart Irrigation System\archive 1\RainGarden.csv';
data = readtable(file_path);

% Verificam structura datasetului
head(data)
summary(data)

% Interpolare liniara pentru completarea valorilor lipsa
for i = 2:width(data)
    if isnumeric(data{:, i})
        data{:, i} = fillmissing(data{:, i}, 'linear');
    end
end

%verificam daca mai exista valori lipsa
summary(data)

% Convertim coloana 'Time' la format datetime
data.Time = datetime(data.Time, 'InputFormat', 'MM/dd/yy HH:mm');

% Cream o coloana noua pentru media umiditatii solului
senzori = {'wfv_1', 'wfv_2', 'wfv_3'};
data.Umiditate_medie = mean(table2array(data(:, senzori)), 2);

% Extragem trasaturi temporale
data.Hour = hour(data.Time);
data.Day = day(data.Time);
data.Month = month(data.Time);

% Analiza lunara pentru vizualizare
umiditate_pe_luna = groupsummary(data, 'Month', 'mean', 'Umiditate_medie');

% Grafic: Umiditatea medie lunara
figure;
bar(umiditate_pe_luna.Month, umiditate_pe_luna.mean_Umiditate_medie);
xlabel('Luna'); ylabel('Umiditate Medie (%)');
title('Umiditatea medie lunara');
grid on;

% Definim caracteristicile pentru regresie
X_reg = [data.Hour, data.Day, data.Month, data.Umiditate_medie];
y_reg = circshift(data.Umiditate_medie, -1);
X_reg(end, :) = []; y_reg(end) = [];

% Impartim datele in seturi de antrenament si test
cv = cvpartition(size(X_reg, 1), 'HoldOut', 0.2);
X_train = X_reg(training(cv), :);
X_test = X_reg(test(cv), :);
y_train = y_reg(training(cv));
y_test = y_reg(test(cv));

% Antrenam modelul de regresie
mdl = fitlm(X_train, y_train);

% Facem predictii
y_pred = predict(mdl, X_test);

% Evaluam modelul de regresie
mse = mean((y_test - y_pred).^2);
mae = mean(abs(y_test - y_pred));
fprintf('Mean Squared Error: %.4f\n', mse);
fprintf('Mean Absolute Error: %.4f\n', mae);

% Grafic: Predictii vs Valori reale
figure;
plot(y_test, 'b'); hold on;
plot(y_pred, 'r');
legend('Valori reale', 'Predictii');
title('Predictii vs Valori reale pentru umiditatea solului');
grid on;

% Solicităm utilizatorului să introducă datele
umiditate_dorita = input('Introduceți umiditatea dorită (%): ');
umiditate_curenta = input('Introduceți umiditatea curentă (%): ');
ora = input('Introduceți ora curentă (0-23): ');
zi = input('Introduceți ziua curentă (1-31): ');
luna = input('Introduceți luna curentă (1-12): ');

% Apelăm funcția make_decision
decision = make_decision(umiditate_dorita, umiditate_curenta, ora, zi, luna, mdl);

% Afișăm decizia
disp(['Decizia sistemului: ', decision]);


% Functie pentru decizia de udare
function decision = make_decision(umiditate_dorita, umiditate_curenta, ora, zi, luna, model)
X_new = [ora, zi, luna, umiditate_curenta];
umiditate_viitoare = predict(model, X_new);
if umiditate_dorita > umiditate_viitoare
    decision = sprintf('Udati solul (Umiditate dorita: %.1f%%, Umiditate prezisă: %.1f%%)', umiditate_dorita, umiditate_viitoare);
else
    decision = sprintf('Nu udati solul (Umiditate dorita: %.1f%%, Umiditate prezisă: %.1f%%)', umiditate_dorita, umiditate_viitoare);
end
end
