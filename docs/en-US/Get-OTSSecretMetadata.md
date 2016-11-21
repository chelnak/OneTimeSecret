---
external help file: OneTimeSecret-help.xml
online version: 
schema: 2.0.0
---

# Get-OTSSecretMetadata

## SYNOPSIS
Retrieve metadata of a secret

## SYNTAX

```
Get-OTSSecretMetadata [-MetadataKey] <String>
```

## DESCRIPTION
Every secret also has associated metadata.
The metadata is intended to be used by the creator of the secret (i.e.
not the recipient) and should generally be kept private.
You can safely use the metadata key to retrieve basic information about the secret itself (e.g.
if or when it was viewed) since the metadata key is different from the secret key.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-OTSSecretMetaData -MetaDataKey allrfe8gf7edstynihtvrblgfuhbbuz
```

## PARAMETERS

### -MetadataKey
The unique key for the metadata

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

## INPUTS

### System.String

## OUTPUTS

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS

