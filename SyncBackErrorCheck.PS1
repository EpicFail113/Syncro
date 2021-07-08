#Check default SyncBack log location for last run backup for errors that prevent backup from happening.
#Send off email and RMM alert when backup fails.
#Variable Name: $computer, Variable Type: Platform, Value: {{asset_custom_field_device_name}}
#Variable Name: $cus, Variable Type: Platform, Value: {{customer_business_name}}
#Variable Name: $email, Variable Type: Platform, Value: {{account_email}}

Import-Module $env:SyncroModule #imports the syncro module so we can use synco powershell commands
#get the latest offsite backup log using the date modified attribute
$logname = Get-ChildItem -name *Offsite*Page1* -path "C:\Users\Administrator\AppData\Local\2BrightSparks\SyncBackPro\Logs" | select -last 1 #Get the newest logfile for Offsite
$logname = "C:\Users\Administrator\AppData\Local\2BrightSparks\SyncBackPro\Logs\" + $($logname) #Combines the path with the log file name
$iserror = Select-String -Path $logname -Pattern "Result" -Context 0, 1 | select -First 1 | Out-String
$iserror = $iserror | Select-String -Pattern "Failure" -Quiet

if ($iserror -eq "True" )
{
Rmm-Alert -Category "Backup Error" -Body '$computer could not backup properly' #Create a Syncro Alert
Log-Activity -Message "Could not backup properly" -EventName "Backup Error" #Create an event under the asset
Send-Email -To $email -Subject '$cus backup has an error' -Body '$computer could not complete the last backup' #Send email about alert
}
else Write-Output "Last backup looks good!" #Since Syncro captures the output, lets put something here so we know the script ran.
{
