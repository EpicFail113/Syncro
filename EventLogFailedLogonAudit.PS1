#Variable Name: $computer, Variable Type: Platform, Value: {{asset_custom_field_device_name}}
#Variable Name: $email, Variable Type: Platform, Value: {{account_email}}

Import-Module $env:SyncroModule #imports the syncro module so we can use synco powershell commands


$lo = get-eventlog Security | where-object {$_.eventid -eq "4625"} | Measure-Object -Line #gets all failed logon attempts
if ($lo.Lines -gt 5) #is true if failed logon attempts are greater than 5 
{
    Rmm-Alert -Category 'Event Log' -Body '$computer had a failed logon count greater than 5'
    Log-Activity -Message "$lo.Lines failed logon attempts" -EventName "Event Log"
    Send-Email -To $email -Subject '$computer had $lo.Lines failed logons' -Body '$computer had $lo.Lines failed logons'
}
else
{
 Write-Output 'Failed Logon Attempts: $lo.Lines' #so that even if the logon attempts are below 6 something is captured
}
