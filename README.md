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

```PowerShell
    import-module <module name>
```

Add all of the modules by adding the above command to your profile with

```PowerShell
    if(test-path $profile){notepad $profle}else{new-item $profile -type File; notepad $profile}
```

There is a sample profile template in the repo as `profile.template`. This is an example of how I'm importing these scripts.

# About the modules

## Utils

Module that contains generic helper functions I've found useful to use every week.

```PowerShell
    Get-Command -Module util
```

### Todo:
- [ ] `Set-Proxy` currently sets a given proxy URL _only_ when matching a **hardcoded** SSID string

## Application

Find and remove applications on a computer

```PowerShell
    get-command -Module Application
```

## Exams

Subset of cmdlets for managing the examination accounts used on the domain.

### Remove/Set OfficeRestrictions

Modify the users office install to control spelling and grammar corrections for use in exam conditions. Usually applied via logon/off script GPO

### Get Candidate Data

Simple UI to run at logon to prompt a student for their name and candidate number

### Repair ExamUser

Getting all members of the security group "examinations" do the following;

* Mass reset passwords.
* Batch clear the home directories.
* Copy into the home directory new boilerplate documents.
* Guarantee the exam account has full ownership of its home folder

### Todo:
- [ ] Copy the contents of the exam account to an archive
- [ ] Basic GUI Prompt to get student full name and candidate number
- [ ] Set Gui to run at first logon after archiving the existing account
- [ ] Test account folder permission ACL before resetting to see if it's necessary
