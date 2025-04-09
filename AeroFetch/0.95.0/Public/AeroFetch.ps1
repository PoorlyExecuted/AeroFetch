function AeroFetch {
    <#
        .SYNOPSIS
            The System Information Screenshot Utility - For Windows!

        .DESCRIPTION
            Returns System Information alongside an Ascii Art asset.
        
        .PARAMETER ThemeName
            Specifies

        .PARAMETER AssetName


        .EXAMPLE
            PS> AeroFetch 

        .EXAMPLE
            PS> AeroFetch -ThemeName '' -AssetName ''

        .NOTES
    #>

    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$ThemeName = 'AeroFetch',
        [Parameter()]
        [string]$AssetName = 'ElevenClassic'
    )

    
    $CIMData = @{
        ComputerSystem  = Get-CimInstance Win32_ComputerSystem
        OperatingSystem = Get-CimInstance Win32_OperatingSystem
        Motherboard     = Get-CimInstance Win32_BaseBoard
        VideoController = Get-CimInstance Win32_VideoController
        CPU             = Get-CimInstance CIM_Processor
        GPU             = Get-CimInstance Win32_DisplayConfiguration
        LogicalDisk     = Get-CimInstance Win32_LogicalDisk
        Network         = Get-NetConnectionProfile
        Battery         = Get-CimInstance Win32_Battery
    }

    $UserInfo = "$Env:USERNAME\$Env:USERDOMAIN  -  $($CIMData.ComputerSystem.Workgroup) "

    $OSInfo = "$($CIMData.OperatingSystem.Caption) ($($CIMData.OperatingSystem.OSArchitecture))"

    $Uptime = (([DateTime]$CIMData.OperatingSystem.LocalDateTime) - ([DateTime]$CIMData.OperatingSystem.LastBootUpTime));
    $UptimeFormat = $Uptime.Days.ToString() + ' Days ' + $Uptime.Hours.ToString() + ' Hours ' + $Uptime.Minutes.ToString() + ' Minutes ' + $Uptime.Seconds.ToString() + ' Seconds '

    $UptimeInfo = $UptimeFormat

    # Motherboard Information Processing 
    $MotherboardInfo = "$($CIMData.Motherboard.Manufacturer) $($CIMData.Motherboard.Product)"


    # Ketnel Information Processing
    $KernelInfo = (Get-ItemProperty -Path "${env:SystemRoot}\System32\ntoskrnl.exe").VersionInfo.FileVersion


    # (Power)Shell Information Processing
    $ShellInfo = "Microsoft PowerShell Version $($PSVersionTable.PSVersion.ToString()) | $($Host.Name)"


    # Video Controller Information Processing
    $ResolutionInfo = $CIMData.VideoController.CurrentHorizontalResolution.ToString() + " x " + $CIMData.VideoController.CurrentVerticalResolution.ToString() + " (" + $CIMData.VideoController.CurrentRefreshRate.ToString() + "Hz)"

    # Processes Information Processing
    $Processes = Get-Process
    $ProcInfo = $Processes.Count

    # CPU and GPU Information Processing
    $CPUInfo = $CIMData.CPU.Name
    $GPUInfo = $CIMData.GPU.DeviceName

    # System Memory (RAM) Information Processing
    $AvailableRAM = ([math]::Truncate($Win32Info.FreePhysicalMemory / 1KB))
    $TotalRAM = ([math]::Truncate((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1MB))
    $UsedRAM = $TotalRAM - $AvailableRAM
    $AvailableRAMPercent = ($AvailableRAM / $TotalRAM) * 100
    $AvailableRAMPercent = "{0:N0}" -f $AvailableRAMPercent
    $UsedRamPercent = ($UsedRam / $TotalRAM) * 100
    $UsedRamPercent = "{0:N0}" -f $UsedRamPercent
    $RAMInfo = $UsedRAM.ToString() + "MB / " + $TotalRAM.ToString() + " MB " + "(" + $UsedRamPercent.ToString() + "%" + ")"


    # Logical Disk Information Processing
    $Disk = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='$env:SystemDrive'" -ErrorAction Stop | Select-Object Size, FreeSpace
    $DiskTotal = [math]::Round($Disk.Size / 1GB, 2)
    $DiskFree = [math]::Round($Disk.FreeSpace / 1GB, 2)
    $DiskUsed = [math]::Round($DiskTotal - $DiskFree, 2)
    $DiskPercent = [math]::Round(($DiskUsed / $DiskTotal) * 100)
    $DiskInfo = "$env:SystemDrive ${DiskUsed}GB / ${DiskTotal}GB (${DiskPercent}%)"
    if ($CIMData.Network.Name) {
        $NetworkInfo = "$($CIMData.Network.Name) ($($CIMData.Network.NetworkCategory) $($CIMData.Network.InterfaceAlias) Network)"
    }
    else {
        $NetworkInfo = 'No Network Connection'
    }
    # Battery Information Processing
    $BatteryCharge = "$($CIMData.Battery.EstimatedChargeRemaining)% Remaining"
    $BatteryStatus = Switch ($CIMData.Battery.BatteryStatus) {
        1 { "Discharging" }
        2 { "AC Power" }
        3 { "Fully Charged" }
        4 { "Low" }
        5 { "Critical" }
        6 { "Charging" }
        7 { "Charging and High" }
        8 { "Charging and Low" }
        9 { "Charging and Critical" }
        10 { "Undefined" }
        11 { "Partially Charged" }
        default { "Unknown" }
    }

    if ($CIMData.Battery) {
        $BatteryInfo = "$BatteryCharge [Status: $BatteryStatus]"
    }
    else {
        $BatteryInfo = "No Battery Detected"
    }

    $SystemInformation = [PSCustomObject]@{
    
        PSTypeName      = 'AeroFetch.Win32SystemInfo.DataCollection'

        CurrentUser     = $UserInfo

        OperatingSystem = $OSInfo

        Kernel          = $KernelInfo

        SystemUptime    = $UptimeInfo

        Shell           = $ShellInfo

        Motherboard     = $MotherboardInfo

        Display         = $ResolutionInfo

        Processes       = $ProcInfo

        CPU             = $CPUInfo

        GPU             = $GPUInfo

        Memory          = $RAMInfo

        Drive           = $DiskInfo

        Network         = $NetworkInfo

        Battery         = $BatteryInfo

    }


    [array]$SysInfo =
    "`e[38;5;80m`e[3m   $($SystemInformation.CurrentUser)`e[0m",
    "`e[38;5;198m OS:`e[0m`e[38;5;255m $($SystemInformation.OperatingSystem)",
    "`e[38;5;198m Kernel:`e[0m`e[38;5;255m $($SystemInformation.Kernel)",
    "`e[38;5;198m System Uptime:`e[0m`e[38;5;255m $($SystemInformation.SystemUptime)",
    "`e[38;5;198m Motherboard:`e[0m`e[38;5;255m $($SystemInformation.Motherboard)",
    "`e[38;5;198m Shell:`e[0m `e[38;5;255m$($SystemInformation.Shell)",
    "`e[38;5;198m Window Manager:`e[0m `e[38;5;255mexplorer.exe",
    "`e[38;5;198m Display:`e[0m `e[38;5;255m$($SystemInformation.Display)",
    "`e[38;5;198m CPU:`e[0m `e[38;5;255m$($SystemInformation.CPU)",
    "`e[38;5;198m GPU:`e[0m `e[38;5;255m$($SystemInformation.GPU)",
    "`e[38;5;198m Processes:`e[0m `e[38;5;255m$($SystemInformation.Processes)",
    "`e[38;5;198m Memory:`e[0m `e[38;5;255m$($SystemInformation.Memory)",
    "`e[38;5;198m Drive:`e[0m `e[38;5;255m$($SystemInformation.Drive)",
    "`e[38;5;198m Network:`e[0m `e[38;5;255m$($SystemInformation.Network)",
    "`e[38;5;198m Battery:`e[0m `e[38;5;255m$($SystemInformation.Battery)`e[0m";


    $ModuleRoot = Split-Path $PSScriptRoot -Parent


    $ThemePath = "$ModuleRoot\Data\Themes\$ThemeName\$ThemeName" + ".psd1"

    $Theme = Import-PowerShellDataFile $ThemePath 

    $Theme."$AssetName" = Invoke-Expression '$Theme.$AssetName'

    Clear-Host 

    for ($i = 0; $i -lt [Math]::Max($Theme."$AssetName".Count, $SysInfo.Count); $i++) {
        $output1 = if ($i -lt $Theme."$AssetName".Count) { $Theme."$AssetName"[$i] } else { "" }
        $output2 = if ($i -lt $SysInfo.Count) { $SysInfo[$i] } else { "" }

    
        Write-Host ("    {0,-25}    {1,-25}" -f $output1, $output2)
    }
    Write-Host ""
    Write-Host ""
    Write-Host ""
    Write-Host ""
    Write-Host ""


}