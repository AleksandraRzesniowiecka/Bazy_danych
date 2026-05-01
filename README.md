# Tworzenie własnej bazy danych oraz jej analiza w języku SQL i R

## 1. Użyte technologie

Aby stworzyć naszą bazę danych, skorzystałyśmy z **MySQL MariaDB** i języka programowania **R**. Na początku, korzystając z MySQL w programie **Visual Studio Code**, utworzyłyśmy schemat bazy danych i uzupełniłyśmy ją niektórymi informacjami (pracownicy, rodzaje wycieczek). Następnie połączyłyśmy naszą bazę z językiem R i w programie Visual Studio Code napisałyśmy kod, który uzupełnia naszą bazę o losowo wygenerowane dane. 

Z pomocą MySQL MariaDB utworzyłyśmy zapytania, które później wprowadziłyśmy do **Google Colab** z obsługą R, aby przeanalizować dane i uzyskać raport. Na koniec stworzyłyśmy dokumentację w programie **Microsoft Word**.

---

## 2. Lista plików projektu i opis ich zawartości

*   `imie_d.csv` – tabela z imionami damskimi klientów i pracowników biura turystycznego;
*   `imie_m.csv` – tabela z imionami męskimi klientów i pracowników biura turystycznego;
*   `nazwiska_d.csv` – tabela z nazwiskami damskimi klientów i pracowników biura turystycznego;
*   `nazwiska_m.csv` – tabela z nazwiskami męskimi klientów i pracowników biura turystycznego;
*   `schemat.png` – wygenerowany schemat bazy i zależności między tabelami, ukazany na obrazku `.png`;
*   `projekt.sql` – schemat bazy danych z dodanymi niektórymi danymi;
*   `generowanie_informacji.R` – zawiera wszystkie kody, które losowo uzupełniają bazę danych o informacje;
*   `zapytania.sql` – zawiera wszystkie surowe zapytania, których użyłyśmy do stworzenia analizy danych;
*   `raport.rmd` – plik generujący raport na podstawie analizy danych;
*   `raport.pdf` – raport wygenerowany w formacie PDF;
*   `wykres.png` – wykres przedstawiający liczbę obsłużonych klientów w każdym miesiącu;
*   `dane_do_wykresu.csv` – dane do `wykres.png`;
*   `wykres.py` – kod generujący `wykres.png`;
*   `dokumentacja_projekt.docx` – zawiera informacje dotyczące sposobu uruchamiania plików, schemat bazy danych oraz jej opis.

> **Uwaga:** Wszystkie pliki `.csv` pochodzą ze strony Głównego Urzędu Statystycznego (GUS).

---

## 3. Kolejność i sposób uruchamiania plików, aby uzyskać gotowy projekt

1.  W pierwszej kolejności pobieramy wszystkie pliki i dodajemy je do jednego folderu (istotne są pliki z rozszerzeniem `.csv`).
2.  Otwieramy plik `schemat.png`.
3.  Otwieramy plik `projekt.sql` (w Visual Studio Code).
4.  Otwieramy plik `generowanie_informacji.R` (w RStudio) i uruchamiamy cały kod zawarty w pliku przyciskiem **„Run all”**. Niestety, uruchamianie kodu może chwilę potrwać.
5.  Otwieramy plik `zapytania.sql` (w Visual Studio Code) – aby uruchomić poszczególne zapytania, należy zaznaczyć to, które nas interesuje, i nacisnąć na klawiaturze `CTRL` + dwa razy `E`.
6.  Otwieramy plik `raport.pdf`.

---

## 4. Schemat projektu bazy danych

Aby opracować schemat projektu naszej bazy danych, zaczęłyśmy od spisania listy informacji, które chciałyśmy umieścić w bazie. Następnie podzieliłyśmy je na tabele, których struktury rozplanowałyśmy wcześniej. Kolejnym krokiem było rozpisanie zależności funkcyjnych dla każdej relacji. Na koniec utworzyłyśmy odpowiednie tabele w Visual Studio Code, korzystając z polecenia `CREATE TABLE`. W trakcie tego procesu dodawałyśmy na bieżąco również zależności funkcyjne oraz klucze w każdej tabeli.

---

## 5. Lista zależności funkcyjnych między kolumnami w tabelach

| Nazwa tabeli | Spis zależności funkcyjnych między kolumnami |
| :--- | :--- |
| **Pracownicy**<br>*(przechowuje dane pracowników)* | • `id_pracownik` → `imie`, `nazwisko`, `email`, `numer_telefonu`, `pensja`, `data_zatrudnienia` (każda wartość `id_pracownik` jednoznacznie określa imię, nazwisko, nr telefonu, pensję oraz datę zatrudnienia pracownika w biurze)<br>• `email` → `imie`, `nazwisko`, `numer_telefonu` |
| **Rodzaje_wycieczek**<br>*(przechowuje rodzaje wycieczek oferowanych przez firmę)* | • `id_rodzaj` → `nazwa`, `kierunek`, `opis`, `cena` (każda wartość `id_rodzaj` jednoznacznie określa nazwę, kierunek, opis oraz cenę rodzaju wyjazdu) |
| **Wyjazdy**<br>*(przechowuje rekordy wyjazdów zorganizowanych przez firmę od początku działalności)* | • `id_wyjazd` → `id_rodzaj`, `id_pracownik`, `data_wyjazdu`, `data_powrotu`, `koszt_calkowity`, `liczba_uczestnikow` (każda wartość `id_wyjazdu` jednoznacznie określa rodzaj wycieczki, pracownika sprzedającego wycieczkę, datę wyjazdu oraz powrotu, koszt całkowity oraz liczbę uczestników wyjazdu) |
| **Koszty_organizacji**<br>*(przechowuje koszty organizacji wycieczek)* | • `id_koszt` → `id_wyjazd`, `opis_kosztu`, `koszt` (każda wartość `id_kosztu` jednoznacznie określa id wyjazdu, opis kosztów oraz koszt)<br>• `id_wyjazd` → `koszt` |
| **Transakcje_finansowe**<br>*(przechowuje rekordy transakcji finansowych realizowanych przez firmę)* | • `id_transakcja` → `id_wyjazd`, `data_transakcji`, `kwota`, `typ_transakcji`, `opis` (każda wartość `id_transakcja` jednoznacznie określa id wyjazdu, datę transakcji, kwotę, typ oraz opis transakcji przychodzącej lub wychodzącej z biura) |
| **Klienci**<br>*(przechowuje dane klientów biura)* | • `id_klient` → `imie`, `nazwisko`, `email`, `numer_telefonu`, `adres`, `data_urodzenia` (każda wartość `id_klient` jednoznacznie określa imię, nazwisko, email, numer telefonu, adres i datę urodzenia klienta)<br>• `email` → `imie`, `nazwisko`, `numer_telefonu` (każda wartość `email` określa imię, nazwisko i numer telefonu klienta biura) |
| **Kontakt_bliscy**<br>*(przechowuje dane bliskich klientów w ramach kontaktu w przypadku wystąpienia losowej sytuacji)* | • `id_kontakt` → `id_klient`, `imie`, `nazwisko`, `numer_telefonu`, `relacja` (każda wartość `id_kontakt` jednoznacznie określa imię, nazwisko, numer telefonu oraz relację bliskiego klienta biura) |
