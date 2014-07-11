<#
.NOTES
    Q. How do I import students using a CSV file?
    A:
    As an Administrator you can create multiple student users by importing a CSV file. Using our CSV Template you can populate student users by exporting them from your School Management System and placing them into the CSV file. Any Global Groups listed in the CSV file that do not already exist in the online product (such as Years, Forms and Class) will be automatically generated during the import process and the students will then be automatically assigned to those groups.
    When you log in with your Administrator details you will be directed straight onto the School Users tab. Once you are on this screen, click on the CSV drop down menu in the centre console. If you haven't already downloaded and populated the CSV Template  then click Download CSV Template. If you have populated the template then click Import CSV and browse to find the CSV file you created.
    When the CSV file is processed, the usernames and passwords for the students will be automatically generated as the first letter from their first name and their full surname.
    For example
    Name - Peter Smith
    Username - psmith
    If another student has the same initials and surname then any additional users will be automatically assigned a number to their username after import.  
    For example
    Name - Paul Smith
    Username - psmith2   
    You can manually edit their usernames after import if you wish to change the format.  
    A student password will be set to their username before first login. When the students first access the product they will be prompted to change their password. The institution code is always the same for every user within that institution. For an easy way to remember your institution code, you might like to download, print and fill in this Institution Code Poster for display in classrooms.
    See below for more information about the CSV process.

    Q.What is a student’s Admission Number?
    A: Each student requires a unique identifier, so that the system can recognise new versus duplicated records. Creating individual students, or importing them from a CSV file, requires that each student has a unique identifier. We strongly recommend that you use the students’ Admission numbers for this field, exported directly from your School Management System. If creating students manually, please still use their genuine Admission number.
#>

$Properties = @{
    "Surname" = $null;
    "First name" = $null;
    "Admission Number" = $null;
    "Year" = $null;
    "Form" = $null;
    "Class" = $null;
}


new-object -TypeName psobject -Property $Properties | convertto-csv -NoTypeInformation
