<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:template match='/'>
        <PRACOWNICY>
            <xsl:apply-templates select="/*">
            </xsl:apply-templates>
        </PRACOWNICY>
    </xsl:template>
    <xsl:template match="*">
        <xsl:for-each select="//PRACOWNICY/*">
            <xsl:sort select="ID_PRAC"/>
            <xsl:element name="PRACOWNIK">
                <xsl:attribute name="ID_PRAC">
                    <xsl:value-of select="ID_PRAC"/>
                </xsl:attribute>
                <xsl:attribute name="ID_ZESP">
                    <xsl:value-of select="ID_ZESP"/>
                </xsl:attribute>
                <xsl:attribute name="ID_SZEFA">
                    <xsl:value-of select="ID_SZEFA"/>
                </xsl:attribute>
                <NAZWISKO><xsl:value-of select="NAZWISKO"/></NAZWISKO>
                <ETAT><xsl:value-of select="ETAT"/></ETAT>
                <ZATRUDNIONY><xsl:value-of select="ZATRUDNIONY"/></ZATRUDNIONY>
                <PLACA_POD><xsl:value-of select="PLACA_POD"/></PLACA_POD>
                <PLACA_DOD><xsl:value-of select="PLACA_DOD"/></PLACA_DOD>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>