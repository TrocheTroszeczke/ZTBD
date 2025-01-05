(:zad.26-29:)
(:for $k in doc('C:/Users/Ania/Downloads/XPath-XSLT/XPath-XSLT/swiat.xml')/SWIAT/KRAJE/KRAJ:)
(:[starts-with(NAZWA,'A')] :)(::)(:zad.28:)
(:[substring(NAZWA, 1, 1) = substring(STOLICA, 1, 1)]:)
(:return <KRAJ>:)
(:{$k/NAZWA, $k/STOLICA}:)
(:</KRAJ>:)

(:zad.30:)
(:doc('C:/Users/Ania/Downloads/XPath-XSLT/XPath-XSLT/swiat.xml')//KRAJ:)

(:zad.31:)
(:doc('C:/Users/Ania/Downloads/XPath-XSLT/XPath-XSLT/zesp_prac.xml'):)

(:zad.32:)
(:doc('C:/Users/Ania/Downloads/XPath-XSLT/XPath-XSLT/zesp_prac.xml')//NAZWISKO:)

(:zad.33:)
(:for $z in doc("C:/Users/Ania/Downloads/XPath-XSLT/XPath-XSLT/zesp_prac.xml")/ZESPOLY/ROW[NAZWA = "SYSTEMY EKSPERCKIE"]:)
(:    for $p in $z/PRACOWNICY/ROW:)
(:        return $p/NAZWISKO:)

(:zad.34:)
(:count(doc("C:/Users/Ania/Downloads/XPath-XSLT/XPath-XSLT/zesp_prac.xml")/ZESPOLY/ROW[ID_ZESP = 10]/PRACOWNICY/ROW):)

(:zad.35:)
(:for $p in doc("C:/Users/Ania/Downloads/XPath-XSLT/XPath-XSLT/zesp_prac.xml")/ZESPOLY/ROW/PRACOWNICY/ROW[ID_SZEFA = 100]:)
(:   return $p/NAZWISKO:)

(:zad.35:)
sum(doc("C:/Users/Ania/Downloads/XPath-XSLT/XPath-XSLT/zesp_prac.xml")/ZESPOLY/
ROW[PRACOWNICY/ROW/NAZWISKO = 'BRZEZINSKI']/PRACOWNICY/ROW/PLACA_POD)



