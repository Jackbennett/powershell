#Powershell scripts development repository

# How to use

Add the modules you're interested in to your session with

    import-module <module name>

Add all of the modules by adding the above command to your profile with

    if(test-path $profile){notepad $profle}else{new-item $profile -type File; notepad $profile}

# About the files

## Utils

File that's going to contain some generic helper functions

    Get-Command -Module utils

## Application

Find and remove applications on a computer

    get-command -Module Application

# Quick notes // unrelated

 sharon - SIMS add U in authorization
