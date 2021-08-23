<!-- Run: 
     transform -xsl:"C:\Games\Steam\steamapps\common\X4 Foundations\extensions\new_cluster/shw_builder.xslt" -it:main
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" indent="yes" />
    <xsl:strip-space elements="*" />
    
    <xsl:variable name="sourceFolder" select="concat('file:///',encode-for-uri(replace('D:/Games/Steam/steamapps/common/X4 Foundations/X4_extracted','\\','/')))"/>
    
    <xsl:template name="main">
        <xsl:for-each select="collection(concat($sourceFolder,'/maps/demo_universe','?recurse=yes;select=*.xml'))">
            <xsl:result-document href="{replace(document-uri(.),'D:/Games/Steam/steamapps/common','D:/X4_out')}">
                <xsl:apply-templates />
            </xsl:result-document>
        </xsl:for-each>
        <xsl:for-each select="collection(concat($sourceFolder,'/libraries','?recurse=yes;select=region*.xml'))">
            <xsl:result-document href="{replace(document-uri(.),'D:/Games/Steam/steamapps/common','D:/X4_out')}">
                <xsl:apply-templates />
            </xsl:result-document>
        </xsl:for-each>
        <xsl:for-each select="collection(concat($sourceFolder,'/index','?recurse=yes;select=*.xml'))">
            <xsl:result-document href="{replace(document-uri(.),'D:/Games/Steam/steamapps/common','D:/X4_out')}">
                <xsl:apply-templates />
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
    
    <!-- How to process each macro file -->
    <xsl:template match="macros">
        <xsl:param name="lkp-url" 
            select="concat($sourceFolder,'/maps/demo_universe',
                    replace(
                        replace(
                            replace(macro/@name,
                                'FIND_A','REPLACE_WITH_A'),
                            'FIND_B','REPLACE_WITH_B'),
                        'FIND_C','REPLACE_WITH_C'),
                    '.xml')"/>
        
        <diff>
            <xsl:if test="macro[@name='' or @name='' or @name='']">
                <replace sel="/macros/macro/component/@ref"><xsl:value-of select="replace(macro/component/@ref,'_ar_','_ol_')" /></replace>
            </xsl:if>
            
            <xsl:if test="macro/properties/identification/@name">
            </xsl:if>
        </diff>
    </xsl:template>
    
    <!-- How to process regions -->
    <xsl:template match="regions">
        <xsl:param name="lkp-url" 
            select="concat($sourceFolder,'/libraries',
                    replace(
                        replace(
                            replace(component/@name,
                                'FIND_A','REPLACE_WITH_A'),
                            'FIND_B','REPLACE_WITH_B'),
                        'FIND_C','REPLACE_WITH_C'),
                    '.xml')"/>
        
        <diff>
            <xsl:if test="component[starts-with(@name,'struct_bt')]">
                <xsl:for-each select="component/connections/connection[not(contains(@name,'adsign'))]">
                </xsl:for-each>
            </xsl:if>
            
            <xsl:if test="component[contains(@name,'dockingbay_repairdock')]">
            </xsl:if>
        </diff>
    </xsl:template>
    
</xsl:stylesheet>