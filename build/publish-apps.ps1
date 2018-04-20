param($RootDirectory = (Get-Location), $Framework = "netcoreapp2.1", $Runtime = "win7-x64")

# De-Powershell the path
$RootDirectory = (Convert-Path $RootDirectory)

# Find dotnet.exe
$dotnet = Join-Path (Join-Path (Join-Path $env:USERPROFILE ".dotnet") "x64") "dotnet.exe"

if(!(Test-Path $dotnet)) {
    throw "Could not find dotnet at: $dotnet"
}

# Resolve directories
$SamplesDir = Join-Path $RootDirectory "samples"
$ArtifactsDir = Join-Path $RootDirectory "artifacts"
$AppsDir = Join-Path $ArtifactsDir "apps"
$ClientsDir = Join-Path $RootDirectory "clients"
$ClientsTsDir = Join-Path $ClientsDir "ts"

# The list of apps to publish
$Apps = @{
    "SignalRSamples"= (Join-Path $SamplesDir "SignalRSamples")
    "FunctionalTests"= (Join-Path $ClientsTsDir "FunctionalTests")
}

$Apps.Keys | ForEach-Object {
    $Name = $_
    $Path = $Apps[$_]

    $OutputDir = Join-Path $AppsDir $Name

    Write-Host -ForegroundColor Green "Publishing $Name"
    & "$dotnet" publish --framework $Framework --runtime $Runtime --output $OutputDir $Path
}