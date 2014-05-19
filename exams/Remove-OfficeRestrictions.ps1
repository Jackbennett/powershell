# Options only seem to exist for Word.
[string[]]$Options = @(
    'checkSpellingAsYouType',
    'checkGrammarAsYouType',
    'SuggestSpellingCorrections',
    'ContextualSpeller'
)
[string[]]$ActiveDocument = @(
    'ShowSpellingErrors',
    'ShowGrammaticalErrors'
)

function Remove-OfficeRestrictions
{
    Begin
    {
        # Detect if word is already open
        try
        {
            $open = Get-Process -Name winword -ErrorAction Stop
        }
        catch
        {
            $open = $false
        }

        $Word = New-Object -ComObject word.application
    }

    Process
    {
        $Options | ForEach-Object{
            $Word.Options.($_) = $true
        }
        

        if($Word.ActiveDocument)
        {
            $ActiveDocument | ForEach-Object{
                $Word.ActiveDocument.($_) = $true
            }
        }
    }

    End
    {
        # Close Word if not already open
        if( -not $open)
        {
            $Word.Quit()
            # To release the ComObject, <object>.Quit() must have been run
            [System.Runtime.Interopservices.Marshal]::ReleaseComObject($Word) > $null
        }

        Remove-Variable Word
    }
}

Remove-OfficeRestrictions
# SIG # Begin signature block
# MIIKFQYJKoZIhvcNAQcCoIIKBjCCCgICAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU32eyIJrackLKWNgEPfrqRFPT
# P2agggdQMIIHTDCCBjSgAwIBAgIKdLSKPwAAAAAABTANBgkqhkiG9w0BAQUFADB/
# MRIwEAYKCZImiZPyLGQBGRYCdWsxEjAQBgoJkiaJk/IsZAEZFgJhYzEZMBcGCgmS
# JomT8ixkARkWCWxhbmNzbmdmbDEZMBcGCgmSJomT8ixkARkWCXVwaG9sbGFuZDEf
# MB0GA1UEAxMWdXBob2xsYW5kLVVIU0VSVkVSMS1DQTAeFw0xNDAxMjEwOTE5NTVa
# Fw0xNTAxMjEwOTE5NTVaMIGOMRIwEAYKCZImiZPyLGQBGRYCdWsxEjAQBgoJkiaJ
# k/IsZAEZFgJhYzEZMBcGCgmSJomT8ixkARkWCWxhbmNzbmdmbDEZMBcGCgmSJomT
# 8ixkARkWCXVwaG9sbGFuZDEXMBUGA1UECxMOQWRtaW5pc3RyYXRvcnMxFTATBgNV
# BAMTDEphY2sgQmVubmV0dDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEB
# AKQTDriAwHZboB2ZpyvXGYgrfFr9MXIC/jbCUJ0iozl+f0aOO0GSHQ4PU8XNglUG
# ZjvFhLAY6RTr4IW1UcHMwc8ib+IescDw7xPD6iwTNCY5VYpRp+A/qysDJKEh5Y0L
# Mx5z9d5T+j0TQ5vxYcpORkPWqF8y2Wii0skKw450K68xHA70B6K3gZPvX9OY/q5T
# pGJ5CbDjd+IHsZRIHR8kvWhfBgjf84S4bY6OZcpvdzJwLg3L7B5hFjgQ81hhpMED
# cT7nfjJAYYvxcwr+h15b2QaKhFHxKanl5LheNjJnpdCVFcX0NdVP/gfIxuUTzpax
# 7dn5SK2FUhV625NC/zOlKukCAwEAAaOCA7gwggO0MA4GA1UdDwEB/wQEAwIHgDAT
# BgNVHSUEDDAKBggrBgEFBQcDAzBEBgkqhkiG9w0BCQ8ENzA1MA4GCCqGSIb3DQMC
# AgIAgDAOBggqhkiG9w0DBAICAIAwBwYFKw4DAgcwCgYIKoZIhvcNAwcwHQYDVR0O
# BBYEFD+hqRE4H+gO3n7R6TvNAkklbUxeMB8GA1UdIwQYMBaAFHOzbn7lVR7CHyXc
# gBCL1j7cLDAlMIIBQQYDVR0fBIIBODCCATQwggEwoIIBLKCCASiGgdNsZGFwOi8v
# L0NOPXVwaG9sbGFuZC1VSFNFUlZFUjEtQ0EsQ049VUhTRVJWRVIxLENOPUNEUCxD
# Tj1QdWJsaWMlMjBLZXklMjBTZXJ2aWNlcyxDTj1TZXJ2aWNlcyxDTj1Db25maWd1
# cmF0aW9uLERDPXVwaG9sbGFuZCxEQz1sYW5jc25nZmwsREM9YWMsREM9dWs/Y2Vy
# dGlmaWNhdGVSZXZvY2F0aW9uTGlzdD9iYXNlP29iamVjdENsYXNzPWNSTERpc3Ry
# aWJ1dGlvblBvaW50hlBodHRwOi8vdWhzZXJ2ZXIxLnVwaG9sbGFuZC5sYW5jc25n
# ZmwuYWMudWsvQ2VydEVucm9sbC91cGhvbGxhbmQtVUhTRVJWRVIxLUNBLmNybDCC
# AWEGCCsGAQUFBwEBBIIBUzCCAU8wgckGCCsGAQUFBzAChoG8bGRhcDovLy9DTj11
# cGhvbGxhbmQtVUhTRVJWRVIxLUNBLENOPUFJQSxDTj1QdWJsaWMlMjBLZXklMjBT
# ZXJ2aWNlcyxDTj1TZXJ2aWNlcyxDTj1Db25maWd1cmF0aW9uLERDPXVwaG9sbGFu
# ZCxEQz1sYW5jc25nZmwsREM9YWMsREM9dWs/Y0FDZXJ0aWZpY2F0ZT9iYXNlP29i
# amVjdENsYXNzPWNlcnRpZmljYXRpb25BdXRob3JpdHkwgYAGCCsGAQUFBzAChnRo
# dHRwOi8vdWhzZXJ2ZXIxLnVwaG9sbGFuZC5sYW5jc25nZmwuYWMudWsvQ2VydEVu
# cm9sbC9VSFNFUlZFUjEudXBob2xsYW5kLmxhbmNzbmdmbC5hYy51a191cGhvbGxh
# bmQtVUhTRVJWRVIxLUNBLmNydDAlBgkrBgEEAYI3FAIEGB4WAEMAbwBkAGUAUwBp
# AGcAbgBpAG4AZzA2BgNVHREELzAtoCsGCisGAQQBgjcUAgOgHQwbakB1cGhvbGxh
# bmQubGFuY3NuZ2ZsLmFjLnVrMA0GCSqGSIb3DQEBBQUAA4IBAQCbpbfAvOeAAref
# Cbk7ALHd0mCVVce4slH/zTjoo2MooCy9kpMiCL1mtVKwPA/7NiM7nkLGynHHz5al
# /SWr0rRYNImTzYF6m1W0ol5vtgxEU4+aSUUrb8i33JAIjoAL2SINLp+dCRGH1wsE
# RwQm3xsXV+KNeTY9ih1FTief3zeVlJ+lOAWZiC0/0oK5CVB60qxsRwqka8MkjPKF
# GSGO9R06d/GrscbYhVrvwlkWzhhIFaVmq3ukXOYhKnrjvchJScmpAmqwyuobFRhp
# 4WfM0kIWHpnakYklfQ+47Oj05VPHZ9zWwNcdJvcZz8NAQIsRibTvNBgNeIcAg1Sw
# kanBpYdYMYICLzCCAisCAQEwgY0wfzESMBAGCgmSJomT8ixkARkWAnVrMRIwEAYK
# CZImiZPyLGQBGRYCYWMxGTAXBgoJkiaJk/IsZAEZFglsYW5jc25nZmwxGTAXBgoJ
# kiaJk/IsZAEZFgl1cGhvbGxhbmQxHzAdBgNVBAMTFnVwaG9sbGFuZC1VSFNFUlZF
# UjEtQ0ECCnS0ij8AAAAAAAUwCQYFKw4DAhoFAKB4MBgGCisGAQQBgjcCAQwxCjAI
# oAKAAKECgAAwGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIB
# CzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFP8jt2tqTEzgfIST2+X7
# mnIChKvLMA0GCSqGSIb3DQEBAQUABIIBAABKHRaI+GcjU227quYpgb02FpqKUZxm
# mnkCd6MMsWkI7splzW+zkyThsPNaX0ILOW+vzG69fQbN6uRKl4osEBVQEHjtclZw
# BTs6snmMeGh5zJ5RCY3DmseNR9O7eo5ZI1iFhwCR1skE7QxeaoiNZ2Fa2D90CHUG
# 4irjH2YFk6ZpGRniD28fuYxYjaNRUBV0SZK56vyhl3HGgNI/GA8tInxc6dLe291E
# Xv+R7NY4e9ISCXZ5YnlQm3xjRE2I/oDxZlvJSnzuUtWHk7MgcouKSbn00Sr7p7dM
# 6ccJZ6mK8M0W17VtURBYv0nnle1MSEdomkiSJI2RJmForSG36ZzMy00=
# SIG # End signature block