--pytanie 1
-- najpopularniejsze rodzaje wycieczek
SELECT 
    rw.nazwa AS nazwa_wycieczki,
    rw.kierunek AS kierunek_wycieczki,
    SUM(w.liczba_uczestnikow) AS liczba_uczestnikow
FROM 
    Rodzaje_wycieczek rw
LEFT JOIN 
    Wyjazdy w ON rw.id_rodzaj = w.id_rodzaj
GROUP BY 
    rw.id_rodzaj, rw.nazwa, rw.kierunek
ORDER BY 
    liczba_uczestnikow DESC;

-- porównanie przychodów, wydatków i sprawdzenie czy wycieczki były opłacalne
SELECT 
    rw.nazwa AS rodzaj_wycieczki,
    rw.kierunek AS kierunek_wycieczki,
    SUM(CASE WHEN tf.typ_transakcji = 'Przychód' THEN tf.kwota ELSE 0 END) AS przychod,
    SUM(CASE WHEN tf.typ_transakcji = 'Wydatek' THEN tf.kwota ELSE 0 END) AS wydatki,
    (SUM(CASE WHEN tf.typ_transakcji = 'Przychód' THEN tf.kwota ELSE 0 END) -
     SUM(CASE WHEN tf.typ_transakcji = 'Wydatek' THEN tf.kwota ELSE 0 END)) AS zysk,
    ROUND(
        (SUM(CASE WHEN tf.typ_transakcji = 'Przychód' THEN tf.kwota ELSE 0 END) -
         SUM(CASE WHEN tf.typ_transakcji = 'Wydatek' THEN tf.kwota ELSE 0 END)) / 
        NULLIF(SUM(CASE WHEN tf.typ_transakcji = 'Wydatek' THEN tf.kwota ELSE 0 END), 0) * 100, 
        2
    ) AS rentownosc_procentowa
FROM 
    Rodzaje_wycieczek rw
JOIN 
    Wyjazdy w ON rw.id_rodzaj = w.id_rodzaj
JOIN 
    Transakcje_finansowe tf ON w.id_wyjazd = tf.id_wyjazd
GROUP BY 
    rw.nazwa, rw.kierunek
ORDER BY 
    rentownosc_procentowa DESC;

--pytanie 2
-- ilu klientów było obsłużonych w każdym miesiącu działalności firmy?
SELECT 
    DATE_FORMAT(data_wyjazdu, '%Y-%m') AS rok_miesiac,
    SUM(liczba_uczestnikow) AS liczba_klientow
FROM 
    Wyjazdy
GROUP BY 
    rok_miesiac
ORDER BY 
    rok_miesiac;

--pytanie 3
-- jaki byl najczesciej wybierany kierunek w 2023 roku?
SELECT 
    r.kierunek,
    SUM(w.liczba_uczestnikow) AS liczba_uczestnikow
FROM 
    Wyjazdy w
JOIN 
    Rodzaje_wycieczek r ON w.id_rodzaj = r.id_rodzaj
WHERE 
    YEAR(w.data_wyjazdu) = 2023
GROUP BY 
    r.kierunek
ORDER BY 
    liczba_uczestnikow DESC
LIMIT 1;

--pytanie 4
-- który pracownik sprzedał najwięcej wycieczek i ile?
SELECT p.imie, p.nazwisko, COUNT(w.id_wyjazd) AS liczba_wycieczek
FROM Pracownicy p
JOIN Wyjazdy w ON p.id_pracownik = w.id_pracownik
GROUP BY p.id_pracownik
ORDER BY liczba_wycieczek DESC
LIMIT 1;

--pytanie 5
-- jaki jest średni koszt organizacji wycieczek tej samej kategorii?
SELECT 
    rw.nazwa AS nazwa_wycieczki,
    AVG(ko.koszt) AS sredni_koszt_organizacji
FROM 
    Rodzaje_wycieczek rw
JOIN 
    Wyjazdy w ON rw.id_rodzaj = w.id_rodzaj
JOIN 
    Koszty_organizacji ko ON w.id_wyjazd = ko.id_wyjazd
GROUP BY 
    rw.nazwa
ORDER BY 
    sredni_koszt_organizacji DESC;

--pytanie 6
-- która z kategorii wycieczek ma najwiekszy udzial procentowy w przychodach firmy?
SELECT 
    rw.nazwa AS nazwa_wycieczki,
    SUM(tf.kwota) AS suma_przychodow,
    CONCAT(ROUND((SUM(tf.kwota) / (SELECT SUM(tf2.kwota) FROM Transakcje_finansowe tf2 WHERE tf2.typ_transakcji = 'Przychód') * 100), 2), ' %') AS udzial_procentowy
FROM 
    Rodzaje_wycieczek rw
JOIN 
    Wyjazdy w ON rw.id_rodzaj = w.id_rodzaj
JOIN 
    Transakcje_finansowe tf ON w.id_wyjazd = tf.id_wyjazd
WHERE 
    tf.typ_transakcji = 'Przychód'
GROUP BY 
    rw.nazwa
ORDER BY 
    SUM(tf.kwota) DESC;