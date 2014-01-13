
function Set-OfficeRestrictions
{
    $word = New-Object -ComObject word.application

    $options = @{
        'checkSpellingAsYouType' = $false;
        'checkGrammarAsYouType' = $false;
        'SuggestSpellingCorrections' = $false;
        'ContextualSpeller' = $false;
    }

    $options.keys | foreach{ $word.options.($_) = $myoptions.($_) }

    $word.quit()
}

function Remove-OfficeRestrictions
{
    $word = New-Object -ComObject word.application

    $options = @{
        'checkSpellingAsYouType' = $true;
        'checkGrammarAsYouType' = $true;
        'SuggestSpellingCorrections' = $true;
        'ContextualSpeller' = $true;
    }

    $options.keys | foreach{ $word.options.($_) = $myoptions.($_) }

    $word.quit()
}