<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
    
    <!-- TO DO
        
        _ Add constraint to check that a table is fully filled
          Take into account that a chunk may potentially refer to a range of rubrics
          It also impacts the rule to check valid references in a chunk
        
    -->
    
    <sch:let name="dimension-nb" value="count(Table/Dimensions/Dimension)"/>
    
    <sch:pattern id="check-unique-id">
        <sch:rule context="Table">
            <sch:assert test="count(.//Id) = count(distinct-values(.//Id))">
                Duplicate Id
            </sch:assert>
        </sch:rule>
        
    </sch:pattern>
    
    <sch:pattern id="check-unique-id-me">
        <sch:rule context="Table">
            <!-- On récupère les identifiants qui sont en double -->
            <sch:let name="duplicateIds" value=".//Id[. = preceding::Id]"/>
            
            <!-- On vérifie si des identifiants sont en double -->
            <sch:assert test="empty($duplicateIds)">
                Duplicate Id found: <sch:value-of select="$duplicateIds"/>
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    
    
    <sch:pattern id="check-cell-valid-rubric-references">
        <sch:rule context="Chunk">
            <!-- At least, one reference to a rubric in each dimension -->
            <sch:assert test="count(distinct-values(ancestor::Table/Dimensions/Dimension[descendant::Rubric/Id = current()/RubricRef]/Id)) = $dimension-nb">
                Missing reference in at least one dimension
            </sch:assert>
            <!-- Duplicate reference -->
            <sch:assert test="count(distinct-values(RubricRef)) = count(RubricRef)">
                Duplicate reference
            </sch:assert>
        </sch:rule>
        <sch:rule context="Chunk/RubricRef">
            <!-- Reference to an unexisting rubric -->
            <sch:assert test=". = ancestor::Table/Dimensions/Dimension/descendant::Rubric/Id">
                Chunk with reference to an unexisting rubric
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    
</sch:schema>