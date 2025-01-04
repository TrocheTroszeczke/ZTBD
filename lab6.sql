// zad.1A

select lpad('-',2*(level-1),'|-') || t.owner||'.'||t.type_name||' (FINAL:'||t.final||
', INSTANTIABLE:'||t.instantiable||', ATTRIBUTES:'||t.attributes||', METHODS:'||t.methods||')'
from all_types t
start with t.type_name = 'ST_GEOMETRY'
connect by prior t.type_name = t.supertype_name
and prior t.owner = t.owner;

// zad.1B

select distinct m.method_name
from all_type_methods m
where m.type_name like 'ST_POLYGON'
and m.owner = 'MDSYS'
order by 1;

// zad.1C

CREATE TABLE MYST_MAJOR_CITIES(
    FIPS_CNTRY VARCHAR2(2),
    CITY_NAME VARCHAR2(40),
    STGEOM ST_POINT
);

// zad.1D

INSERT INTO MYST_MAJOR_CITIES
    SELECT FIPS_CNTRY, CITY_NAME, ST_POINT(GEOM)
    FROM MAJOR_CITIES;
    
// zad.2A

INSERT INTO MYST_MAJOR_CITIES
VALUES('PL', 'Szczyrk', NEW ST_POINT(19.036107, 49.718655, 8307));

// zad.3A

CREATE TABLE MYST_COUNTRY_BOUNDARIES(
    FIPS_CNTRY VARCHAR2(2),
    CNTRY_NAME VARCHAR2(40),
    STGEOM ST_MULTIPOLYGON
);

// zad.3B

INSERT INTO MYST_COUNTRY_BOUNDARIES
    SELECT FIPS_CNTRY, CNTRY_NAME, ST_MULTIPOLYGON(GEOM)
    FROM COUNTRY_BOUNDARIES;
    
// zad.3C

SELECT B.STGEOM.ST_GeometryType() TYP_OBIEKTU, COUNT(*) ILE
FROM MYST_COUNTRY_BOUNDARIES B
GROUP BY B.STGEOM.ST_GeometryType();

// zad.3D

SELECT B.STGEOM.ST_ISSIMPLE()
FROM MYST_COUNTRY_BOUNDARIES B;

// zad.4A

select B.CNTRY_NAME, count(*)
from MYST_COUNTRY_BOUNDARIES B,
MYST_MAJOR_CITIES C
where C.STGEOM.ST_WITHIN(B.STGEOM) = 1
group by B.CNTRY_NAME; 

// zad.4B

select A.CNTRY_NAME A_NAME, B.CNTRY_NAME B_NAME
from MYST_COUNTRY_BOUNDARIES A,
MYST_COUNTRY_BOUNDARIES B
where A.STGEOM.ST_TOUCHES(B.STGEOM) = 1
and B.CNTRY_NAME = 'Czech Republic';

// zad.4C

select TREAT(A.STGEOM.ST_UNION(B.STGEOM) AS ST_POLYGON).ST_AREA() POWIERZCNIS
from MYST_COUNTRY_BOUNDARIES A, MYST_COUNTRY_BOUNDARIES B
where A.CNTRY_NAME = 'Czech Republic'
and B.CNTRY_NAME = 'Slovakia';

// zad.4E

select B.STGEOM.ST_DIFFERENCE(ST_GEOMETRY(W.GEOM)).ST_GeometryType() WEGRY_BEZ
from MYST_COUNTRY_BOUNDARIES B, WATER_BODIES W
where B.CNTRY_NAME = 'Hungary'
and W.name = 'Balaton';

// zad.5A/5D

explain plan for
select B.CNTRY_NAME A_NAME, count(*)
from MYST_COUNTRY_BOUNDARIES B, MYST_MAJOR_CITIES C
where SDO_WITHIN_DISTANCE(C.STGEOM, B.STGEOM,
'distance=100 unit=km') = 'TRUE'
and B.CNTRY_NAME = 'Poland'
group by B.CNTRY_NAME;

select plan_table_output from table(dbms_xplan.display);

// zad.5B

insert into USER_SDO_GEOM_METADATA
select 'MYST_MAJOR_CITIES', 'STGEOM', T.DIMINFO, T.SRID
from USER_SDO_GEOM_METADATA T
where T.TABLE_NAME = 'MAJOR_CITIES';

// zad.5C

create index MYST_MAJOR_CITIES_IDX on
MYST_MAJOR_CITIES(STGEOM)
indextype IS MDSYS.SPATIAL_INDEX;

create index MYST_COUNTRY_BOUNDARIES_IDX on
MYST_COUNTRY_BOUNDARIES(STGEOM)
indextype IS MDSYS.SPATIAL_INDEX;



