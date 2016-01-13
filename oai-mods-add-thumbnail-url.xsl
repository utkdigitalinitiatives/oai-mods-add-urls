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
    
    <!-- 
        drop the mods:identifier with the 'http://...'... or 
        really, replace that unneeded mods:identifier with a mods:location
        element that suits our purposes.
        
        there's a test to make sure that we don't add a second
        mods:location if there's already one.
    -->
    <xsl:template match="/mods:mods/mods:identifier[starts-with(.,'http://')]">
        <xsl:choose>
            <!-- do we already have a top-level mods:location? -->
            <xsl:when test="/mods:mods/mods:location"/>
            <!-- if we don't, then this test runs -->
            <xsl:when test="not(/mods:mods/mods:location)">
                <xsl:element name="location">
                    <xsl:element name="url">
                        <xsl:attribute name="access">
                            <xsl:value-of select="'object in context'"/>
                        </xsl:attribute>
                        <xsl:attribute name="usage">
                            <xsl:value-of select="'primary display'"/>
                        </xsl:attribute>
                        <xsl:value-of select="."/>
                    </xsl:element>
                    <xsl:element name="url">
                        <xsl:attribute name="access">
                            <xsl:value-of select="'preview'"/>
                        </xsl:attribute>
                        <xsl:value-of select="concat(.,'/datastream/TN/view')"/>
                    </xsl:element>    
                </xsl:element>                
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <!-- 
        this template corrects an apparent problem some of the MODS exports.
        there is an identifier element in relatedItem - it shouldn't be there
        and this template drops it from the identity transform.
        
        note: the problem element is 'identifer'. :)
    -->
    <xsl:template match="/mods:mods/mods:relatedItem/mods:identifer[@type='uri']"/>
    
    
    <!-- language: watch it!! -->
    <xsl:template match="language">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- 
        fixing mods:recordContentSource for DPLA. 
        
        matches on recordContentSource, but only when there's a preceding relatedItem, with a @host and @Project, 
        with a title descendent element containing Volunteer Voices. 
        
        this *can* be run against other MODS files without ill effects.
    -->
    <xsl:template match="/mods:mods/mods:recordInfo/mods:recordContentSource[preceding::mods:relatedItem[@type='host'][@displayLabel='Project']/mods:titleInfo/mods:title[contains(.,'Volunteer Voices')]]">
        <xsl:copy>
            <xsl:apply-templates select="/mods:mods/mods:location/mods:physicalLocation/text()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>