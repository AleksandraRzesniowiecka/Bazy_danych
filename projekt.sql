CREATE TABLE Pracownicy
(
  id_pracownik      INT          NOT NULL AUTO_INCREMENT PRIMARY KEY,
  imie              VARCHAR(50)  NOT NULL,
  nazwisko          VARCHAR(50)  NOT NULL,
  email             VARCHAR(100) NULL    ,
  numer_telefonu    INT          NULL    ,
  pensja            INT          NULL     COMMENT 'w zł po zaokrągleniu do jedności',
  data_zatrudnienia DATE         NULL    
);

CREATE TABLE Rodzaje_wycieczek
(
  id_rodzaj         INT          NOT NULL AUTO_INCREMENT PRIMARY KEY,
  nazwa             VARCHAR(100) NOT NULL,
  kierunek          VARCHAR(100) NOT NULL,
  opis              TEXT         NULL    ,
  cena              INT          NOT NULL    
);

CREATE TABLE Wyjazdy
(
  id_wyjazd             INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
  id_rodzaj             INT             NOT NULL,
  id_pracownik          INT             NOT NULL,
  data_wyjazdu          DATE            NOT NULL,
  data_powrotu          DATE            NOT NULL,
  koszt_calkowity       DECIMAL (8, 2)  NOT NULL,
  liczba_uczestnikow    INT             NOT NULL
);

CREATE TABLE Koszty_organizacji
(
  id_koszt          INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
  id_wyjazd         INT             NOT NULL,
  koszt             DECIMAL (8, 2)  NOT NULL,
  opis_kosztu       VARCHAR(100)    NULL
);

CREATE TABLE Transakcje_finansowe
(
  id_transakcja     INT                             NOT NULL AUTO_INCREMENT PRIMARY KEY,
  id_wyjazd         INT                             NOT NULL,
  data_transakcji   DATE                            NOT NULL,
  kwota             DECIMAL (8, 2)                  NOT NULL,
  typ_transakcji    ENUM ('Przychód', 'Wydatek')    NOT NULL,
  opis              VARCHAR(100)                    NULL
);

CREATE TABLE Klienci
(
  id_klient         INT          NOT NULL AUTO_INCREMENT PRIMARY KEY,
  imie              VARCHAR(50)  NOT NULL,
  nazwisko          VARCHAR(50)  NOT NULL,
  email             VARCHAR(100) NULL    ,
  numer_telefonu    INT          NULL    ,
  adres             VARCHAR(100) NULL    ,
  data_urodzenia    DATE         NULL
);

CREATE TABLE Kontakt_bliscy
(
  id_kontakt        INT          NOT NULL AUTO_INCREMENT PRIMARY KEY,
  id_klient         INT          NOT NULL,
  imie              VARCHAR(50)  NOT NULL,
  nazwisko          VARCHAR(50)  NOT NULL,
  numer_telefonu    INT          NOT NULL,
  relacja           VARCHAR(50)  NULL
);

ALTER TABLE Wyjazdy
ADD CONSTRAINT FK_Rodzaje_wycieczek_TO_Wyjazdy
FOREIGN KEY (id_rodzaj)
REFERENCES Rodzaje_wycieczek (id_rodzaj);

ALTER TABLE Koszty_organizacji
ADD CONSTRAINT FK_Wyjazdy_TO_Koszty_organizacji
FOREIGN KEY (id_wyjazd)
REFERENCES Wyjazdy (id_wyjazd);

ALTER TABLE Transakcje_finansowe
ADD CONSTRAINT FK_Wyjazdy_TO_Transakcje_finansowe
FOREIGN KEY (id_wyjazd)
REFERENCES Wyjazdy (id_wyjazd);

ALTER TABLE Kontakt_bliscy
ADD CONSTRAINT FK_Klienci_TO_Kontakt_bliscy
FOREIGN KEY (id_klient)
REFERENCES Klienci (id_klient);

ALTER TABLE Wyjazdy
ADD COLUMN id_pracownik INT NULL;

ALTER TABLE Wyjazdy
ADD CONSTRAINT FK_Pracownicy_TO_Wyjazdy
FOREIGN KEY (id_pracownik)
REFERENCES Pracownicy (id_pracownik);

ALTER TABLE Transakcje_finansowe
ADD COLUMN id_klient INT NULL;

ALTER TABLE Transakcje_finansowe
ADD CONSTRAINT FK_Klienci_TO_Transakcje_finansowe
FOREIGN KEY (id_klient)
REFERENCES Klienci (id_klient);


INSERT INTO Rodzaje_wycieczek (nazwa, kierunek, opis, cena) VALUES ("W Labiryncie Minotaura", "Grecja", "Idealne dla rodzin z dziećmi", "2100");
INSERT INTO Rodzaje_wycieczek (nazwa, kierunek, opis, cena) VALUES ("Wieczór kawalerski pod palmami", "Grecja", "Wyjazd, który zachwyci każdego przyszłego Pana Młodego i jego przyjaciół.", "2100");
INSERT INTO Rodzaje_wycieczek (nazwa, kierunek, opis, cena) VALUES ("Słoneczny wypoczynek", "Hiszpania", "Idealna wycieczka dla rodzin z dziećmi, łącząca w sobie elementy plażowania i aktywnego wypoczynku.", "1800");
INSERT INTO Rodzaje_wycieczek (nazwa, kierunek, opis, cena) VALUES ("Romantyczny weekend we dwoje", "Włochy", "Dwudniowa wycieczka na szybki weekend getaway.", "2900");
INSERT INTO Rodzaje_wycieczek (nazwa, kierunek, opis, cena) VALUES ("Balanga bez Granic", "Turcja", "Usatyfakcjonuje każdego wytrwałego imprezowicza.", "2900");
INSERT INTO Rodzaje_wycieczek (nazwa, kierunek, opis, cena) VALUES ("Romantyczny weekend we dwoje", "Portugalia", "Dwudniowa wycieczka na szybki weekend getaway.", "1900");
INSERT INTO Rodzaje_wycieczek (nazwa, kierunek, opis, cena) VALUES ("Wieczór kawalerski pod palmami", "Egipt", "Wyjazd, który zachwyci każdego przyszłego Pana Młodego i jego przyjaciół.", "2500");
INSERT INTO Rodzaje_wycieczek (nazwa, kierunek, opis, cena) VALUES ("Surfing dla każdego", "Hiszpania", "Wyjazd, na którym istnieje możliwość nauki surfingu.", "2900");
INSERT INTO Rodzaje_wycieczek (nazwa, kierunek, opis, cena) VALUES ("Romantyczny weekend we dwoje", "Grecja", "Dwudniowa wycieczka na szybki weekend getaway.", "2100");
INSERT INTO Rodzaje_wycieczek (nazwa, kierunek, opis, cena) VALUES ("Surfing dla każdego", "Egipt", "Wyjazd, na którym istnieje możliwość nauki surfingu.", "1800");
INSERT INTO Rodzaje_wycieczek (nazwa, kierunek, opis, cena) VALUES ("Wieczór kawalerski pod palmami", "Włochy", "Wyjazd, który zachwyci każdego przyszłego Pana Młodego i jego przyjaciół.", "1900");
INSERT INTO Rodzaje_wycieczek (nazwa, kierunek, opis, cena) VALUES ("Balanga bez Granic", "Grecja", "Usatyfakcjonuje każdego wytrwałego imprezowicza.", "2900");
INSERT INTO Rodzaje_wycieczek (nazwa, kierunek, opis, cena) VALUES ("Surfing dla każdego", "Portugalia", "Wyjazd, na którym istnieje możliwość nauki surfingu.", "2500");
INSERT INTO Rodzaje_wycieczek (nazwa, kierunek, opis, cena) VALUES ("Słoneczny wypoczynek", "Turcja", "Idealna wycieczka dla rodzin z dziećmi, łącząca w sobie elementy plażowania i aktywnego wypoczynku.", "2600");
INSERT INTO Rodzaje_wycieczek (nazwa, kierunek, opis, cena) VALUES ("Balanga bez Granic", "Hiszpania", "Usatyfakcjonuje każdego wytrwałego imprezowicza.", "2600");
INSERT INTO Rodzaje_wycieczek (nazwa, kierunek, opis, cena) VALUES ("Słoneczny wypoczynek", "Egipt", "Idealna wycieczka dla rodzin z dziećmi, łącząca w sobie elementy plażowania i aktywnego wypoczynku.", "1700");

INSERT INTO Pracownicy (imie, nazwisko, email, numer_telefonu, pensja, data_zatrudnienia) VALUES ("Julia", "Świerczok", "juliaswierczok@gmail.com", "435467856", "8500", "2023-10-01");
INSERT INTO Pracownicy (imie, nazwisko, email, numer_telefonu, pensja, data_zatrudnienia) VALUES ("Emilia", "Borodzicz", "emiliaborodzicz@gmail.com", "267293495", "8000", "2023-07-01");
INSERT INTO Pracownicy (imie, nazwisko, email, numer_telefonu, pensja, data_zatrudnienia) VALUES ("Maja", "Boruszek", "majaboruszek@gmail.com", "739456023", "7000", "2023-12-04");
INSERT INTO Pracownicy (imie, nazwisko, email, numer_telefonu, pensja, data_zatrudnienia) VALUES ("Aleksandra", "Rześniowiecka", "aleksandrarzesniowiecka@gmail.com", "749321645", "6500", "2023-12-03");
INSERT INTO Pracownicy (imie, nazwisko, email, numer_telefonu, pensja, data_zatrudnienia) VALUES ("Dominik", "Jur", "dominikjur@gmail.com", "748594931", "6500", "2023-09-05");

