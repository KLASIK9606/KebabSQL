-- baza danych kebabu

-- struktura

CREATE TABLE RodzajKebaba (
    RodzajID INT IDENTITY PRIMARY KEY,
    Nazwa VARCHAR(50) NOT NULL,
    CenaBazowa DECIMAL(5,2) NOT NULL
);

CREATE TABLE Mieso (
    MiesoID INT IDENTITY PRIMARY KEY,
    Nazwa VARCHAR(50) NOT NULL
);

CREATE TABLE Sos (
    SosID INT IDENTITY PRIMARY KEY,
    Nazwa VARCHAR(50) NOT NULL,
    Ostrosc INT CHECK (Ostrosc BETWEEN 1 AND 10) NOT NULL
);

CREATE TABLE Dodatek (
    DodatekID INT IDENTITY PRIMARY KEY,
    Nazwa VARCHAR(50) NOT NULL,
    Cena DECIMAL(5,2) NOT NULL
);

CREATE TABLE Pracownik (
    PracownikID INT IDENTITY PRIMARY KEY,
    Imie VARCHAR(50) NOT NULL,
    Nazwisko VARCHAR(50) NOT NULL,
    Stanowisko VARCHAR(50) NOT NULL
);

CREATE TABLE KsiazeczkaSanepidowska (
    PracownikID INT PRIMARY KEY,
    WaznaDo DATE NOT NULL,
    NumerDokumentu VARCHAR(20) UNIQUE NOT NULL,
    CONSTRAINT FK_Sanepid_Pracownik FOREIGN KEY (PracownikID) REFERENCES Pracownik(PracownikID)
);

CREATE TABLE Klient (
    KlientID INT IDENTITY PRIMARY KEY,
    Imie VARCHAR(50) NOT NULL,
    Telefon VARCHAR(15) UNIQUE
);

CREATE TABLE Zamowienie (
    ZamowienieID INT IDENTITY PRIMARY KEY,
    PracownikID INT NOT NULL,
    KlientID INT,
    DataZamowienia DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Uwagi VARCHAR(150),
    CONSTRAINT FK_Zamowienie_Pracownik FOREIGN KEY (PracownikID) REFERENCES Pracownik(PracownikID),
    CONSTRAINT FK_Zamowienie_Klient FOREIGN KEY (KlientID) REFERENCES Klient(KlientID)
);

-- kazdy rekord = pojedynczy kebab zlozony w ramach jednego zamowienia
CREATE TABLE Kebab (
    KebabID INT IDENTITY PRIMARY KEY,
    RodzajID INT NOT NULL,
    ZamowienieID INT NOT NULL,
    CONSTRAINT FK_Kebab_Rodzaj FOREIGN KEY (RodzajID) REFERENCES RodzajKebaba(RodzajID),
    CONSTRAINT FK_Kebab_Zamowienie FOREIGN KEY (ZamowienieID) REFERENCES Zamowienie(ZamowienieID)
);

CREATE TABLE KebabMieso (
    KebabMieso INT IDENTITY PRIMARY KEY,
    KebabID INT NOT NULL,
    MiesoID INT NOT NULL,
    CONSTRAINT FK_KM_Kebab FOREIGN KEY (KebabID) REFERENCES Kebab(KebabID),
    CONSTRAINT FK_KM_Mieso FOREIGN KEY (MiesoID) REFERENCES Mieso(MiesoID)
);

CREATE TABLE KebabSos (
    KebabSos INT IDENTITY PRIMARY KEY,
    KebabID INT NOT NULL,
    SosID INT NOT NULL,
    CONSTRAINT FK_KS_Kebab FOREIGN KEY (KebabID) REFERENCES Kebab(KebabID),
    CONSTRAINT FK_KS_Sos FOREIGN KEY (SosID) REFERENCES Sos(SosID)
);

CREATE TABLE ZamowienieDodatek (
    ZamDodID INT IDENTITY PRIMARY KEY,
    ZamowienieID INT NOT NULL,
    DodatekID INT NOT NULL,
    Ilosc INT NOT NULL DEFAULT 1,
    CONSTRAINT FK_ZD_Zamowienie FOREIGN KEY (ZamowienieID) REFERENCES Zamowienie(ZamowienieID),
    CONSTRAINT FK_ZD_Dodatek FOREIGN KEY (DodatekID) REFERENCES Dodatek(DodatekID)
);


-- modyfikacje struktury

ALTER TABLE Klient ADD Email VARCHAR(100) NULL;

ALTER TABLE Pracownik ALTER COLUMN Stanowisko VARCHAR(80) NOT NULL;

ALTER TABLE Pracownik ADD CONSTRAINT CK_Pracownik_Stanowisko
    CHECK (Stanowisko IN ('Kucharz', 'Kasjer', 'Manager', 'Dostawca',
                          'Kierownik zmiany kuchni', 'Specjalista ds. dostaw'));

ALTER TABLE Dodatek ADD CONSTRAINT CK_Dodatek_Cena CHECK (Cena > 0);


-- dane

INSERT INTO RodzajKebaba (Nazwa, CenaBazowa) VALUES ('Maly w bulce', 15.00);
INSERT INTO RodzajKebaba (Nazwa, CenaBazowa) VALUES ('Duzy w bulce', 22.00);
INSERT INTO RodzajKebaba (Nazwa, CenaBazowa) VALUES ('Maly w tortilli', 18.00);
INSERT INTO RodzajKebaba (Nazwa, CenaBazowa) VALUES ('Duzy w tortilli', 25.00);
INSERT INTO RodzajKebaba (Nazwa, CenaBazowa) VALUES ('Kebab na talerzu', 30.00);
INSERT INTO RodzajKebaba (Nazwa, CenaBazowa) VALUES ('Kebab w pudelku', 28.00);

INSERT INTO Mieso (Nazwa) VALUES ('Wolowina');
INSERT INTO Mieso (Nazwa) VALUES ('Kurczak');
INSERT INTO Mieso (Nazwa) VALUES ('Baranina');
INSERT INTO Mieso (Nazwa) VALUES ('Mix wolowina-kurczak');
INSERT INTO Mieso (Nazwa) VALUES ('Falafel');

INSERT INTO Sos (Nazwa, Ostrosc) VALUES ('Lagodny', 1);
INSERT INTO Sos (Nazwa, Ostrosc) VALUES ('Czosnkowy', 2);
INSERT INTO Sos (Nazwa, Ostrosc) VALUES ('Mieszany', 4);
INSERT INTO Sos (Nazwa, Ostrosc) VALUES ('Ostry', 7);
INSERT INTO Sos (Nazwa, Ostrosc) VALUES ('Bardzo ostry', 9);
INSERT INTO Sos (Nazwa, Ostrosc) VALUES ('Diabelski', 10);
INSERT INTO Sos (Nazwa, Ostrosc) VALUES ('Salsa', 5);
INSERT INTO Sos (Nazwa, Ostrosc) VALUES ('Tzatziki', 1);

INSERT INTO Dodatek (Nazwa, Cena) VALUES ('Frytki', 8.00);
INSERT INTO Dodatek (Nazwa, Cena) VALUES ('Coca-Cola 0.5L', 6.00);
INSERT INTO Dodatek (Nazwa, Cena) VALUES ('Fanta 0.5L', 6.00);
INSERT INTO Dodatek (Nazwa, Cena) VALUES ('Woda mineralna', 4.00);
INSERT INTO Dodatek (Nazwa, Cena) VALUES ('Ser feta', 3.50);
INSERT INTO Dodatek (Nazwa, Cena) VALUES ('Jalapeno', 2.50);
INSERT INTO Dodatek (Nazwa, Cena) VALUES ('Dodatkowe mieso', 7.00);
INSERT INTO Dodatek (Nazwa, Cena) VALUES ('Krazki cebulowe', 9.00);

INSERT INTO Pracownik (Imie, Nazwisko, Stanowisko) VALUES ('Mehmet', 'Yilmaz', 'Kucharz');
INSERT INTO Pracownik (Imie, Nazwisko, Stanowisko) VALUES ('Ahmet', 'Demir', 'Kucharz');
INSERT INTO Pracownik (Imie, Nazwisko, Stanowisko) VALUES ('Anna', 'Kowalska', 'Kasjer');
INSERT INTO Pracownik (Imie, Nazwisko, Stanowisko) VALUES ('Piotr', 'Nowak', 'Kasjer');
INSERT INTO Pracownik (Imie, Nazwisko, Stanowisko) VALUES ('Katarzyna', 'Wisniewska', 'Manager');
INSERT INTO Pracownik (Imie, Nazwisko, Stanowisko) VALUES ('Tomasz', 'Wojcik', 'Dostawca');

INSERT INTO KsiazeczkaSanepidowska (PracownikID, WaznaDo, NumerDokumentu) VALUES (1, '2026-12-31', 'SAN/2024/001');
INSERT INTO KsiazeczkaSanepidowska (PracownikID, WaznaDo, NumerDokumentu) VALUES (2, '2027-03-15', 'SAN/2024/002');
INSERT INTO KsiazeczkaSanepidowska (PracownikID, WaznaDo, NumerDokumentu) VALUES (3, '2026-08-20', 'SAN/2024/003');
INSERT INTO KsiazeczkaSanepidowska (PracownikID, WaznaDo, NumerDokumentu) VALUES (4, '2026-11-10', 'SAN/2024/004');
INSERT INTO KsiazeczkaSanepidowska (PracownikID, WaznaDo, NumerDokumentu) VALUES (5, '2027-01-05', 'SAN/2024/005');
INSERT INTO KsiazeczkaSanepidowska (PracownikID, WaznaDo, NumerDokumentu) VALUES (6, '2026-09-30', 'SAN/2024/006');

INSERT INTO Klient (Imie, Telefon) VALUES ('Jan', '500100200');
INSERT INTO Klient (Imie, Telefon) VALUES ('Marta', '511222333');
INSERT INTO Klient (Imie, Telefon) VALUES ('Krzysztof', '602345678');
INSERT INTO Klient (Imie, Telefon) VALUES ('Magdalena', '603987654');
INSERT INTO Klient (Imie, Telefon) VALUES ('Pawel', '604555666');
INSERT INTO Klient (Imie, Telefon) VALUES ('Aleksandra', '605111222');
INSERT INTO Klient (Imie, Telefon) VALUES ('Bartosz', NULL);

INSERT INTO Zamowienie (PracownikID, KlientID, DataZamowienia, Uwagi) VALUES (3, 1, '2026-05-20 12:15:00', 'Bez cebuli');
INSERT INTO Zamowienie (PracownikID, KlientID, DataZamowienia, Uwagi) VALUES (3, 2, '2026-05-20 13:30:00', NULL);
INSERT INTO Zamowienie (PracownikID, KlientID, DataZamowienia, Uwagi) VALUES (4, 3, '2026-05-21 18:45:00', 'Na wynos');
INSERT INTO Zamowienie (PracownikID, KlientID, DataZamowienia, Uwagi) VALUES (4, NULL, '2026-05-22 14:00:00', 'Klient anonimowy');
INSERT INTO Zamowienie (PracownikID, KlientID, DataZamowienia, Uwagi) VALUES (3, 4, '2026-05-23 19:20:00', 'Extra ostry sos');
INSERT INTO Zamowienie (PracownikID, KlientID, DataZamowienia, Uwagi) VALUES (4, 5, '2026-05-24 20:10:00', NULL);
INSERT INTO Zamowienie (PracownikID, KlientID, DataZamowienia, Uwagi) VALUES (3, 6, '2026-05-25 11:05:00', 'Dostawa pod drzwi');
INSERT INTO Zamowienie (PracownikID, KlientID, DataZamowienia, Uwagi) VALUES (4, 7, '2026-05-26 15:50:00', NULL);

INSERT INTO Kebab (RodzajID, ZamowienieID) VALUES (1, 1);
INSERT INTO Kebab (RodzajID, ZamowienieID) VALUES (2, 1);
INSERT INTO Kebab (RodzajID, ZamowienieID) VALUES (3, 2);
INSERT INTO Kebab (RodzajID, ZamowienieID) VALUES (4, 3);
INSERT INTO Kebab (RodzajID, ZamowienieID) VALUES (5, 3);
INSERT INTO Kebab (RodzajID, ZamowienieID) VALUES (6, 4);
INSERT INTO Kebab (RodzajID, ZamowienieID) VALUES (2, 5);
INSERT INTO Kebab (RodzajID, ZamowienieID) VALUES (4, 5);
INSERT INTO Kebab (RodzajID, ZamowienieID) VALUES (1, 6);
INSERT INTO Kebab (RodzajID, ZamowienieID) VALUES (5, 7);
INSERT INTO Kebab (RodzajID, ZamowienieID) VALUES (2, 7);
INSERT INTO Kebab (RodzajID, ZamowienieID) VALUES (1, 8);

-- kebab 4 to mix wolowiny i kurczaka
INSERT INTO KebabMieso (KebabID, MiesoID) VALUES (1, 2);
INSERT INTO KebabMieso (KebabID, MiesoID) VALUES (2, 1);
INSERT INTO KebabMieso (KebabID, MiesoID) VALUES (3, 2);
INSERT INTO KebabMieso (KebabID, MiesoID) VALUES (4, 1);
INSERT INTO KebabMieso (KebabID, MiesoID) VALUES (4, 2);
INSERT INTO KebabMieso (KebabID, MiesoID) VALUES (5, 3);
INSERT INTO KebabMieso (KebabID, MiesoID) VALUES (6, 1);
INSERT INTO KebabMieso (KebabID, MiesoID) VALUES (7, 5);
INSERT INTO KebabMieso (KebabID, MiesoID) VALUES (8, 2);
INSERT INTO KebabMieso (KebabID, MiesoID) VALUES (9, 1);
INSERT INTO KebabMieso (KebabID, MiesoID) VALUES (10, 2);
INSERT INTO KebabMieso (KebabID, MiesoID) VALUES (11, 1);
INSERT INTO KebabMieso (KebabID, MiesoID) VALUES (12, 2);

INSERT INTO KebabSos (KebabID, SosID) VALUES (1, 1);
INSERT INTO KebabSos (KebabID, SosID) VALUES (1, 2);
INSERT INTO KebabSos (KebabID, SosID) VALUES (2, 4);
INSERT INTO KebabSos (KebabID, SosID) VALUES (2, 2);
INSERT INTO KebabSos (KebabID, SosID) VALUES (3, 3);
INSERT INTO KebabSos (KebabID, SosID) VALUES (4, 5);
INSERT INTO KebabSos (KebabID, SosID) VALUES (4, 7);
INSERT INTO KebabSos (KebabID, SosID) VALUES (5, 8);
INSERT INTO KebabSos (KebabID, SosID) VALUES (6, 6);
INSERT INTO KebabSos (KebabID, SosID) VALUES (7, 1);
INSERT INTO KebabSos (KebabID, SosID) VALUES (7, 8);
INSERT INTO KebabSos (KebabID, SosID) VALUES (8, 4);
INSERT INTO KebabSos (KebabID, SosID) VALUES (9, 2);
INSERT INTO KebabSos (KebabID, SosID) VALUES (10, 3);
INSERT INTO KebabSos (KebabID, SosID) VALUES (10, 7);
INSERT INTO KebabSos (KebabID, SosID) VALUES (11, 4);
INSERT INTO KebabSos (KebabID, SosID) VALUES (11, 2);
INSERT INTO KebabSos (KebabID, SosID) VALUES (12, 1);
INSERT INTO KebabSos (KebabID, SosID) VALUES (12, 2);

INSERT INTO ZamowienieDodatek (ZamowienieID, DodatekID, Ilosc) VALUES (1, 1, 1);
INSERT INTO ZamowienieDodatek (ZamowienieID, DodatekID, Ilosc) VALUES (1, 2, 2);
INSERT INTO ZamowienieDodatek (ZamowienieID, DodatekID, Ilosc) VALUES (2, 4, 1);
INSERT INTO ZamowienieDodatek (ZamowienieID, DodatekID, Ilosc) VALUES (3, 1, 2);
INSERT INTO ZamowienieDodatek (ZamowienieID, DodatekID, Ilosc) VALUES (3, 3, 2);
INSERT INTO ZamowienieDodatek (ZamowienieID, DodatekID, Ilosc) VALUES (4, 8, 1);
INSERT INTO ZamowienieDodatek (ZamowienieID, DodatekID, Ilosc) VALUES (5, 6, 1);
INSERT INTO ZamowienieDodatek (ZamowienieID, DodatekID, Ilosc) VALUES (5, 7, 1);
INSERT INTO ZamowienieDodatek (ZamowienieID, DodatekID, Ilosc) VALUES (6, 2, 1);
INSERT INTO ZamowienieDodatek (ZamowienieID, DodatekID, Ilosc) VALUES (6, 5, 1);
INSERT INTO ZamowienieDodatek (ZamowienieID, DodatekID, Ilosc) VALUES (7, 1, 1);
INSERT INTO ZamowienieDodatek (ZamowienieID, DodatekID, Ilosc) VALUES (7, 4, 2);
INSERT INTO ZamowienieDodatek (ZamowienieID, DodatekID, Ilosc) VALUES (8, 1, 1);


-- aktualizacje

UPDATE RodzajKebaba SET CenaBazowa = CenaBazowa * 1.10 WHERE Nazwa LIKE '%Duzy%';

UPDATE Pracownik SET Stanowisko = 'Manager' WHERE Imie = 'Anna' AND Nazwisko = 'Kowalska';

UPDATE KsiazeczkaSanepidowska SET WaznaDo = '2027-12-31' WHERE PracownikID = 1;

UPDATE Zamowienie SET Uwagi = 'Bez cebuli, extra sos' WHERE ZamowienieID = 2;

UPDATE ZamowienieDodatek SET Ilosc = 3 WHERE ZamowienieID = 1 AND DodatekID = 2;


-- usuwanie

DELETE FROM Sos WHERE SosID NOT IN (SELECT SosID FROM KebabSos);

DELETE FROM Klient
WHERE Telefon IS NULL
  AND KlientID NOT IN (SELECT KlientID FROM Zamowienie WHERE KlientID IS NOT NULL);

GO

-- widoki

CREATE VIEW v_PodsumowanieZamowien AS
SELECT
    z.ZamowienieID,
    z.DataZamowienia,
    ISNULL(k.Imie, 'Anonimowy') AS Klient,
    ISNULL(k.Telefon, 'brak') AS Telefon,
    p.Imie + ' ' + p.Nazwisko AS ObslugujacyPracownik,
    p.Stanowisko,
    (SELECT COUNT(*) FROM Kebab keb WHERE keb.ZamowienieID = z.ZamowienieID) AS LiczbaKebabow,
    (SELECT ISNULL(SUM(rk.CenaBazowa), 0)
     FROM Kebab keb
     INNER JOIN RodzajKebaba rk ON keb.RodzajID = rk.RodzajID
     WHERE keb.ZamowienieID = z.ZamowienieID) AS WartoscKebabow,
    (SELECT ISNULL(SUM(d.Cena * zd.Ilosc), 0)
     FROM ZamowienieDodatek zd
     INNER JOIN Dodatek d ON zd.DodatekID = d.DodatekID
     WHERE zd.ZamowienieID = z.ZamowienieID) AS WartoscDodatkow,
    z.Uwagi
FROM Zamowienie z
INNER JOIN Pracownik p ON z.PracownikID = p.PracownikID
LEFT JOIN Klient k ON z.KlientID = k.KlientID;
GO

CREATE VIEW v_Menu AS
SELECT
    k.KebabID,
    k.ZamowienieID,
    rk.Nazwa AS RodzajKebaba,
    rk.CenaBazowa,
    m.Nazwa AS Mieso,
    s.Nazwa AS Sos,
    s.Ostrosc
FROM Kebab k
INNER JOIN RodzajKebaba rk ON k.RodzajID = rk.RodzajID
INNER JOIN KebabMieso km ON km.KebabID = k.KebabID
INNER JOIN Mieso m ON km.MiesoID = m.MiesoID
INNER JOIN KebabSos ks ON ks.KebabID = k.KebabID
INNER JOIN Sos s ON ks.SosID = s.SosID;
GO


-- zapytania

-- zamowienia z konkretnego dnia
SELECT ZamowienieID, DataZamowienia, Uwagi
FROM Zamowienie
WHERE DataZamowienia >= '2026-05-23' AND DataZamowienia < '2026-05-24';

-- sosy w danym zakresie ostrosci albo z listy nazw
SELECT Nazwa, Ostrosc
FROM Sos
WHERE Ostrosc BETWEEN 3 AND 7
   OR Nazwa IN ('Diabelski', 'Tzatziki')
ORDER BY Ostrosc;

-- szczegoly zamowien: pracownik, klient, kebab, mieso
SELECT
    z.ZamowienieID,
    z.DataZamowienia,
    k.Imie AS Klient,
    k.Telefon,
    p.Imie + ' ' + p.Nazwisko AS Pracownik,
    keb.KebabID,
    rk.Nazwa AS RodzajKebaba,
    m.Nazwa AS Mieso,
    rk.CenaBazowa,
    z.Uwagi
FROM Zamowienie z
INNER JOIN Pracownik p ON z.PracownikID = p.PracownikID
LEFT JOIN Klient k ON z.KlientID = k.KlientID
INNER JOIN Kebab keb ON keb.ZamowienieID = z.ZamowienieID
INNER JOIN RodzajKebaba rk ON keb.RodzajID = rk.RodzajID
INNER JOIN KebabMieso km ON km.KebabID = keb.KebabID
INNER JOIN Mieso m ON km.MiesoID = m.MiesoID
ORDER BY z.ZamowienieID, keb.KebabID;

-- wartosc kazdego zamowienia (kebaby + dodatki)
SELECT
    z.ZamowienieID,
    z.DataZamowienia,
    ISNULL(k.Imie, 'Anonimowy') AS Klient,
    SUM(rk.CenaBazowa) AS WartoscKebabow,
    (SELECT ISNULL(SUM(d.Cena * zd.Ilosc), 0)
     FROM ZamowienieDodatek zd
     INNER JOIN Dodatek d ON zd.DodatekID = d.DodatekID
     WHERE zd.ZamowienieID = z.ZamowienieID) AS WartoscDodatkow,
    SUM(rk.CenaBazowa) +
    (SELECT ISNULL(SUM(d.Cena * zd.Ilosc), 0)
     FROM ZamowienieDodatek zd
     INNER JOIN Dodatek d ON zd.DodatekID = d.DodatekID
     WHERE zd.ZamowienieID = z.ZamowienieID) AS Razem
FROM Zamowienie z
LEFT JOIN Klient k ON z.KlientID = k.KlientID
INNER JOIN Kebab keb ON keb.ZamowienieID = z.ZamowienieID
INNER JOIN RodzajKebaba rk ON keb.RodzajID = rk.RodzajID
GROUP BY z.ZamowienieID, z.DataZamowienia, k.Imie
ORDER BY Razem DESC;

-- pracownicy z wiecej niz jednym zamowieniem
SELECT
    p.PracownikID,
    p.Imie + ' ' + p.Nazwisko AS Pracownik,
    COUNT(z.ZamowienieID) AS LiczbaZamowien
FROM Pracownik p
INNER JOIN Zamowienie z ON p.PracownikID = z.PracownikID
GROUP BY p.PracownikID, p.Imie, p.Nazwisko
HAVING COUNT(z.ZamowienieID) > 1
ORDER BY LiczbaZamowien DESC;

-- popularnosc miesa
SELECT
    m.Nazwa AS Mieso,
    COUNT(km.KebabMieso) AS LiczbaUzyc
FROM Mieso m
LEFT JOIN KebabMieso km ON m.MiesoID = km.MiesoID
GROUP BY m.MiesoID, m.Nazwa
ORDER BY LiczbaUzyc DESC;

-- kategorie sosow wg ostrosci
SELECT
    Nazwa,
    Ostrosc,
    CASE
        WHEN Ostrosc <= 2 THEN 'Lagodny'
        WHEN Ostrosc BETWEEN 3 AND 5 THEN 'Sredni'
        WHEN Ostrosc BETWEEN 6 AND 8 THEN 'Ostry'
        ELSE 'Pieklo'
    END AS Kategoria
FROM Sos
ORDER BY Ostrosc;

-- status ksiazeczek sanepidowskich
SELECT
    p.Imie + ' ' + p.Nazwisko AS Pracownik,
    p.Stanowisko,
    ks.NumerDokumentu,
    ks.WaznaDo,
    CASE
        WHEN ks.WaznaDo < GETDATE() THEN 'NIEWAZNA'
        WHEN ks.WaznaDo < DATEADD(MONTH, 3, GETDATE()) THEN 'WKROTCE WYGASA'
        ELSE 'AKTUALNA'
    END AS Status
FROM Pracownik p
INNER JOIN KsiazeczkaSanepidowska ks ON p.PracownikID = ks.PracownikID
ORDER BY ks.WaznaDo;

-- pelen sklad kebabow
SELECT
    k.KebabID,
    k.ZamowienieID,
    rk.Nazwa AS Rodzaj,
    m.Nazwa AS Mieso,
    s.Nazwa AS Sos,
    s.Ostrosc
FROM Kebab k
INNER JOIN RodzajKebaba rk ON k.RodzajID = rk.RodzajID
INNER JOIN KebabMieso km ON k.KebabID = km.KebabID
INNER JOIN Mieso m ON km.MiesoID = m.MiesoID
INNER JOIN KebabSos ks ON k.KebabID = ks.KebabID
INNER JOIN Sos s ON ks.SosID = s.SosID
ORDER BY k.KebabID, s.Ostrosc;

-- top 3 dodatki
SELECT TOP 3
    d.Nazwa,
    d.Cena,
    SUM(zd.Ilosc) AS LacznaIlosc,
    SUM(zd.Ilosc * d.Cena) AS LacznyPrzychod
FROM Dodatek d
INNER JOIN ZamowienieDodatek zd ON d.DodatekID = zd.DodatekID
GROUP BY d.DodatekID, d.Nazwa, d.Cena
ORDER BY LacznaIlosc DESC;

-- podsumowanie z widoku
SELECT *, (WartoscKebabow + WartoscDodatkow) AS Razem
FROM v_PodsumowanieZamowien
ORDER BY DataZamowienia DESC;

SELECT * FROM v_Menu ORDER BY CenaBazowa DESC, KebabID;


-- sprawdzenie konkretnego zamowienia
DECLARE @ZamowienieID INT = 2;

SELECT * FROM v_PodsumowanieZamowien WHERE ZamowienieID = @ZamowienieID;

SELECT
    k.KebabID,
    rk.Nazwa AS Kebab,
    m.Nazwa AS Mieso,
    rk.CenaBazowa AS Cena
FROM Kebab k
INNER JOIN RodzajKebaba rk ON k.RodzajID = rk.RodzajID
INNER JOIN KebabMieso km ON km.KebabID = k.KebabID
INNER JOIN Mieso m ON km.MiesoID = m.MiesoID
WHERE k.ZamowienieID = @ZamowienieID
ORDER BY k.KebabID;

SELECT
    k.KebabID,
    rk.Nazwa AS Kebab,
    s.Nazwa AS Sos,
    s.Ostrosc
FROM Kebab k
INNER JOIN RodzajKebaba rk ON k.RodzajID = rk.RodzajID
INNER JOIN KebabSos ks ON ks.KebabID = k.KebabID
INNER JOIN Sos s ON ks.SosID = s.SosID
WHERE k.ZamowienieID = @ZamowienieID
ORDER BY k.KebabID, s.Ostrosc;

SELECT
    d.Nazwa AS Dodatek,
    zd.Ilosc,
    d.Cena,
    (zd.Ilosc * d.Cena) AS Suma
FROM ZamowienieDodatek zd
INNER JOIN Dodatek d ON zd.DodatekID = d.DodatekID
WHERE zd.ZamowienieID = @ZamowienieID;
