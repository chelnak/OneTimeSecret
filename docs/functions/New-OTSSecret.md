# New-OTSSecret

## SYNOPSIS
Generate a short, unique secret.
This is useful for temporary passwords, one-time pads, salts, etc.

## SYNTAX

```
New-OTSSecret [-Passphrase] <String> [[-Ttl] <String>] [[-MetadataTtl] <String>] [[-SecretTtl] <String>]
 [[-Recipient] <String>] [-WhatIf] [-Confirm]
```

## DESCRIPTION
Generate a short, unique secret.
This is useful for temporary passwords, one-time pads, salts, etc.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
New-OTSSecret -Passphrase 1234 -Recipient user@mail.com
```

### -------------------------- EXAMPLE 2 --------------------------
```
New-OTSSecret -Passphrase 1234 -Ttl 90000 -MetadataTtl 90000 -SecretTtil 90000 -Recipient user@mail.com
```

## PARAMETERS

### -Passphrase
A string that the recipient must know to view the secret.
This value is also used to encrypt the secret and is bcrypted before being stored so we only have this value in transit.

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

### -Ttl
The maximum amount of time, in seconds, that the secret should survive (i.e.
time-to-live).
Once this time expires, the secret will be deleted and not recoverable.

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

### -MetadataTtl
The remaining time (in seconds) that the metadata has left to live.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SecretTtl
The remaining time (in seconds) that the secret has left to live.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Recipient
An email address.
We will send a friendly email containing the secret link (NOT the secret itself).

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 5
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

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS

