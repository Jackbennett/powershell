. ps:\graphviz.ps1

New-Graph G {

    Get-ChildItem -Directory -Recurse -Exclude "*node_modules*"|
      select name,FullName,parent |
      where {$_.FullName -notlike "*node_modules*"} |
      ForEach {
          Add-Edge $_.parent.toString() $_.name.toString()
      }

} | dot -Tsvg -o .\ps.svg

.\ps.svg