# Get-OTSSecret

## SYNOPSIS
Retrieve a secret

## SYNTAX

```
Get-OTSSecret [-SecretKey] <String> [[-Passphrase] <String>]
```

## DESCRIPTION
Retrieve a secret

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-OTSSecret -SecretKey qqevnp70b4uoiax4knzhwlhros6ne7x -Passphrase 1234
```

## PARAMETERS

### -SecretKey
The unique key for this secret

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

### -Passphrase
The passphrase is required only if the secret was create with one

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 2
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

