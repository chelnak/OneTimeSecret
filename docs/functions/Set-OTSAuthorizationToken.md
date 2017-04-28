# Set-OTSAuthorizationToken

## SYNOPSIS
Create the Authorization information required to interact with the OneTimeSecret.com API

## SYNTAX

```
Set-OTSAuthorizationToken [-Username] <String> [-APIKey] <String> [-WhatIf] [-Confirm]
```

## DESCRIPTION
Create the Authorization information required to interact with the OneTimeSecret.com API

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Set-OTSAuthorizationToken -Username user@mail.com -APIKey 52302308erf2e799affd33cbc7c85896b4c6a6997
```

## PARAMETERS

### -Username
The Username of the account

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -APIKey
The API key for the account

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 2
Default value: None
Accept pipeline input: False
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

### System.String

## NOTES

## RELATED LINKS
