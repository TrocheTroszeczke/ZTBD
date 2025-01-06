(:zad.5:)
(:for $author in doc("db/bib/bib.xml")//book/author
return $author/last:)

(:zad.6:)
(:for $book in doc("db/bib/bib.xml")//book
  for $author in $book/author
    return <ksiazka>
      <author>
        {$author/last}
        {$author/first}
      </author>
      <title>{$book/title}</title>
    </ksiazka>:)
    
(:zad.7-9:)
(:<wynik>
{for $book in doc("db/bib/bib.xml")//book
  for $author in $book/author
    return
      <ksiazka>
        <author>{$author/last || " " || $author/first}</author>
        <title>{$book/title}</title>
      </ksiazka>}
    </wynik>:)
    
(:zad.10:)
(:<imiona>
{
  for $book in doc("db/bib/bib.xml")//book[title="Data on the Web"]
    for $author in $book/author
      return <imie>{data($author/first)}</imie>
}
</imiona>:)

(:zad.11:)
(:<DataOnTheWeb>
{
  doc("db/bib/bib.xml")//book[title="Data on the Web"]
}
</DataOnTheWeb>:)

(:<DataOnTheWeb>
{
  for $book in doc("db/bib/bib.xml")//book
  where $book/title = "Data on the Web"
  return $book
}
</DataOnTheWeb>:)

(:zad.12:)
(:<Data>{
for $book in doc("db/bib/bib.xml")//book[contains(title, "Data")]
  for $author in $book/author
    return <nazwisko>{data($author/last)}</nazwisko>
}</Data>:)

(:zad.13:)
(:<Data>{
for $book in doc("db/bib/bib.xml")//book[contains(title, "Data")]
  return(
    <title>{data($book/title)}</title>,
    for $author in $book/author
      return <nazwisko>{data($author/last)}</nazwisko>
)}</Data>:)

(:zad.14:)
(:for $book in doc("db/bib/bib.xml")//book[count(author) <= 2]
    return $book/title:)
    
(:zad.15:)
(:for $book in doc("db/bib/bib.xml")//book
    return <ksiazka>
      <title>{data($book/title)}</title>
      <autorow>{count($book/author)}</autorow>
    </ksiazka>:)
    
(:zad.16:)
(:<przedział>
  {min(doc("db/bib/bib.xml")//book/@year) || " - " || max(doc("db/bib/bib.xml")//book/@year)}
</przedział>:)

(:zad.17:)
(:<różnica>{max(doc("db/bib/bib.xml")//book//price) - min(doc("db/bib/bib.xml")//book//price)}</różnica>:)

(:zad.18:)
(:<najtańsze>{
for $book in doc("db/bib/bib.xml")//book[price = min(doc("db/bib/bib.xml")//book//price)]
  return(
    <najtańsza>
      {$book/title},
      {for $author in $book/author
        return $author}
    </najtańsza>
)}</najtańsze>:)

(:zad.19:)
(:for $author in (doc("db/bib/bib.xml")//book/author)
return
  <author>
    {$author/last}
    {
      for $book in doc("db/bib/bib.xml")//book[author/last = $author/last]
      return <title>{$book/title}</title>
    }
  </author>:)
  
(:zad.20:)
(:<wynik>{collection("db/shakespeare")//PLAY/TITLE}</wynik>:)

(:zad.21:)
(:for $play in collection("db/shakespeare")//PLAY[.//LINE[contains(., "or not to be")]]
return $play/TITLE:)

(:zad.22:)
<wynik>{
for $play in collection("db/shakespeare")//PLAY
  return
    <sztuka tytył="{data($play/TITLE)}">
        <postaci>{count($play//PERSONA)}</postaci>
        <aktow>{count($play//ACT)}</aktow>
        <scen>{count($play//SCENE)}</scen>
    </sztuka>
}</wynik>










