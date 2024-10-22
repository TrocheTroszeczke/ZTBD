// zad.1

CREATE TABLE movies
AS SELECT * FROM ZTPD.MOVIES;


// zad.2

SELECT * FROM MOVIES;


// zad.3

SELECT ID, TITLE FROM MOVIES
WHERE COVER IS NULL;


// zad.4

SELECT ID, TITLE, LENGTH(COVER) AS FILESIZE FROM MOVIES
WHERE COVER IS NOT NULL;


// zad.5

SELECT ID, TITLE, LENGTH(COVER) AS FILESIZE FROM MOVIES
WHERE COVER IS NULL;


// zad.6

SELECT DIRECTORY_NAME, DIRECTORY_PATH FROM ALL_DIRECTORIES
WHERE DIRECTORY_NAME = 'TPD_DIR';


// zad.7

UPDATE MOVIES
SET COVER = EMPTY_BLOB(), MIME_TYPE = 'image/jpeg'
WHERE ID = 66;


// zad.8

SELECT ID, TITLE, LENGTH(COVER) AS FILESIZE FROM MOVIES
WHERE ID IN (65, 66);


// zad.9

DECLARE
  new_cover BLOB;
  new_image BFILE := BFILENAME('TPD_DIR', 'escape.jpg');
BEGIN
    SELECT cover INTO new_cover 
    FROM movies
    WHERE ID = 66 
    FOR UPDATE; -- blokada wiersza
    DBMS_LOB.FILEOPEN(new_image, DBMS_LOB.LOB_READONLY);
    DBMS_LOB.LOADFROMFILE(new_cover, new_image, DBMS_LOB.GETLENGTH(new_image));
    DBMS_LOB.CLOSE(new_image);
    COMMIT;
END;


// zad.10

CREATE TABLE TEMP_COVERS (
    movie_id NUMBER(12),
    image BFILE,
    mime_type VARCHAR2(50) 
);


// zad.11

INSERT INTO TEMP_COVERS VALUES(65, BFILENAME('TPD_DIR', 'eagles.jpg'), 'image/jpeg');

SELECT * FROM TEMP_COVERS;

COMMIT;


// zad.12

SELECT movie_id, DBMS_LOB.GETLENGTH(image) AS FILESIZE 
FROM TEMP_COVERS;


// zad.13

DECLARE
  new_bfile BFILE;
  new_blob BLOB;
  new_mime VARCHAR2(50);
BEGIN
    SELECT image, mime_type INTO new_bfile, new_mime FROM TEMP_COVERS WHERE movie_id = 65;
    DBMS_LOB.CREATETEMPORARY(new_blob, TRUE);
    DBMS_LOB.OPEN(new_bfile, DBMS_LOB.LOB_READONLY);
    DBMS_LOB.LOADFROMFILE(new_blob, new_bfile, DBMS_LOB.GETLENGTH(new_bfile));
    DBMS_LOB.CLOSE(new_bfile);
    UPDATE movies SET COVER = new_blob, MIME_TYPE = new_mime WHERE ID = 65;
    DBMS_LOB.FREETEMPORARY(new_blob);
    COMMIT;
end;


// zad.14

SELECT ID, LENGTH(COVER) AS FILESIZE FROM MOVIES
WHERE ID IN (65, 66);


// zad.15

DROP TABLE movies;
