<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:template match='/'>
        <html>
            <head>
                <link href="swiat.css" rel="stylesheet" type="text/css"/>
            </head>
            <body>
                <h1>ZESPOŁY:</h1>
                <table>
                    <xsl:apply-templates select="//ZESPOLY/ROW" mode="zad.6"/>
                </table>
                <div>
                    <xsl:apply-templates select="//ZESPOLY/ROW" mode="zad.7-8"/>
                </div>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="*" mode="zad.6">
        <tr>
            <td><xsl:value-of select="position()"/>.</td>
            <td>
                <a>
                    <xsl:attribute name="href">
                        <xsl:text>#</xsl:text>
                        <xsl:value-of select="ID_ZESP"/>
                    </xsl:attribute>
                    <xsl:value-of select="NAZWA"/>
                </a>
            </td>
        </tr>
    </xsl:template>
    <xsl:template match="*" mode="zad.7-8">
        <div>
            <xsl:attribute name="id">
                <xsl:value-of select="ID_ZESP"/>
            </xsl:attribute>
            <tr>
                <td>NAZWA:</td>
                <td>
                    <xsl:value-of select="NAZWA"/>
                </td>
            </tr>
            <tr>
                <td>ADRES:</td>
                <td>
                    <xsl:value-of select="ADRES"/>
                </td>
                <br/><br/>
            </tr>
            <xsl:if test="count(PRACOWNICY/ROW)">
                <table>
                    <tr><th>Nazwisko</th><th>Etat</th><th>Zatrudniony</th><th>Placa pod.</th><th>Szef</th></tr>
                    <xsl:for-each select="PRACOWNICY/ROW">
                        <xsl:sort select="NAZWISKO"/>

                        <tr>
                            <td><xsl:value-of select="NAZWISKO"/></td>
                            <td><xsl:value-of select="ETAT"/></td>
                            <td><xsl:value-of select="ZATRUDNIONY"/></td>
                            <td><xsl:value-of select="PLACA_POD"/></td>
                            <td>
                                <xsl:variable name="id_szefa" select="ID_SZEFA"/>
                                <xsl:variable name="szef">
                                    <xsl:choose>
                                        <xsl:when test="$id_szefa != '' and //ZESPOLY/ROW/PRACOWNICY/ROW[ID_PRAC=$id_szefa]">
                                            <xsl:value-of select="//ZESPOLY/ROW/PRACOWNICY/ROW[ID_PRAC=$id_szefa]/NAZWISKO"/>
                                        </xsl:when>
                                        <xsl:otherwise>brak</xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>

                                <xsl:value-of select="$szef"/>
                            </td>
                        </tr>
                    </xsl:for-each>
                </table>
            </xsl:if>
            Liczba pracowników: <xsl:value-of select="count(PRACOWNICY/ROW)"/>
        </div>
    </xsl:template>
</xsl:stylesheet>