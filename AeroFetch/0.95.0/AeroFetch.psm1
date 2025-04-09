Write-Debug "BEGIN: [Script Module Initialization]"
Write-Debug "Fetching Module Resources..."

$ResourceDirectories = @('Public','Private')

$PublicFunctions = Get-ChildItem -Path $PSScriptRoot\Public\*.ps1

ForEach ($Directory in $ResourceDirectories) {
    
    $RootDirectory = Join-Path -Path $PSScriptRoot -ChildPath $Directory

    if (Test-Path -Path $RootDirectory) {
        
        Try{

            Write-Debug "`tProcessing Resources in: $RootDirectory"

            $ScriptFiles = Get-ChildItem -Path $RootDirectory -Filter *.ps1

            Write-Debug "`tProcessing Pester Test Scripts.."
            
            $ScriptFiles | Where-Object { $_.Name -NotLike '*.Tests.ps1' } | ForEach-Object {
                 Write-Debug "`t`tPester Tests removed from Resources..."
                 Write-Debug "`t`tImporting Resources..."
                 . $_.FullName 
                }
            } Catch{
            Write-Debug "Failed to initialize Module:"
            Write-Error "CRITICAL FAILURE: Could not initialize Module."
        }

    }
}

Export-ModuleMember -Function $PublicFunctions.BaseName