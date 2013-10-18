function Get-List{
	get-childitem $args | format-wide -property Name -autosize
}