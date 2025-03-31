# Modelarea unui Sistem de Irigatie Smart
Acest proiect implementează un sistem inteligent de irigare pentru grădinile de ploaie, utilizând date despre umiditatea solului colectate de la senzori și un model de regresie liniară pentru a prezice necesitatea irigării. Scopul proiectului este optimizarea consumului de apă, asigurând o udare autonomă și eficientă a solului.  

# Date utilizate
* Fișier de date: RainGarden.csv
* Coloane relevante:  
   * Time - Data și ora fiecărei măsurători;
   * wfv_1, wfv_2, wfv_3 - Date obținute de la senzori
 
# Funcționalități implementate
*Încărcarea și procesarea datelor*
* Citirea fișierului .csv și tratarea valorilor lipsă prin interpolare liniară
* Conversia timestamp-ului la format datetime
* Calcularea umidității medii a solului
  
*Analiza și vizualizarea datelor*
* Gruparea umidității pe luni și generarea unui grafic
  
*Model de regresie liniară*
* Antrenarea unui model de predicție pentru umiditatea viitoare
* Evaluarea performanței modelului utilizând MSE și MAE
  
*Decizie de udare automată*
* Funcția make_decision() determină dacă solul trebuie udat, comparând umiditatea dorită cu cea prezisă.




