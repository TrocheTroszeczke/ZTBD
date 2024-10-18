// zad.1

CREATE TYPE samochod AS OBJECT (
 marka VARCHAR2(20),
 model VARCHAR2(20),
 kilometry NUMBER,
 data_produkcji DATE,
 cena NUMBER(10,2)
);

CREATE TABLE samochody
OF samochod;

INSERT INTO samochody VALUES
    (NEW samochod('FIAT', 'BRAVA', 60000, DATE '1999-11-30', 25000));

INSERT INTO samochody VALUES
    (NEW samochod('FORD', 'MONDEO', 80000, DATE '1997-05-10', 45000));
    
INSERT INTO samochody VALUES
    (NEW samochod('MAZDA', '323', 12000, DATE '2000-09-22', 52000));
    
DESC samochod;

SELECT * FROM samochody;


// zad.2

CREATE TABLE wlasciciele (
 imie VARCHAR2(100),
 nazwisko VARCHAR2(100),
 auto samochod
);

INSERT INTO wlasciciele VALUES
    ('JAN', 'KOWALSKI', samochod('FIAT', 'SEICENTO', 30000, DATE '2010-02-12', 19500));

INSERT INTO wlasciciele VALUES
    ('ADAM', 'NOWAK', samochod('OPEL', 'ASTRA', 34000, DATE '2009-01-06', 33700));

SELECT * FROM wlasciciele;


// zad.3
// inny wynik (?)

ALTER TYPE samochod REPLACE AS OBJECT (
 marka VARCHAR2(20),
 model VARCHAR2(20),
 kilometry NUMBER,
 data_produkcji DATE,
 cena NUMBER(10,2),
 MEMBER FUNCTION wartosc RETURN NUMBER);
 
CREATE OR REPLACE TYPE BODY samochod AS
 MEMBER FUNCTION wartosc RETURN NUMBER IS
     BEGIN
        RETURN cena * POWER(0.9, (EXTRACT (YEAR FROM CURRENT_DATE) - EXTRACT (YEAR FROM data_produkcji)));
     END wartosc;
END;

DESC samochod;

SELECT s.marka, s.cena, s.data_produkcji, s.wartosc() FROM SAMOCHODY s;


// zad.4

ALTER TYPE samochod ADD MAP MEMBER FUNCTION odwzoruj
RETURN NUMBER CASCADE INCLUDING TABLE DATA;

CREATE OR REPLACE TYPE BODY samochod AS
 MEMBER FUNCTION wartosc RETURN NUMBER IS
     BEGIN
        RETURN cena * POWER(0.9, (EXTRACT (YEAR FROM CURRENT_DATE) - EXTRACT (YEAR FROM data_produkcji)));
     END wartosc;

  MAP MEMBER FUNCTION odwzoruj RETURN NUMBER IS
     BEGIN
        RETURN (EXTRACT (YEAR FROM CURRENT_DATE) - EXTRACT (YEAR FROM data_produkcji)
            + kilometry / 1000);
     END odwzoruj; 
END;

SELECT * FROM SAMOCHODY s ORDER BY VALUE(s);


// zad.5

CREATE TYPE wlasciciel AS OBJECT (
 imie VARCHAR2(100),
 nazwisko VARCHAR2(100)
);

CREATE TABLE wlasciciele2
OF wlasciciel;

DELETE FROM samochody;

ALTER TYPE samochod
ADD ATTRIBUTE wlasciciel_auta REF wlasciciel CASCADE;

ALTER TABLE samochody ADD
SCOPE FOR(wlasciciel_auta) IS wlasciciele2;

INSERT INTO wlasciciele2 VALUES
    (NEW wlasciciel('JAN', 'KOWALSKI'));
    
INSERT INTO samochody VALUES
    (NEW samochod('FIAT', 'BRAVA', 60000, DATE '1999-11-30', 25000, (
        SELECT REF(w) FROM wlasciciele2 w
        WHERE w.imie='JAN' AND w.nazwisko='KOWALSKI')));

select * from wlasciciele2;
select * from samochody;


--- KOLEJKI ---

// zad.6

DECLARE
 TYPE t_przedmioty IS VARRAY(10) OF VARCHAR2(20);
 moje_przedmioty t_przedmioty := t_przedmioty('');
BEGIN
 moje_przedmioty(1) := 'MATEMATYKA';
 moje_przedmioty.EXTEND(9);
 FOR i IN 2..10 LOOP
 moje_przedmioty(i) := 'PRZEDMIOT_' || i;
 END LOOP;
 FOR i IN moje_przedmioty.FIRST()..moje_przedmioty.LAST() LOOP
 DBMS_OUTPUT.PUT_LINE(moje_przedmioty(i));
 END LOOP;
 moje_przedmioty.TRIM(2);
 FOR i IN moje_przedmioty.FIRST()..moje_przedmioty.LAST() LOOP
 DBMS_OUTPUT.PUT_LINE(moje_przedmioty(i));
 END LOOP;
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
 moje_przedmioty.EXTEND();
 moje_przedmioty(9) := 9;
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
 moje_przedmioty.DELETE();
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
END;


// zad.7

DECLARE
 TYPE t_ksiazki IS VARRAY(10) OF VARCHAR2(20);
 moje_ksiazki t_ksiazki := t_ksiazki('');
BEGIN
 moje_ksiazki(1) := 'TYTUL_1';
 moje_ksiazki.EXTEND(4);
 FOR i IN 2..5 LOOP
 moje_ksiazki(i) := 'TYTUL_' || i;
 END LOOP;
 FOR i IN moje_ksiazki.FIRST()..moje_ksiazki.LAST() LOOP
 DBMS_OUTPUT.PUT_LINE(moje_ksiazki(i));
 END LOOP;
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_ksiazki.COUNT());
 moje_ksiazki.TRIM(2);
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_ksiazki.COUNT());
END; 


// zad.8

DECLARE
 TYPE t_wykladowcy IS TABLE OF VARCHAR2(20);
 moi_wykladowcy t_wykladowcy := t_wykladowcy();
BEGIN
 moi_wykladowcy.EXTEND(2);
 moi_wykladowcy(1) := 'MORZY';
 moi_wykladowcy(2) := 'WOJCIECHOWSKI';
 moi_wykladowcy.EXTEND(8);
 FOR i IN 3..10 LOOP
 moi_wykladowcy(i) := 'WYKLADOWCA_' || i;
 END LOOP;
 FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
 DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
 END LOOP;
 moi_wykladowcy.TRIM(2);
 FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
 DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
 END LOOP;
 moi_wykladowcy.DELETE(5,7);
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moi_wykladowcy.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moi_wykladowcy.COUNT());
 FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
 IF moi_wykladowcy.EXISTS(i) THEN
 DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
 END IF;
 END LOOP;
 moi_wykladowcy(5) := 'ZAKRZEWICZ';
 moi_wykladowcy(6) := 'KROLIKOWSKI';
 moi_wykladowcy(7) := 'KOSZLAJDA';
 FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
 IF moi_wykladowcy.EXISTS(i) THEN
 DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
 END IF;
 END LOOP;
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moi_wykladowcy.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moi_wykladowcy.COUNT());
END;


// zad.9

DECLARE
 TYPE t_miesiace IS TABLE OF VARCHAR2(20);
 moje_miesiace t_miesiace := t_miesiace();
BEGIN
 moje_miesiace.EXTEND(12);
 moje_miesiace(1) := 'STYCZEÑ';
 moje_miesiace(2) := 'LUTY';
 moje_miesiace(3) := 'MARZEC';
 moje_miesiace(4) := 'KWIECIEN';
 moje_miesiace(5) := 'MAJ';
 moje_miesiace(6) := 'CZERWIEC';
 moje_miesiace(7) := 'LIPIEC';
 moje_miesiace(8) := 'SIERPIEN';
 moje_miesiace(9) := 'WRZESIEN';
 moje_miesiace(10) := 'PAZDZIERNIK';
 moje_miesiace(11) := 'LISTOPAD';
 moje_miesiace(12) := 'GRUDZIEN';
 
 FOR i IN moje_miesiace.FIRST()..moje_miesiace.LAST() LOOP
  DBMS_OUTPUT.PUT_LINE(moje_miesiace(i));
 END LOOP;
 
 moje_miesiace.DELETE(2,5);
 FOR I IN moje_miesiace.FIRST()..moje_miesiace.LAST() LOOP
        IF moje_miesiace.EXISTS(I) THEN
            DBMS_OUTPUT.PUT_LINE(moje_miesiace(I));
        END IF;
    END LOOP;
END;


// zad.10

CREATE TYPE jezyki_obce AS VARRAY(10) OF VARCHAR2(20);
/
CREATE TYPE stypendium AS OBJECT (
 nazwa VARCHAR2(50),
 kraj VARCHAR2(30),
 jezyki jezyki_obce );
/
CREATE TABLE stypendia OF stypendium;
INSERT INTO stypendia VALUES
('SOKRATES','FRANCJA',jezyki_obce('ANGIELSKI','FRANCUSKI','NIEMIECKI'));
INSERT INTO stypendia VALUES
('ERASMUS','NIEMCY',jezyki_obce('ANGIELSKI','NIEMIECKI','HISZPANSKI'));
SELECT * FROM stypendia;
SELECT s.jezyki FROM stypendia s;
UPDATE STYPENDIA
SET jezyki = jezyki_obce('ANGIELSKI','NIEMIECKI','HISZPANSKI','FRANCUSKI')
WHERE nazwa = 'ERASMUS';
CREATE TYPE lista_egzaminow AS TABLE OF VARCHAR2(20);
/
CREATE TYPE semestr AS OBJECT (
 numer NUMBER,
 egzaminy lista_egzaminow );
/
CREATE TABLE semestry OF semestr
NESTED TABLE egzaminy STORE AS tab_egzaminy;
INSERT INTO semestry VALUES
(semestr(1,lista_egzaminow('MATEMATYKA','LOGIKA','ALGEBRA')));
INSERT INTO semestry VALUES
(semestr(2,lista_egzaminow('BAZY DANYCH','SYSTEMY OPERACYJNE')));
SELECT s.numer, e.*
FROM semestry s, TABLE(s.egzaminy) e;
SELECT e.*
FROM semestry s, TABLE ( s.egzaminy ) e;
SELECT * FROM TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=1 );
INSERT INTO TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 )
VALUES ('METODY NUMERYCZNE');
UPDATE TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 ) e
SET e.column_value = 'SYSTEMY ROZPROSZONE'
WHERE e.column_value = 'SYSTEMY OPERACYJNE';
DELETE FROM TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 ) e
WHERE e.column_value = 'BAZY DANYCH';


// zad. 11

CREATE TYPE produkt AS OBJECT (
    nazwa VARCHAR(20),
    cena NUMBER
);

CREATE TYPE koszyk_produktow AS TABLE OF produkt;

CREATE TYPE zakup_produktu AS OBJECT (
    data_zakupu DATE,
    koszyk koszyk_produktow
);

CREATE TABLE zakupy OF zakup_produktu
    NESTED TABLE koszyk STORE AS produkty;

INSERT INTO zakupy VALUES (
    TO_DATE('01-01-2017', 'dd-mm-yyyy'),
    koszyk_produktow(
        new produkt('mleko', 4.50),
        new produkt('czekolada', 6.00)
    )
);

INSERT INTO zakupy VALUES (
    TO_DATE('18-10-2024', 'dd-mm-yyyy'),
    koszyk_produktow(
        new produkt('sok pomaranczowy', 5.80),
        new produkt('herbata', 19.50)
    )
);

SELECT z.*, k.* FROM zakupy z, TABLE ( z.KOSZYK ) k;

DELETE FROM zakupy WHERE EXISTS (
    SELECT * FROM TABLE ( KOSZYK ) k WHERE k.nazwa = 'herbata'
);

SELECT z.*, k.* FROM zakupy z, TABLE ( z.KOSZYK ) k;


--- POLIMORFIZM, DZIEDZICZENIE ---

// zad. 12

CREATE TYPE instrument AS OBJECT (
 nazwa VARCHAR2(20),
 dzwiek VARCHAR2(20),
 MEMBER FUNCTION graj RETURN VARCHAR2 ) NOT FINAL;
CREATE TYPE BODY instrument AS
 MEMBER FUNCTION graj RETURN VARCHAR2 IS
 BEGIN
 RETURN dzwiek;
 END;
END;
/
CREATE TYPE instrument_dety UNDER instrument (
 material VARCHAR2(20),
 OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2,
 MEMBER FUNCTION graj(glosnosc VARCHAR2) RETURN VARCHAR2 );
CREATE OR REPLACE TYPE BODY instrument_dety AS
 OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 IS
 BEGIN
 RETURN 'dmucham: '||dzwiek;
 END;
 MEMBER FUNCTION graj(glosnosc VARCHAR2) RETURN VARCHAR2 IS
 BEGIN
 RETURN glosnosc||':'||dzwiek;
 END;
END;
/
CREATE TYPE instrument_klawiszowy UNDER instrument (
 producent VARCHAR2(20),
 OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 );
CREATE OR REPLACE TYPE BODY instrument_klawiszowy AS
 OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 IS
 BEGIN
 RETURN 'stukam w klawisze: '||dzwiek;
 END;
END;
/
DECLARE
 tamburyn instrument := instrument('tamburyn','brzdek-brzdek');
 trabka instrument_dety := instrument_dety('trabka','tra-ta-ta','metalowa');
 fortepian instrument_klawiszowy := instrument_klawiszowy('fortepian','pingping','steinway');
BEGIN
 dbms_output.put_line(tamburyn.graj);
 dbms_output.put_line(trabka.graj);
 dbms_output.put_line(trabka.graj('glosno'));
 dbms_output.put_line(fortepian.graj);
END;


// zad.13

CREATE TYPE istota AS OBJECT (
 nazwa VARCHAR2(20),
 NOT INSTANTIABLE MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR )
 NOT INSTANTIABLE NOT FINAL;
CREATE TYPE lew UNDER istota (
 liczba_nog NUMBER,
 OVERRIDING MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR );
CREATE OR REPLACE TYPE BODY lew AS
 OVERRIDING MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR IS
 BEGIN
 RETURN 'upolowana ofiara: '||ofiara;
 END;
END;
DECLARE
 KrolLew lew := lew('LEW',4);
 InnaIstota istota := istota('JAKIES ZWIERZE');
BEGIN
 DBMS_OUTPUT.PUT_LINE( KrolLew.poluj('antylopa') );
END;

// zad.14

DECLARE
 tamburyn instrument;
 cymbalki instrument;
 trabka instrument_dety;
 saksofon instrument_dety;
BEGIN
 tamburyn := instrument('tamburyn','brzdek-brzdek');
 cymbalki := instrument_dety('cymbalki','ding-ding','metalowe');
 trabka := instrument_dety('trabka','tra-ta-ta','metalowa');
 -- saksofon := instrument('saksofon','tra-taaaa');
 -- saksofon := TREAT( instrument('saksofon','tra-taaaa') AS instrument_dety);
END;


// zad.15

CREATE TABLE instrumenty OF instrument;
INSERT INTO instrumenty VALUES ( instrument('tamburyn','brzdek-brzdek') );
INSERT INTO instrumenty VALUES ( instrument_dety('trabka','tra-ta-ta','metalowa')
);
INSERT INTO instrumenty VALUES ( instrument_klawiszowy('fortepian','pingping','steinway') );
SELECT i.nazwa, i.graj() FROM instrumenty i;

