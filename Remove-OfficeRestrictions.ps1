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