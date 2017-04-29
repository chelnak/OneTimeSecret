# Remove-OTSSecret

## SYNOPSIS
Burn a secren that has not been read yet.

## SYNTAX

```
Remove-OTSSecret [-MetadataKey] <String> [-WhatIf] [-Confirm]
```

## DESCRIPTION
Burn a secren that has not been read yet.

Secrets with passphrases are currently not supported by this function

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Remove-OTSSecret -MetaDataKey allrfe8gf7edstynihtvrblgfuhbbuz
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

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### System.String

## OUTPUTS

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS

