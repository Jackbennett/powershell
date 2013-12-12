# Powershell scripts development

# What is this?

Every **script** in this root folder is either;

- in development
- a note
- a reference
- an abandoned project for later

All **folders** in the repo are modules intended for use or well on their way to it.

*What's the difference?* If it's a folder it should be at the point past requiring knowledge of assumptions made by the developer. i.e There should be help written.

# How to use

Add the modules you're interested in to your session with

    import-module <module name>

Add all of the modules by adding the above command to your profile with

    if(test-path $profile){notepad $profle}else{new-item $profile -type File; notepad $profile}

There is a sample profile template in the repo as `profile.template`. This is an example of how I'm importing these scripts.

# About the modules

## Utils

File that's going to contain some generic helper functions

    Get-Command -Module utils

## Application

Find and remove applications on a computer

    get-command -Module Application

