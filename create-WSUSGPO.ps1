$NumnerRooms = 26,29,33,36,37,40,50
$WordRooms = "Science","Art","DT"."English","Humanities","Library","Maths","MFL","Music","PE Pod","Staff Room"

foreach ($number in $NumnerRooms)
{
    $name = "WSUS Group - Room " + $number
    New-GPO -Name $name
}
foreach ($title in $WordRooms)
{
    $name = "WSUS Group - " + $title
    New-GPO -Name $name
}
