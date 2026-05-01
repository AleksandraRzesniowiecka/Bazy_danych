install.packages("RMariaDB")
install.packages(c("DBI", "knitr", "ggplot2", "tinytex"))
install.packages("rmarkdown")
#install.packages("languageserver")
#install.packages("dplyr")

# Wczytanie pakietów
library(RMariaDB)
library(dplyr)
library(lubridate)

# Ustanowienie połaczenia z serwerem
con <- dbConnect(RMariaDB::MariaDB(),
                 dbname = "team27",
                 username = "team27",
                 password = "te@mzazt",
                 host = "giniewicz.it")

# IMIONA KOBIET
# Wczytanie danych z pliku
dane <- read.csv("imie_d.csv",sep = ",", header = TRUE, check.names = F)
print(colnames(dane))

# Wylosowanie  imion
tekst <- sample(dane$IMIĘ_PIERWSZE, 100, replace = TRUE)
print(tekst)


# NAZWISKA KOBIET
# Wczytanie danych z pliku
dane_1 <- read.csv("nazwiska_d.csv",sep = ",", header = TRUE, check.names = F)
print(colnames(dane_1))
print(nrow(dane1))

# Zmniejszenie liczby wierszy do 200
danen <- head(dane1, 200)

# Wyświetlenie zmniejszonej liczby wierszy
print(nrow(danen))

# Wylosowanie nazwisk
tekst_1 <- sample(dane_1$Nazwisko_aktualne, 100, replace = TRUE)
print(tekst_1)


# IMIONA MĘŻCZYZN
# Wczytanie danych z pliku
dane_2 <- read.csv("imie_m.csv",sep = ",", header = TRUE, check.names = F)
print(colnames(dane_2))

# Wylosowanie  imion
tekst_2 <- sample(dane$IMIĘ_PIERWSZE, 100, replace = TRUE)
print(tekst_2)


# NAZWISKA MĘŻCZYZN
# Wczytanie danych z pliku
dane_3 <- read.csv("nazwiska_m.csv",sep = ",", header = TRUE, check.names = F)
print(colnames(dane_3))

# Wylosowanie nazwisk
tekst_3 <- sample(dane_1$Nazwisko_aktualne, 100, replace = TRUE)
print(tekst_3)


# ŁĄCZENIE IMION I NAZWISK
mienie <- data.frame(imię= c(tekst, tekst_2), nazwisko=c(tekst_1,tekst_3))
print(mienie)

# INDEKSOWANIE
indeksy <- sample(nrow(mienie), size=200, replace=FALSE)
wiersze <- mienie[indeksy, ]


# DODANIE IMION I NAZWISK DO TABEL
# Iteracja przez dane i wstawianie do tabeli Klienci
for (i in 1:nrow(mienie)) {
  dbExecute(
    con,
    sprintf(
      "INSERT INTO Klienci (imie, nazwisko) VALUES ('%s', '%s')",
      mienie$imię[i],
      mienie$nazwisko[i]
    )
  )
}

# Liczba wierszy
num_records <- nrow(mienie)

# Losowe id_klient (od 1 do 200)
id_klient <- sample(1:200, num_records, replace = TRUE)

# Losowe numery telefonów (9 cyfr)
numer_telefonu <- sprintf("%09d", sample(100000000:999999999, num_records, replace = FALSE))

# Iteracja przez dane i wstawianie do tabeli Kontakt_bliscy
for (i in 1:num_records) {
  query <- sprintf(
    "INSERT INTO Kontakt_bliscy (id_klient, imie, nazwisko, numer_telefonu) 
     VALUES (%d, '%s', '%s', %s)",
    id_klient[i],
    mienie$imię[i],
    mienie$nazwisko[i],
    numer_telefonu[i]
  )
  
  dbExecute(con, query)
}


# UZUPEŁNIENIE TABELI WYJAZDY

# Ustalenie zakresu dat wyjazdów (od 2022-06-01 do daty dzisiejszej - 3 dni)
data_dzis <- Sys.Date()
zakres_dat <- seq.Date(as.Date("2022-06-01"), data_dzis - 3, by = "day")

# Losowanie dat wyjazdów z zakresu
data_wyjazdu <- sample(zakres_dat, 100, replace = TRUE)

# Generowanie dat powrotu (np. 3-14 dni po wyjeździe)
data_powrotu <- data_wyjazdu + sample(3:14, length(data_wyjazdu), replace = TRUE)

# Losowe id_rodzaj (zakładamy, że rodzaje istnieją w tabeli Rodzaje_wycieczek)
id_rodzaj <- sample(1:16, length(data_wyjazdu), replace = TRUE)

# Losowa liczba uczestników (np. od 30 do 50)
liczba_uczestnikow <- sample(30:50, length(data_wyjazdu), replace = TRUE)

# Losowy koszt całkowity (np. od 2900.00 do 4000.00 zł)
koszt_calkowity <- round(runif(length(data_wyjazdu), 2900, 4000), 2)

# Losowe id_pracownik (od 1 do 5)
id_pracownik <- sample(1:5, num_records, replace = TRUE)

# Iteracja przez dane i wstawianie do tabeli Wyjazdy
for (i in 1:length(data_wyjazdu)) {
  query <- sprintf(
    "INSERT INTO Wyjazdy (id_rodzaj, data_wyjazdu, data_powrotu, koszt_calkowity, liczba_uczestnikow, id_pracownik)
     VALUES (%d, '%s', '%s', %.2f, %d, %d)",
    id_rodzaj[i],
    data_wyjazdu[i],
    data_powrotu[i],
    koszt_calkowity[i],
    liczba_uczestnikow[i],
    id_pracownik[i]
  )
  
  dbExecute(con, query)
}


# UZUPEŁNIENIE TABELI KOSZTY_ORGANIZACJI

wyjazdy <- dbGetQuery(con, "SELECT id_wyjazd, id_rodzaj, koszt_calkowity FROM Wyjazdy")
rodzaje <- dbGetQuery(con, "SELECT id_rodzaj, cena FROM Rodzaje_wycieczek")

# Łączenie danych na podstawie id_rodzaj
koszty <- merge(wyjazdy, rodzaje, by = "id_rodzaj")

# Obliczanie kosztów organizacji
koszty$koszt_organizacji <- koszty$koszt_calkowity - koszty$cena

# Wstawianie danych do tabeli Koszty_organizacji
for (i in 1:nrow(koszty)) {
  query <- sprintf(
    "INSERT INTO Koszty_organizacji (id_wyjazd, koszt) VALUES (%d, %.2f)",
    koszty$id_wyjazd[i],
    koszty$koszt_organizacji[i]
  )
  dbExecute(con, query)
}

dbDisconnect(con)


# UZUPEŁNIANIE TABELI TRANSAKCJE_FINANSOWE

# Pobranie danych z tabel Wyjazdy i Koszty_organizacji
wyjazdy <- dbGetQuery(con, "SELECT id_wyjazd, data_wyjazdu, koszt_calkowity, liczba_uczestnikow FROM Wyjazdy")
koszty <- dbGetQuery(con, "SELECT id_wyjazd, koszt FROM Koszty_organizacji")

# Łączenie danych na podstawie id_wyjazd
transakcje <- merge(wyjazdy, koszty, by = "id_wyjazd")

# Liczba transakcji = liczba wyjazdów * liczba uczestników * 2
transakcje <- transakcje[rep(1:nrow(transakcje), times = transakcje$liczba_uczestnikow * 2), ]

# Typ transakcji (naprzemiennie: Przychód, Wydatek)
transakcje$typ_transakcji <- rep(c("Przychód", "Wydatek"), length.out = nrow(transakcje))

# Kwota (koszt_calkowity dla Przychodu, koszt dla Wydatku)
transakcje$kwota <- ifelse(
  transakcje$typ_transakcji == "Przychód",
  transakcje$koszt_calkowity,
  transakcje$koszt
)

# Data transakcji (losowa między data_wyjazdu - 30 dni a data_wyjazdu)
transakcje$data_transakcji <- as.Date(transakcje$data_wyjazdu) - sample(0:30, nrow(transakcje), replace = TRUE)

# Opis transakcji (opcjonalny, np. "Opłata za organizację" lub "Wpłata uczestnika")
transakcje$opis <- ifelse(
  transakcje$typ_transakcji == "Przychód",
  "Wpłata uczestnika",
  "Koszt organizacji"
)

# Wstawianie danych do tabeli Transakcje_finansowe
for (i in 1:nrow(transakcje)) {
  query <- sprintf(
    "INSERT INTO Transakcje_finansowe (id_wyjazd, data_transakcji, kwota, typ_transakcji, opis) 
     VALUES (%d, '%s', %.2f, '%s', '%s')",
    transakcje$id_wyjazd[i],
    transakcje$data_transakcji[i],
    transakcje$kwota[i],
    transakcje$typ_transakcji[i],
    transakcje$opis[i]
  )
  dbExecute(con, query)
}

dbDisconnect(con)
