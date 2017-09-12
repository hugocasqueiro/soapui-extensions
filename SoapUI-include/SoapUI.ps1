

$path = split-path $MyInvocation.MyCommand.Path

if(!(Test-Path ($path + "\soapui"))){
	
	$urlZip = "http://cdn01.downloads.smartbear.com/soapui/5.3.0/SoapUI-5.3.0-windows-bin.zip"
	
	$output = $path + "\soapui.zip"
	Write-Host "Is: "
	Write-Host (Test-Path $path)
	Write-Host ("Download SoapUI..." + $urlZip + " to " + $output)

	(New-Object System.Net.WebClient).DownloadFile($urlZip, $output)

	Add-Type -AssemblyName System.IO.Compression.FileSystem
	
	function Unzip
	{
		param([string]$zipfile, [string]$outpath)

		[System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
	}

	Write-Host "Unzip SoapUI..."

	Unzip $output ($path + "\soapui")
	$target = "soapui\SoapUI-5.3.0"
	Copy-Item soapui-settings.xml $target
	
}

Write-Host "SoapUI is ready."

$soapUiExe = $path + "\soapui\SoapUI-5.3.0\bin\testrunner.bat"
$env:SOAPUI_EXE = $soapUiExe

Write-Host("##vso[task.setvariable variable=SOAPUI_EXE;]$soapUiExe")

Write-Host("Including Soap UI in variable SOAPUI_EXE")
