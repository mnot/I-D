<!--
    Extract named artwork elements.

    Copyright (c) 2006 Julian F. Reschke (julian.reschke@greenbytes.de)

    placed into the public domain
-->

<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0"
                xmlns:x="http://purl.org/net/xml2rfc/ext"
>

<xsl:import href="clean-for-DTD.xslt"/>

<xsl:output method="text" encoding="UTF-8"/>

<xsl:param name="name" />
<xsl:param name="type" />

<xsl:template match="/" priority="9">
  
  <xsl:choose>
    <xsl:when test="$name!=''">
      <xsl:variable name="artwork" select="//artwork[@name=$name]"/>
      
      <xsl:choose>
        <xsl:when test="$artwork">
          <xsl:for-each select="$artwork">
            <xsl:value-of select="@x:extraction-note"/>
            <xsl:apply-templates select="." mode="cleanup"/>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:message>Artwork element named '<xsl:value-of select="$name"/>' not found.</xsl:message>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="$type!=''">
      <xsl:variable name="artwork" select="//artwork[@type=$type]"/>
      
      <xsl:choose>
        <xsl:when test="$artwork">
          <xsl:for-each select="$artwork">
            <xsl:value-of select="@x:extraction-note"/>
            <xsl:apply-templates select="." mode="cleanup"/>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:message>Artwork element typed '<xsl:value-of select="$type"/>' not found.</xsl:message>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>Please specify either name or type parameter.</xsl:message>
    </xsl:otherwise>
  </xsl:choose>
  

</xsl:template>


</xsl:transform>