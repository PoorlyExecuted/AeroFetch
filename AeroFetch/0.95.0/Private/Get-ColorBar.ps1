function Get-ColorBar {
    <#
        .SYNOPSIS
            Displays a ColorBar on-screen.
            
        .DESCRIPTION
            Displays a 16-bit ColorBar on-screen representing all 16 ConsoleColor options.

        .NOTES
            * CHANGELOG *
            [+] UPDATE_01
                    Date: 03-12-2025
                    Title: Initial Commit
                    Message: Initial Commit. Function displays ANSI Escape Sequence Colors representing all 16 ConsoleColor options (White/Black plus Normal and Dark variety of each of the 7 remaining colors)

            [+] UPDATE_xx
                    Date:
                    Title:
                    Message:
                    
            
            -------------------------------------------------------------------------------------------------------------------------
            #########################################################################################################################        
            -------------------------------------------------------------------------------------------------------------------------
            
            * PLANNED UPDATES/FIXES *
                UPDATE_??-[ ]    
                    Date: TBA
                    Title: Ansi Escape Configuration
                    Message:
                    Add Parameters to configure the ANSI Escape Sequence Color Values manually.
                UPDATE_??-[ ]
                    Date: TBA
                    Title: RealConsoleColor Mode
                    Message 
                    Add Paramater to switch between 'RealConsoleColor' and 'AnsiEscapeSequence' display mode.
    #>

    param(
        [Parameter()]
        [ValidateSet('Both','Top','Bottom')]
        [string]$DisplayRow = 'Both'
    )

    $Esc = [char]27
    $Reset = "$Esc[0m"


    $ConsoleColorRow = "$Esc[38;5;255m███$Reset$Esc[38;5;237m███$Reset$Esc[38;5;88m███$Reset$Esc[38;5;41m███$Reset$Esc[38;5;33m███$Reset$Esc[38;5;135m███$Reset$Esc[38;5;13m███$Reset$Esc[38;5;122m███$Reset" 
    $ConsoleColorDarkRow = "$Esc[38;5;232m███$Reset$Esc[38;5;248m███$Reset$Esc[38;5;196m███$Reset$Esc[38;5;22m███$Reset$Esc[38;5;17m███$Reset$Esc[38;5;91m███$Reset$Esc[38;5;11m███$Reset$Esc[38;5;75m███$Reset"
    
    if ($DisplayRow -eq 'Both') {
        return @($ConsoleColorRow, $ConsoleColorDarkRow)
    } elseif ($DisplayRow -eq 'Top') {
        return $ConsoleColorRow
    } elseif ($DisplayRow -eq 'Bottom') {
        return $ConsoleColorDarkRow    
    }

    #region Developer Notes
    <#

    * Display Character:
    * Unicode Block Character - FULL BLOCK (0x2588) x3

    
    * Display Order:
    * TopRow: (1)White, (2)Gray, (3)Red, (4)Green, (5)Blue, (6)Magenta, (7)Yellow, (8)Cyan
    * BtmRow: (1)Black, (2)DarkGray, (3)DarkRed, (4)DarkGreen, (5)DarkBlue, (6)DarkMagenta, (7)DarkYellow, (8)DarkCyan
    
    #>
    #endregion
}
