<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    version="1.0"
    exclude-result-prefixes="mods"
    xmlns:iso20775="info:ofi/fmt:xml:xsd:iso20775"
    xmlns:mods="http://www.loc.gov/mods/v3"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.loc.gov/mods/v3">
    
    <!-- output settings -->
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    <xsl:strip-space elements="*"/>
    
    <!-- identity transform -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- 
        keep the mods:identifier(s), except for mods:identifier w/
        'http://', and add the mods:url elements to the pre-existing
        high level mods:location (not the mods:location under
        mods:relatedItem.
    -->
    <xsl:template match="mods:location[not(parent::mods:relatedItem)]">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
            <!--
                constructing elements to avoid copied namespaces.
                also, i'm a bit lazy.
            -->
            <xsl:element name="url">
                <xsl:attribute name="access">
                    <xsl:value-of select="'object in context'"/>
                </xsl:attribute>
                <xsl:attribute name="usage">
                    <xsl:value-of select="'primary display'"/>
                </xsl:attribute>
                <xsl:value-of select="following::mods:identifier[starts-with(.,'http://')]"/>
            </xsl:element>
            <xsl:element name="url">
                <xsl:attribute name="access">
                    <xsl:value-of select="'preview'"/>
                </xsl:attribute>
                <xsl:value-of select="concat(following::mods:identifier[starts-with(.,'http://')],'/datastream/TN/view')"/>
            </xsl:element>
        </xsl:copy>
    </xsl:template>
    
  <xsl:template match="language">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- drop the mods:identifier with the 'http://...' -->
    <xsl:template match="mods:identifier[starts-with(.,'http://')]"/>
    
</xsl:stylesheet>