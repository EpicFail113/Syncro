#Checks to see if the offsite backup server is available, if it isn't we can assume the VPN is probably down
#uses Syncro variable $computer, $cus for the computer name and business name
#Variable Name: $computer, Variable Type: Platform, Value: {{asset_custom_field_device_name}}
#Variable Name: $cus, Variable Type: Platform, Value: {{customer_business_name}}

Import-Module $env:SyncroModule #imports the syncro module so we can use synco powershell commands
$server = "8.8.8.8"
$email = "example@example.com"
$SC = Test-Connection -ComputerName $server -Quiet #ping the offsite backup server to see if the server can get to it. If it can, True will be returned, if not then False

if ($SC -eq !"True" ) #If the ping results is anything but true the do the below
{
    Rmm-Alert -Category 'VPN' -Body '$computer had a failed to ping the offsite backup server' #Create a Syncro Alert
    Log-Activity -Message "Ping failed to contact the offsite backup server" -EventName "VPN Error" #Create an event under the asset
    Send-Email -To $email -Subject '$cus cannot ping offsite backup' -Body '$computer could not ping the offsite backup server' #Send email about alert
}
else
{
 Write-Output "VPN appears to be up and we can ping the offsite server" #Since Syncro captures the output, lets put something here so we know the script ran.
}
