<#
##################################################################################################################
#
# Microsoft Premier Field Engineering
# jesse.esquivel@microsoft.com
# USGovDoD-O365-Endpoints.ps1
# v1.0 Initial creation 09/24/2018 - Check IL5 US Gov DoD O365 Endpoints
#
# 
# 
# Microsoft Disclaimer for custom scripts
# ================================================================================================================
# The sample scripts are not supported under any Microsoft standard support program or service. The sample scripts
# are provided AS IS without warranty of any kind. Microsoft further disclaims all implied warranties including, 
# without limitation, any implied warranties of merchantability or of fitness for a particular purpose. The entire
# risk arising out of the use or performance of the sample scripts and documentation remains with you. In no event
# shall Microsoft, its authors, or anyone else involved in the creation, production, or delivery of the scripts be
# liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business
# interruption, loss of business information, or other pecuniary loss) arising out of the use of or inability to 
# use the sample scripts or documentation, even if Microsoft has been advised of the possibility of such damages.
# ================================================================================================================
#
##################################################################################################################
# Script variables - please do not change these unless you know what you are doing
##################################################################################################################
#>

$VBCrLf = "`r`n"
$ws = "https://endpoints.office.com"
$scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$datapath = $scriptDir + "\endpoints_clientid_latestversion.txt"
$erUrlIplog = "$scriptDir\USGovDoD-ExpressRoute-Urls-Ips-$(Get-Date -Format FileDateTimeUniversal).txt"
$JSONerUrlIplog = "$scriptDir\USGovDoD-ExpressRoute-Urls-Ips-$(Get-Date -Format FileDateTimeUniversal).json"
$urlIplog = "$scriptDir\USGovDoD-Non-ExpressRoute-Urls-Ips-$(Get-Date -Format FileDateTimeUniversal).txt"
$JSONurlIplog = "$scriptDir\USGovDoD-Non-ExpressRoute-Urls-Ips-$(Get-Date -Format FileDateTimeUniversal).json"
$PACFile = "$scriptDir\USGovDoD-PACFile-for-Proxy-Server-Configuration$(Get-Date -Format FileDateTimeUniversal).pac"
[System.Diagnostics.EventLog]$evt = new-object System.Diagnostics.EventLog("Application")
[System.Diagnostics.EventLog]$evt.Source = "O365 U.S. Gov DoD Endpoint Check"
[System.Diagnostics.EventLogEntryType]$infoEvent=[System.Diagnostics.EventLogEntryType]::Information
[System.Diagnostics.EventLogEntryType]$warningEvent=[System.Diagnostics.EventLogEntryType]::Warning
[System.Diagnostics.EventLogEntryType]$errorEvent=[System.Diagnostics.EventLogEntryType]::Error

##################################################################################################################
# Functions - please do not change these unless you know what you are doing
##################################################################################################################

Function startScript()
{
    $msg = "Beginning USGoVDoD O365 IL5 Endpoint Checks from $env:COMPUTERNAME" + $VBCrLf + "@ $(get-date) via PowerShell Script.  Logging is enabled."
    Write-Host "######################################################################################" -ForegroundColor Yellow
    Write-Host  "$msg" -ForegroundColor Green
    Write-Host "######################################################################################" -ForegroundColor Yellow
    Write-Host
    Log-This $infoEvent $msg
}

Function Write-This($data, $log)
{
    try
    {
        Add-Content -Path $log -Value $data -ErrorAction Stop
    }
    catch
    {
        Write-Host $_.Exception.Message -ForegroundColor Red
        Log-This $errorEvent $_.Exception.Message
    }
}

function Log-This() 
{ 
    param ( [System.Diagnostics.EventLogEntryType]$entryType = $infoEvent, [string]$message )
    # set the default Windows Eventlog ID number
    [int]$eventID = 411
    switch ([System.Diagnostics.EventLogEntryType]$entryType) 
    { 
        $infoEvent {$eventID = 411}
        $warningEvent {$eventID = 611}
        $errorEvent {$eventID = 911}
        default {$eventID = 411}
    }
    try
    {
        $evt.WriteEntry($message,$entryType,$eventID) 
    }
    catch
    {
        $msg = "`n$_`nDid you remember to register the Eventlog source?`n"
        $msg += "Try: c:\eventcreate /ID 411 /L APPLICATION /T INFORMATION /SO " + $evt.Source + " /D 'New event source'`n"
        Write-Host $msg -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Red
        closeScript 1
    }
}

Function closeScript($exitCode)
{
    if($exitCode -ne 0)
    {
        Write-Host
        Write-Host "######################################################################################" -ForegroundColor Yellow
        $msg = "Script execution unsuccessful, and terminated at $(get-date)" + $VBCrLf + "Time Elapsed: ($($elapsed.Elapsed.ToString()))" `
        + $VBCrLf + "Examine the script output and previous events logged to resolve errors."
        Write-Host $msg -ForegroundColor Red
        Write-Host "######################################################################################" -ForegroundColor Yellow

    }
    else
    {
        Write-Host "######################################################################################" -ForegroundColor Yellow
        $msg = "Successfully completed script at $(get-date)" + $VBCrLf + "Time Elapsed: ($($elapsed.Elapsed.ToString()))" + $VBCrLf `
        + "Review the logs."
        Write-Host $msg -ForegroundColor Green
        Write-Host "######################################################################################" -ForegroundColor Yellow
        Log-This $infoEvent $msg
    }
    exit $exitCode
}

Function Send-Mail($emailAddress)
{
    $smtpServer = "yourexchangeserverfqdn here"
    $msg = New-Object System.Net.Mail.MailMessage
    $smtp = New-Object System.Net.Mail.SmtpClient($smtpServer)
    $attachment1 = New-Object System.Net.Mail.Attachment -ArgumentList $erUrlIplog
    $attachment1.ContentDisposition.Inline = $true
    $attachment1.ContentDisposition.DispositionType = "Inline"
    $attachment1.ContentType.MediaType = "text/plain"
    $attachment1.ContentId = $erUrlIplog
    $attachment2 = New-Object System.Net.Mail.Attachment -ArgumentList $JSONerUrlIplog
    $attachment2.ContentDisposition.Inline = $true
    $attachment2.ContentDisposition.DispositionType = "Inline"
    $attachment2.ContentType.MediaType = "text/plain"
    $attachment2.ContentId = $JSONerUrlIplog
    $attachment3 = New-Object System.Net.Mail.Attachment -ArgumentList $urlIplog
    $attachment3.ContentDisposition.Inline = $true
    $attachment3.ContentDisposition.DispositionType = "Inline"
    $attachment3.ContentType.MediaType = "text/plain"
    $attachment3.ContentId = $urlIplog
    $attachment4 = New-Object System.Net.Mail.Attachment -ArgumentList $JSONurlIplog
    $attachment4.ContentDisposition.Inline = $true
    $attachment4.ContentDisposition.DispositionType = "Inline"
    $attachment4.ContentType.MediaType = "text/plain"
    $attachment4.ContentId = $JSONurlIplog
    $attachment5 = New-Object System.Net.Mail.Attachment -ArgumentList $$PACFile
    $attachment5.ContentDisposition.Inline = $true
    $attachment5.ContentDisposition.DispositionType = "Inline"
    $attachment5.ContentType.MediaType = "text/plain"
    $attachment5.ContentId = $PACFile
    $msg.Attachments.Add($attachment1)
    $msg.Attachments.Add($attachment2)
    $msg.Attachments.Add($attachment3)
    $msg.Attachments.Add($attachment4)
    $msg.Priority = [System.Net.Mail.MailPriority]::High
    $msg.From = "O365Info@changem.com"
    $msg.ReplyTo = "noreply@changeme.com"
    $msg.Subject = "Important O365 IP Address and URL CHANGE Information!"
    $msg.to.Add($emailAddress)
    $msg.IsBodyHtml = $true
    $msg.Body = @"
    <html>
    <font face="Calibri">
    <body>
    Alcon,
    <br>
    <br>
    <font color="red">O365 U.S. Government Defense IL5 Endpoints <b><u>have changed</u></b>!</font><font color="red">***</font>Failure to update your outbound`
     Web Proxy and Firewalls can result in <b><u>LOSS OF O365 SERVICE!!</u></b><font color="red">***</font>`
    <br>
    <br>
    The new IPv4 addresses, ports, and URls are attached to this email.  Please update your Web proxy and Firewall(s) accordingly.
    <br>
    <br>
    Please do not reply to this email as it is an unmonitored automated alias.
    <br>
    <br>
    N64 Systems Engineering  
    </body>
    </font>
    </html> 

"@
    try
    {
        $smtp.Send($msg)
        $attachment.Dispose()
        $msg.Dispose()
    }
    catch
    {
        Log-This $errorEvent $_.Exception.Message
        Write-Host $_.Exception.Message -ForegroundColor Red
        closescript $_.Exception
    }
}

##################################################################################################################
# Begin Script  - please do not change unless you know what you are doing
##################################################################################################################

$elapsed = [System.Diagnostics.Stopwatch]::StartNew()
StartScript

#fetch client ID and version if data file exists; otherwise create new file
Write-Host "*************************************************************************************" -ForegroundColor White
Write-Host "Phase 1 - Checking existing data file..." -ForegroundColor White
Write-Host "*************************************************************************************" -ForegroundColor White
Write-Host

if (Test-Path $datapath)
{
    Write-Host "Existing data file found, parsing..." -ForegroundColor Cyan
    $content = Get-Content $datapath
    $clientRequestId = $content[0]
    $lastVersion = $content[1]
    Write-Host "Success." -ForegroundColor Green
    Write-Host 
}
else
{
    Write-Host "No existing data file found, generating..." -ForegroundColor Cyan
    $clientRequestId = [GUID]::NewGuid().Guid
    $lastVersion = "0000000000"
    @($clientRequestId, $lastVersion) | Out-File $datapath
    Write-Host "Success." -ForegroundColor Green
    Write-Host
}

#call version method to check the latest version, and pull new data if version number is different
Write-Host "*************************************************************************************" -ForegroundColor White
Write-Host "Phase 2 - Calling REST WebService..." -ForegroundColor White
Write-Host "*************************************************************************************" -ForegroundColor White
Write-Host
Write-Host "Invoking Version method to check for new endpoint data..." -ForegroundColor Cyan

try
{
    $version = Invoke-RestMethod -Uri ($ws + "/version/USGovDoD?clientRequestId=" + $clientRequestId)
}
catch
{
    Log-This $errorEvent $_.Exception.Message
    Write-Host $_.Exception.Message -ForegroundColor Red
    closeScript $_.Exception    
}

Write-Host "Generated URL: $ws/version/USGovDoD?clientRequestId=$clientRequestId" -ForegroundColor DarkGreen
Write-Host "Success." -ForegroundColor Green
Write-Host

if ($version.latest -gt $lastVersion)
{
    try
    {
        Write-Host "New version of Office 365 USGovDoD service instance endpoints detected, writing version to datafile..." -ForegroundColor Yellow
        # write the new version number to the data file
        @($clientRequestId, $version.latest) | Out-File $datapath
        Write-Host "Success." -ForegroundColor Green
        Write-Host

        #invoke endpoints method to get the new data
        Write-Host "Invoking Endpoints method to get new endpoint data..." -ForegroundColor Cyan
        $endpointSets = Invoke-RestMethod -Uri ($ws + "/endpoints/USGovDoD?clientRequestId=" + $clientRequestId)
        Write-Host "Generated URL:  $ws/endpoints/USGovDoD?clientRequestId=$clientRequestId" -ForegroundColor DarkGreen
        Write-Host "Success." -ForegroundColor Green
        Write-Host

        Write-Host "Formatting new endpoint data..." -ForegroundColor Cyan
        #filter results by expressRoute and Non-Express Route traffic and build files
        $endpointSets = Invoke-RestMethod -Uri ($ws + "/endpoints/USGovDoD?clientRequestId=" + $clientRequestId)
        $erUrlsIps = @()
        $urlsIps = @()
        Write-Host "Success." -ForegroundColor Green
        Write-Host
        
        #start PAC file
        Write-This "function FindProxyForURL(url, host)" $PACFile
        Write-This "{" $PACFile
        Write-This `t"var lhost = host.toLowerCase();" $PACFile
        Write-This `t"host = lhost;" $PACFile

        #parse and process endpoint data
        $urlCount = 1
        foreach($ep in $endpointSets)
        {
            if($ep.expressRoute -eq $true)
            {
                $erUrlsIps += New-Object -TypeName psobject -Property @{id="$($ep.id)"; serviceAreaDisplayName="$($ep.serviceAreaDisplayName)";`
                urls="$($ep.urls)"; ips="$($ep.ips)"; tcpports="$($ep.tcpPorts)"; udpports="$($ep.udpports)"; expressRoute="$($ep.expressRoute)";}
                foreach($url in $ep.urls)
                {
                    if($urlcount -eq 1)
                    {
                        Write-This `t"if ((shExpMatch(host, ""$url""))" $PACFile
                    }
                    else
                    {
                        Write-This `t`t"|| (shExpMatch(host, ""$url"")))" $PACFile
                    }
                    $urlCount = $urlCount + 1
                }
            }
            elseif($ep.expressRoute -eq $false)
            {
                $urlsIps += New-Object -TypeName psobject -Property @{id="$($ep.id)"; serviceAreaDisplayName="$($ep.serviceAreaDisplayName)";`
                urls="$($ep.urls)"; ips="$($ep.ips)"; tcpports="$($ep.tcpPorts)"; udpports="$($ep.udpports)"; expressRoute="$($ep.expressRoute)";}
            }
        }
        #finish PAC file
        Write-This `t"{" $PACFile
        Write-this `t`t"return DIRECT;" $PACFile
        Write-This `t"}" $PACFile
        #Modify for your Internet bound Proxy Server
        Write-This `t"else return ""PROXY 10.10.10.11:8080"";" $PACFile
        Write-THis "}" $PACFile
    }
    Catch
    {
        Log-This $errorEvent $_.Exception.Message
        Write-Host $_.Exception.Message -ForegroundColor Red
        closeScript $_.Exception
    }
    Write-Host "*************************************************************************************" -ForegroundColor White
    Write-Host "Phase 3 - Writing New Endpoint Data and sending notification..." -ForegroundColor White
    Write-Host "*************************************************************************************" -ForegroundColor White
    Write-Host

    try
    {
        Write-Host "Writing New Express Route URL Endpoint Data..." -ForegroundColor Cyan
        $erUrlsIps | Out-String | Out-File $erUrlIplog
        $erUrlsIps | ConvertTo-Json | Out-File $JSONerUrlIplog
        Write-host "Success." -ForegroundColor Green
        Write-Host

        Write-Host "Writing New Non-Express Route URL Endpoint Data..." -ForegroundColor Cyan
        $urlsIps | Out-String | Out-File $urlIplog
        $urlsIps | ConvertTo-Json | Out-File $JSONurlIplog    
        Write-host "Success." -ForegroundColor Green
        Write-Host

        Write-Host "Sending Notification that Endpoint Data has changed..." -ForegroundColor Cyan
        Send-Mail "notify@notifyme.com"
        Write-host "Success." -ForegroundColor Green
        Write-Host
        Log-This $infoEvent "New O365 USFGovDoD Express Route and Non Express Route URL and IP files (flat text and JSON format),  `
        and new client PAC files genderated; email notification sent to network and system administrators."    
    }
    catch
    {
        Log-This $errorEvent $_.Exception.Message
        Write-Host $_.Exception.Message -ForegroundColor Red
        closeScript $_.Exception    
    }
    closeScript 0
}
else
{
    Write-Host "Office 365 U.S. Government Defense service instance endpoints are up-to-date." -ForegroundColor Cyan
    Write-Host "Success." -ForegroundColor Green
    Write-Host
    closeScript 0
}