function Send-FlowDock{
    Param(
        [string]
        $apiToken = '72063f4606aae4ce38bfcf5cccbe3cae'

        , [string]
        $Message

        , [ValidatePattern('[a-zA-Z0-9]*')]
        [string]
        $Username

        , [switch]
        $Alert
    )

    if(-not $Alert){
        $message
    }

    $content = @{
        external_user_name = 'TEST'
        content = "Testing the message chat api @everyone"
    }

    $Request = @{
        ContentType = 'application/json'
        Uri = "https://api.flowdock.com/v1/messages/chat/$($private:apiToken)"
        Method = 'Post'
        Body = ConvertTo-Json $content
    }

    $Username
    #Invoke-webrequest @Request
}