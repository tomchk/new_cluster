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
            select="concat($sourceFolder,'/assets/environments/cluster',
                    replace(
                        replace(
                            replace(macro/@name,
                                'FIND_A','REPLACE_WITH_A'),
                            'FIND_B','REPLACE_WITH_B'),
                        'FIND_C','REPLACE_WITH_C'),
                    '.xml')"/>
        
        <diff>
            <xsl:if test="macro[@name='' or @name='' or @name='']">
                <replace sel="/macros/macro/component/@ref"><xsl:value-of select="replace(macro/component/@ref,'FIND','REPLACEWITH')" /></replace>
            </xsl:if>
            
            <xsl:if test="macro/properties/identification/@name">
            </xsl:if>
        </diff>
    </xsl:template>
    
    <!-- How to process regions -->
    <xsl:template match="regions">
        <xsl:param name="lkp-url" 
            select="concat($sourceFolder,'/assets/environments/cluster/Cluster_','01','.xml')"/>
        
        <regions xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="region_definitions.xsd">
            <xsl:variable name="offsets">
                <x>10000</x>
                <y>0</y>
                <z>10000</z>
            </xsl:variable>
            <xsl:variable name="startPos">
                <x>0</x>
                <y>0</y>
                <z>0</z>
            </xsl:variable>
            
            <xsl:for-each select="doc($lkp-url)/components/component/connections/connection">
                <region name="{concat('region_',position(),'_',parts/part/@name)}" density="0.5" rotation="0" noisescale="10000" seed="32" minnoisevalue="0" maxnoisevalue="1">
                    <boundary class="splinetube">
                        <size r="10000" />
                        <splineposition 
                            x="{$startPos/x}" 
                            y="{$startPos/y}" 
                            z="{$startPos/z}"
                            tx="1" ty="0" tz="0" inlength="0" outlength="0" />
                        <!-- x is the center x of the planet and z is center z + a buffer -->
                        <splineposition 
                            x="{offset/position/@x}" 
                            y="{offset/position/@y}" 
                            z="{offset/position/@z - $offsets/z}"
                            tx="1" ty="0" tz="0" inlength="0" outlength="0" />
                        <splineposition 
                            x="{offset/position/@x + $offsets/x}" 
                            y="{offset/position/@y}" 
                            z="{offset/position/@z}"
                            tx="0" ty="0" tz="1" inlength="0" outlength="0" />
                        <splineposition 
                            x="{offset/position/@x}" 
                            y="{offset/position/@y}" 
                            z="{offset/position/@z + $offsets/z}"
                            tx="-1" ty="0" tz="0" inlength="0" outlength="0" />
                        <splineposition 
                            x="{offset/position/@x - $offsets/x}" 
                            y="{offset/position/@y}" 
                            z="{offset/position/@z}"
                            tx="0" ty="0" tz="-1" inlength="0" outlength="0" />
                        <splineposition 
                            x="{$startPos/x - 10000}" 
                            y="{$startPos/y}" 
                            z="{$startPos/z}"
                            tx="1" ty="0" tz="0" inlength="0" outlength="0" />
                    </boundary>
                </region>
            </xsl:for-each>
        </regions>
    </xsl:template>
    
</xsl:stylesheet>