<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="#all">

    <!-- Adapted from Alex Gil's tei-to-ed stylesheet at https://raw.githubusercontent.com/minicomp/ed/master/optional/tei-to-ed/tei-to-ed.xsl -->

    <xsl:output encoding="UTF-8" method="text"/>
    <xsl:strip-space elements="*"/>

    <!-- for replacements of fancy quotes in source -->
    <xsl:param name="doubleQuotePat">’</xsl:param>
    <xsl:param name="doubleQuoteRep">&apos;</xsl:param>

    <xsl:param name="singleQuotePat">‘</xsl:param>
    <xsl:param name="singleQuoteRep">&apos;</xsl:param>

    <xsl:template match="/">

        <xsl:variable name="sect_id" select="teiCorpus/@xml:id"/>
        <xsl:result-document method="text" encoding="utf-8" href="_texts/{$sect_id}-annotated.md"
            omit-xml-declaration="yes">

            <xsl:text>---&#x0A;layout: narrative&#x0A;</xsl:text>
            <xsl:text>title: </xsl:text>
            <xsl:value-of select="normalize-space(/teiCorpus/teiHeader/fileDesc/titleStmt/title)"/>
            <xsl:text>&#x0A;</xsl:text>
            <xsl:text>author: various</xsl:text>
            <xsl:text>&#x0A;</xsl:text>
            <xsl:text>mode: annotated</xsl:text>
            <xsl:text>&#x0A;</xsl:text>
            <xsl:text>editor: </xsl:text>
            <xsl:apply-templates select="/teiCorpus/teiHeader/fileDesc/titleStmt/respStmt" mode="toc"/>
            <xsl:text>&#x0A;</xsl:text>
            <xsl:text>rights: </xsl:text>
            <xsl:value-of
                select="normalize-space(/teiCorpus/teiHeader/fileDesc/publicationStmt/availability)"/>
            <xsl:text>&#x0A;</xsl:text>
            <xsl:text>toc: </xsl:text>
            <xsl:apply-templates select="/teiCorpus/TEI/teiHeader/fileDesc/titleStmt/title" mode="toc"/>
            <xsl:text>&#x0A;</xsl:text>
            <xsl:text>---&#x0A;&#x0A;</xsl:text>

            <!-- add link to manuscript images at top of page -->
<!--            <xsl:text>Transcribed and edited from digital files available in RUcore&#x0A;&#x0A;</xsl:text>-->
            <xsl:text>Mss: </xsl:text>
            <xsl:text>&lt;a href="</xsl:text>
            <xsl:value-of select="/teiCorpus/teiHeader/fileDesc/publicationStmt/idno[@type='URI']"/>
            <xsl:text>" target="_blank"&gt;</xsl:text>
            <xsl:text>&lt;img src="../../assets/photo-icon.png" alt="Manuscript pages" style="display:inline-block; margin-bottom:-3px;"&gt;</xsl:text>
            <xsl:value-of select="/teiCorpus/teiHeader/fileDesc/publicationStmt/idno[@type='URI']"/>
            <xsl:text>&lt;/a&gt;</xsl:text>
<!--            <xsl:text>&#x0A;&#x0A;&lt;div style="text-align:center;"&gt;§&lt;/div&gt;&#x0A;&#x0A;</xsl:text>-->
            <xsl:text>&#x0A;* * *</xsl:text>

            <xsl:apply-templates/>

            <!-- close the div -->

        </xsl:result-document>
    </xsl:template>

    <xsl:template match="teiHeader"/> <!-- do nothing with teiHeader -->

    <!-- check to see if multiple editors -->
    <xsl:template mode="toc" match="//teiHeader/fileDesc/titleStmt/respStmt">
        <xsl:apply-templates select="name"/>
        <xsl:if test="following-sibling::name">
            <xsl:text>,&#xA0;</xsl:text><xsl:apply-templates select="following-sibling::name"/>
        </xsl:if>
   </xsl:template>

    <!-- generate toc in YAML header -->
    <xsl:template mode="toc" match="//TEI/teiHeader/fileDesc/titleStmt/title">
        <xsl:text>&#xa; - </xsl:text>
        <xsl:apply-templates/>
    </xsl:template>

    <!-- retrieve title and body for each letter -->
    <xsl:template match="//TEI/text/body/div">
        <xsl:for-each select=".">
            <xsl:text>&#xa;## </xsl:text>
            <xsl:value-of select="ancestor::TEI/teiHeader/fileDesc/titleStmt/title"/>
            <xsl:text>&#xa;&#xa;</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>&#x0A;* * * &#x0A;</xsl:text>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="lb | addrLine">
        <xsl:apply-templates/>
        <xsl:text>&#x0A;</xsl:text>
    </xsl:template>

    <xsl:template match="head | opener/note[@type='letterhead']">
        <xsl:text>&lt;p class="centered large"&gt;</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&lt;/p&gt;</xsl:text>
    </xsl:template>

    <xsl:template match="opener/dateline">
        <xsl:text>&#x0A;</xsl:text>
        <xsl:text>&lt;p class="right"&gt;</xsl:text>
            <xsl:value-of select="normalize-space(.)"/>
        <xsl:text>&lt;/p&gt;&#x0A;</xsl:text>
    </xsl:template>
    <xsl:template match="opener/salute">
        <xsl:text>&#x0A;</xsl:text>
        <xsl:text>&lt;p class="left"&gt;</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&lt;/p&gt;&#x0A;</xsl:text>
    </xsl:template>
    <xsl:template match="closer/salute">
        <xsl:text>&#x0A;</xsl:text>
        <xsl:text>&lt;p class="indent-1"&gt;</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&lt;/p&gt;&#x0A;</xsl:text>
    </xsl:template>
    <xsl:template match="closer/signed">
        <xsl:text>&#x0A;</xsl:text>
        <xsl:text>&lt;p class="indent-2"&gt;</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&lt;/p&gt;&#x0A;</xsl:text>
    </xsl:template>
    <xsl:template match="p">
        <xsl:text>&#x0A;</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&#x0A;</xsl:text>
    </xsl:template>
    <xsl:template match="unclear">
        <xsl:if test="not(text())">
            <xsl:text>_[?]_</xsl:text>
        </xsl:if>
        <xsl:if test="text()">
            <xsl:text>_</xsl:text>
            <xsl:apply-templates/>
            <xsl:text> [?]_</xsl:text>
        </xsl:if>
    </xsl:template>

    <!-- sanitize text nodes for kramdown -->
    <xsl:template match="text()">
        <xsl:value-of select="replace(replace(., '-', '—'), '\s+', ' ')"/>
    </xsl:template>

    <xsl:template match="hi[@rend = 'italic']">
        <xsl:text>*</xsl:text><xsl:apply-templates/><xsl:text>*</xsl:text>
    </xsl:template>

    <xsl:template match="hi[@rend = 'bold']">
        <xsl:text>**</xsl:text><xsl:apply-templates/><xsl:text>**</xsl:text>
    </xsl:template>

    <!-- add page numbers -->
    <xsl:template match="pb">
        <xsl:text>&#x0A;### Page: </xsl:text><xsl:value-of select="@n"/><xsl:text>&#x0A;&#x0A;</xsl:text>
    </xsl:template>

    <!-- data balloons for names of people and places -->
    <xsl:template match="persName">
        <xsl:text>&lt;button data-balloon-pos="up" data-balloon-length="large" data-balloon="</xsl:text>
        <xsl:value-of disable-output-escaping="yes"
            select="@key/replace(replace(replace(replace(., '-', '—'), '\s+', ' '), $doubleQuotePat, $doubleQuoteRep), $singleQuotePat, $singleQuoteRep)"/>
        <xsl:text> | Born: </xsl:text>
        <xsl:value-of select="@from | @from-iso"/>
        <xsl:text>. Died: </xsl:text>
        <xsl:value-of select="@to | @to-iso"/>
        <xsl:text>.&#10;</xsl:text>
        <xsl:value-of select="@role"/>
        <xsl:text>."&gt;</xsl:text>
<!--        <xsl:text>&lt;a href=&apos;</xsl:text>
        <xsl:value-of select="@ref"/>
        <xsl:text>&apos;&gt;</xsl:text>-->
        <xsl:apply-templates/>
<!--        <xsl:text>&lt;/a&gt;&#160;</xsl:text>-->
        <xsl:text>&lt;/button&gt;</xsl:text>
    </xsl:template>

    <xsl:template match="placeName">
        <xsl:text>&lt;button data-balloon-pos="up" data-balloon-length="large" data-balloon="</xsl:text>
        <xsl:value-of disable-output-escaping="yes"
            select="@key/replace(replace(replace(replace(., '-', '—'), '\s+', ' '), $doubleQuotePat, $doubleQuoteRep), $singleQuotePat, $singleQuoteRep)"/>
        <xsl:text>"&gt;</xsl:text>
        <xsl:text>&lt;a href=&apos;</xsl:text>
        <xsl:value-of select="@ref"/>
        <xsl:text>&apos;&gt;</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>&lt;/a&gt;&#160;</xsl:text>
        <xsl:text>&lt;/button&gt;</xsl:text>
    </xsl:template>

    <!-- data balloons for interp element -->
    <xsl:template match="interp">
        <xsl:text>&lt;button data-balloon-pos="up" data-balloon-length="large" data-balloon="</xsl:text>
        <xsl:variable name="interp_id" select="current()/@xml:id"/>
        <xsl:if test="$interp_id eq current()/substring-after(following-sibling::note[1]/@target, '#')">
            <xsl:if test="following-sibling::note[1]/p">
                <xsl:value-of disable-output-escaping="yes" select="following-sibling::note[1]/p/replace(replace(replace(replace(., '-', '—'), '\s+', ' '), $doubleQuotePat, $doubleQuoteRep), $singleQuotePat, $singleQuoteRep)"/>
            </xsl:if>
            <xsl:if test="following-sibling::note[1]/quote">
                <xsl:text>&apos;</xsl:text>
                <xsl:value-of disable-output-escaping="yes" select="following-sibling::note[1]/quote/replace(replace(replace(replace(., '-', '—'), '\s+', ' '), $doubleQuotePat, $doubleQuoteRep), $singleQuotePat, $singleQuoteRep)"/>
                <xsl:text>&apos;</xsl:text>
            </xsl:if>
        </xsl:if>
        <xsl:text> | From: </xsl:text>
        <xsl:value-of select="following-sibling::note[1]//ref"/>
        <xsl:text>"&gt; &lt;a href=&quot;</xsl:text>
        <xsl:value-of select="following-sibling::note[1]//ref/@target"/>
        <xsl:text>&quot;&gt;</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&lt;/a&gt; &lt;/button&gt;</xsl:text>
    </xsl:template>
    
    <xsl:template match="//div/p/note"/> <!-- ignore text of notes -->

</xsl:stylesheet>
