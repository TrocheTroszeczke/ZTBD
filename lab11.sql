//zad.1
create table cytaty as select * from ztpd.cytaty;

//zad.2
select autor, tekst
from cytaty
where lower(tekst) like '%optymista%' and lower(tekst) like '%pesymista%';

//zad.3
create index cytaty_idx on cytaty(tekst)
indextype is CTXSYS.CONTEXT;

//zad.4
select autor, tekst
from cytaty
where CONTAINS(tekst,'optymista and pesymista')>0;

//zad.5
select autor, tekst
from cytaty
where CONTAINS(tekst,'pesymista not optymista')>0;

//zad.6
select autor, tekst 
from cytaty
where contains(tekst, 'near((optymista, pesymista), 3)')>0;

//zad.7
select autor, tekst 
from cytaty
where contains(tekst, 'near((optymista, pesymista), 10)')>0;

//zad.8
select autor, tekst
from cytaty
where CONTAINS(tekst,'życi%')>0;

//zad.9
select autor, tekst, score(1) as dopasowanie
from cytaty
where CONTAINS(tekst,'życi%',1)>0;

//zad.10
SELECT autor, tekst, dopasowanie
FROM (
    SELECT autor, tekst, SCORE(1) AS dopasowanie,
           MAX(SCORE(1)) OVER () AS max_dopasowanie
    FROM cytaty
    WHERE CONTAINS(tekst, 'życi%', 1) > 0
)
WHERE dopasowanie = max_dopasowanie;

//zad.11
select autor, tekst from cytaty
where contains(tekst, '!probelm')>0;

//zad.12
insert into cytaty values(125, 'Bertrand Russell', 'To smutne, że głupcy są tacy pewni
siebie, a ludzie rozsądni tacy pełni wątpliwości.');

commit;

//zad.13,16
select autor, tekst from cytaty
where contains(tekst, 'głupcy')>0;

//zad.14,16
select * from DR$cytaty_idx$I where token_text = 'głupcy';

//zad.15
drop index cytaty_idx;

create index cytaty_idx on cytaty(tekst)
indextype is CTXSYS.CONTEXT;

//zad.17
drop index cytaty_idx;
drop table cytaty;

-----------------------

//zad.1
create table quotes as select * from ztpd.quotes;

//zad.2
create index quotes_idx on quotes(text)
indextype is CTXSYS.CONTEXT;

//zad.3
select * from quotes
where contains(text, 'work')>0;

select * from quotes
where contains(text, '$work')>0;

select * from quotes
where contains(text, 'working')>0;

select * from quotes
where contains(text, '$working')>0;

//zad.4,8
select * from quotes
where contains(text, 'it')>0;

//zad.5
select * from ctx_stoplists;

//zad.6
select * from ctx_stopwords;

//zad.7
drop index quotes_idx;

create index quotes_idx on quotes(text)
indextype is CTXSYS.CONTEXT
parameters ('stoplist CTXSYS.EMPTY_STOPLIST');

//zad.9,15
select * from quotes
where contains(text, 'fool, humans')>0;

//zad.10,15
select * from quotes
where contains(text, 'fool, computer')>0;

//zad.11,15
select * from quotes
where contains(text, '(fool and humans) within SENTENCE')>0;

//zad.12
drop index quotes_idx;

//zad.13
begin
    ctx_ddl.create_section_group('nullgroup', 'NULL_SECTION_GROUP');
    ctx_ddl.add_special_section('nullgroup', 'SENTENCE');
    ctx_ddl.add_special_section('nullgroup', 'PARAGRAPH');
end;
/

//zad.14
create index quotes_idx on quotes(text)
indextype is ctxsys.context
parameters ('section group nullgroup');

//zad.16,18
select * from quotes
where contains(text, 'humans')>0;

//zad.17
drop index quotes_idx;

begin
ctx_ddl.create_preference('lex_z_m','BASIC_LEXER');
ctx_ddl.set_attribute('lex_z_m',
'printjoins', '_-');
ctx_ddl.set_attribute ('lex_z_m', 'index_text', 'YES');
end;
/

create index quotes_idx on quotes(text)
indextype is ctxsys.context
parameters ('LEXER lex_z_m');

//zad.19
select * from quotes
where contains(text, 'non\-humans')>0;

//zad.20
drop table quotes;