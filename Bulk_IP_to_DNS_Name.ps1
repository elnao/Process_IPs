#################################################################################################################
#  Script Name:  Bulk_IP_to_DNS_Name.ps1
#  Date:         2023/06/30
#  Programmer:   https://github.com/elnao
#  Purpose:      Extract IP addresses from a text file and resolve them to IP addresses.
#  Prerequisite: Input file must be named C:\temp\IPlist.txt               
#################################################################################################################


$ErrorActionPreference = 'SilentlyContinue'

$IPExtractionStartDate = (Get-Date -Format FileDateTimeUniversal)
$OutputFileDir = "C:\Temp\"
$OutputFile1End = "_IPs_with_ComputerNames.txt"
$OutputFile2End = "_FQDN_Computer_Names_Only.txt"
$OutputFile3End = "_Computer_Names_Only.txt"
$OutputFile1 = "$OutputFileDir$IPExtractionStartDate$OutputFile1End"
$OutputFile2 = "$OutputFileDir$IPExtractionStartDate$OutputFile2End"
$OutputFile3 = "$OutputFileDir$IPExtractionStartDate$OutputFile3End"

$FileContent = Get-Content -Path "C:\temp\IPlist.txt"
$IPAddresses = [System.Collections.ArrayList]::new()


# Regular expression pattern to match IP addresses
$pattern = '\b(?:\d{1,3}\.){3}\d{1,3}\b'

# Extract IP addresses from IPlist.txt
foreach ($line in $FileContent) {
    $matches = [regex]::Matches($line, $pattern)
    foreach ($match in $matches) {
        $IPAddresses.Add($match.Value) | Out-Null
    }
}

#Resolve DNS Names to Given IP addresses
$IPAddresses | ForEach-Object{
$hostname = ([System.Net.Dns]::GetHostEntry($_)).Hostname
if($? -eq $True) {
  $_ +": "+ $hostname >> $OutputFile1
  $hostname >> $OutputFile2

  $hostnameSplit = $hostname -split '\.'
  $hostnameNoFqdn = $hostnameSplit[0]
  $hostnameNoFqdn >> $OutputFile3

}
else {
   $_ +": Cannot resolve hostname" >> $OutputFile1
}}
