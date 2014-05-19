Import-module ShowUI

$Candidate = UniformGrid -ControlName "Candidate Information" -Columns 2 {
    New-Label "Full Name"
    New-textBox -name "name"
    New-Label "Candidate Number"
    New-TextBox -name "number" -MaxLength 5
    New-Label " "
    New-Button -Content "Begin Exam" -On_Click {
        Get-ParentControl |
            Set-UIValue -passThru |
            Close-Control
    }
} -show

$ExamText = @"
Examination information
Title: $($exam.title)

Candidate Name: $($Candidate.name)
Candidate Number: $($Candidate.number)

"@

write-output $ExamText
