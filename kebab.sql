CREATE TABLE RodzajKebaba (
    RodzajID INT IDENTITY PRIMARY KEY,
    Nazwa VARCHAR(50) NOT NULL, -- np. Rollo, Bułka, Kapsalon
    CenaBazowa DECIMAL(5,2) NOT NULL
);

CREATE TABLE Mieso (
    MiesoID INT IDENTITY PRIMARY KEY,
    Nazwa VARCHAR(50) NOT NULL -- Kura, Wołowina, Baranina
);

CREATE TABLE Sos (
    SosID INT IDENTITY PRIMARY KEY,
    Nazwa VARCHAR(50) NOT NULL,
    Ostrosc INT CHECK (Ostrosc BETWEEN 1 AND 10) NOT NULL
);

-- Zastępujemy Twoje tabele 'Frytki' i 'Napoj' jedną, uniwersalną. To znacznie mądrzejsze.
CREATE TABLE Dodatek (
    DodatekID INT IDENTITY PRIMARY KEY,
    Nazwa VARCHAR(50) NOT NULL, 
    Cena DECIMAL(5,2) NOT NULL
);

-- KROK 3: ZASOBY LUDZKIE I KLIENCI
CREATE TABLE Pracownik (
    PracownikID INT IDENTITY PRIMARY KEY,
    Imie VARCHAR(50) NOT NULL,
    Nazwisko VARCHAR(50) NOT NULL,
    Stanowisko VARCHAR(50) NOT NULL
);

-- TUTAJ MASZ WYMAGANY ZWIĄZEK 1:1
-- Jeden pracownik ma jedną książeczkę. Klucz główny jest jednocześnie obcym.
CREATE TABLE KsiazeczkaSanepidowska (
    PracownikID INT PRIMARY KEY,
    WaznaDo DATE NOT NULL,
    NumerDokumentu VARCHAR(20) UNIQUE NOT NULL, -- Od razu odhaczamy wymóg UNIQUE
    CONSTRAINT FK_Sanepid_Pracownik FOREIGN KEY (PracownikID) REFERENCES Pracownik(PracownikID)
);

CREATE TABLE Klient (
    KlientID INT IDENTITY PRIMARY KEY,
    Imie VARCHAR(50) NOT NULL,
    Telefon VARCHAR(15) UNIQUE -- Telefon wchodzi zamiast nazwiska. Bardziej życiowe w apce do jedzenia.
);

-- KROK 4: KONSTRUKCJA MENU
CREATE TABLE Kebab (
    KebabID INT IDENTITY PRIMARY KEY,
    RodzajID INT NOT NULL,
    MiesoID INT NOT NULL,
    CONSTRAINT FK_Kebab_Rodzaj FOREIGN KEY (RodzajID) REFERENCES RodzajKebaba(RodzajID),
    CONSTRAINT FK_Kebab_Mieso FOREIGN KEY (MiesoID) REFERENCES Mieso(MiesoID)
);

-- TUTAJ MASZ ZWIĄZEK WIELE DO WIELU (N:M) DLA SOSÓW (np. mieszany z ostrym)
CREATE TABLE KebabSos (
    KebabID INT,
    SosID INT,
    PRIMARY KEY (KebabID, SosID),
    CONSTRAINT FK_KS_Kebab FOREIGN KEY (KebabID) REFERENCES Kebab(KebabID),
    CONSTRAINT FK_KS_Sos FOREIGN KEY (SosID) REFERENCES Sos(SosID)
);

-- KROK 5: SPRZEDAŻ (Serce operacji)
CREATE TABLE Zamowienie (
    ZamowienieID INT IDENTITY PRIMARY KEY,
    PracownikID INT NOT NULL, -- OBLIGATORYJNY (ktoś musi to wbić na kasę)
    KlientID INT, -- OPCJONALNY (NULL dopuszczony). Bo klient z ulicy nie zawsze ma u nas konto. Odhaczasz kolejny punkt projektu!
    DataZamowienia DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT FK_Zamowienie_Pracownik FOREIGN KEY (PracownikID) REFERENCES Pracownik(PracownikID),
    CONSTRAINT FK_Zamowienie_Klient FOREIGN KEY (KlientID) REFERENCES Klient(KlientID)
);

-- ZWIĄZEK WIELE DO WIELU (N:M) DLA ZAMÓWIEŃ (Jeden paragon, kilka kebabów)
CREATE TABLE ZamowienieKebab (
    ZamowienieID INT,
    KebabID INT,
    Ilosc INT NOT NULL DEFAULT 1,
    Uwagi VARCHAR(255), -- Np. "bez cebuli" albo "mało surówki"
    PRIMARY KEY (ZamowienieID, KebabID),
    CONSTRAINT FK_ZK_Zamowienie FOREIGN KEY (ZamowienieID) REFERENCES Zamowienie(ZamowienieID),
    CONSTRAINT FK_ZK_Kebab FOREIGN KEY (KebabID) REFERENCES Kebab(KebabID)
);

-- ZWIĄZEK WIELE DO WIELU (N:M) DLA DODATKÓW (Jeden paragon, kilka różnych napojów/frytek)
CREATE TABLE ZamowienieDodatek (
    ZamowienieID INT,
    DodatekID INT,
    Ilosc INT NOT NULL DEFAULT 1,
    PRIMARY KEY (ZamowienieID, DodatekID),
    CONSTRAINT FK_ZD_Zamowienie FOREIGN KEY (ZamowienieID) REFERENCES Zamowienie(ZamowienieID),
    CONSTRAINT FK_ZD_Dodatek FOREIGN KEY (DodatekID) REFERENCES Dodatek(DodatekID)
);