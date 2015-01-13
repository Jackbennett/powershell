function Test-TCPConnection
{
    param(
     [String]$server="proxyserver.example.com",
     [String]$port=8080
    )
    $socket = new-object Net.Sockets.TcpClient
    $socket.Connect($server, $port)

    if ($socket.Connected) {
        $status = "Open"
        $socket.Close()
    }
    else {
        $status = "Not Open"
    }

    $status
}