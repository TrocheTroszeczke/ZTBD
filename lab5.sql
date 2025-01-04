// zad.1A

insert into user_sdo_geom_metadata
values ('figury', 'ksztalt',
    mdsys.sdo_dim_array(
        mdsys.sdo_dim_element('X', 0, 10, 0.01),
        mdsys.sdo_dim_element('Y', 0, 10, 0.01)),
        null);

//zad.1B

select SDO_TUNE.ESTIMATE_RTREE_INDEX_SIZE(3000000,8192,10,2,0)
from user_sdo_geom_metadata;

// zad.1C

create index user_sdo_geom_metadata_idx
on figury(ksztalt)
indextype is mdsys.spatial_index_v2;

// zad.1D

select ID
from FIGURY
where SDO_FILTER(KSZTALT, 
    SDO_GEOMETRY(2001,null,
    SDO_POINT_TYPE(3,3,null),
    null,null)) = 'TRUE';
    
// zad. 1E

select ID
from FIGURY
where SDO_RELATE(KSZTALT,
    SDO_GEOMETRY(2001,null,
    SDO_POINT_TYPE(3,3,null),
    null,null),
    'mask=ANYINTERACT') = 'TRUE';
    
    

// zad.2A

select city_name as miasto, sdo_nn_distance(1) as odl
from major_cities
where city_name != 'Warsaw' and
    sdo_nn(geom, 
        (select geom from major_cities
        where city_name = 'Warsaw'),
        'sdo_num_res=10 unit=km', 1) = 'TRUE';
        
// zad.2B

select city_name as miasto
from major_cities
where city_name != 'Warsaw' and
    sdo_within_distance(geom, 
        (select geom from major_cities
        where city_name = 'Warsaw'),
        'distance=100 unit=km') = 'TRUE';
        
// zad.2C

select cntry_name as kraj, city_name as miasto
from major_cities
where sdo_relate(geom,
    (select geom from country_boundaries
    where cntry_name = 'Slovakia'),
    'mask=ANYINTERACT') = 'TRUE';
    
// zad.2D

select cntry_name as panstwo, sdo_nn_distance(1) as odl
from country_boundaries
where cntry_name not like 'Poland' and
    sdo_nn(geom,
        (select geom from country_boundaries
        where cntry_name = 'Poland'),
        'unit=km', 1) = 'TRUE' and
    sdo_relate(geom,
        (select geom from country_boundaries
        where cntry_name = 'Poland'),
        'mask=TOUCH') = 'FALSE';
        
        

// zad.3A

select B.CNTRY_NAME,
SDO_GEOM.SDO_LENGTH(SDO_GEOM.SDO_INTERSECTION(A.GEOM, B.GEOM), 1, 'unit=km') as odleglosc
from COUNTRY_BOUNDARIES A,
COUNTRY_BOUNDARIES B
where A.CNTRY_NAME = 'Poland' and 
    B.CNTRY_NAME != 'Poland' and
    SDO_GEOM.SDO_LENGTH(SDO_GEOM.SDO_INTERSECTION(A.GEOM, B.GEOM), 1, 'unit=km') is not null;
    
// zad.3B

select cntry_name, sdo_geom.sdo_area(geom, 1, 'unit=SQ_KM')
from country_boundaries
order by 2 desc
fetch next 1 rows only;
    
// zad.3C

select sdo_geom.sdo_area(
    sdo_geom.sdo_mbr(
        sdo_geom.sdo_union(
            a.geom, b.geom, 0.01
        )
    ), 1, 'unit=SQ_KM'
) SQ_KM
from major_cities a, major_cities b
where a.city_name = 'Warsaw' and b.city_name = 'Lodz';


// zad.3D

select sdo_geom.sdo_union(a.geom, b.geom, 0.01).get_gtype()
from COUNTRY_BOUNDARIES A, MAJOR_CITIES B
where A.CNTRY_NAME = 'Poland'
and B.CITY_NAME = 'Prague';

// zad.3E

select mc.city_name as city_name, mc.cntry_name as cntry_name 
from major_cities mc, country_boundaries cb
where sdo_geom.sdo_distance(mc.geom, sdo_geom.sdo_centroid(cb.geom, 1)) = (
    select min(sdo_geom.sdo_distance(mc.geom, sdo_geom.sdo_centroid(cb.geom, 1))) 
    from major_cities mc, country_boundaries cb);

// zad.3F

select name, sum(dlugosc) from (
    select R.name NAME, SDO_GEOM.SDO_LENGTH(SDO_GEOM.SDO_INTERSECTION(B.GEOM, R.GEOM, 1), 1, 'unit=KM') DLUGOSC
    from COUNTRY_BOUNDARIES B, RIVERS R
    where B.CNTRY_NAME = 'Poland' and 
        SDO_GEOM.RELATE(B.GEOM, 'DETERMINE', R.GEOM, 1) != 'DISJOINT')
GROUP BY name;
