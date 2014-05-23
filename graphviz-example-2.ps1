. ps:\graphviz.ps1

New-Graph G {

    Add-Edge "Hyper-A" "vapp-02"
    Add-Edge "Hyper-A" "vapp-03"

} | dot -Tsvg -o .\ps.svg

.\ps.svg