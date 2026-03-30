#Requires -RunAsAdministrator

Write-Host "Setting up symlinks..."

$Dotfiles = Split-Path -Parent $MyInvocation.MyCommand.Path

function Link {
    param (
        [string]$Src,
        [string]$Dst
    )

    $FullSrc = Join-Path $Dotfiles $Src

    $Parent = Split-Path -Parent $Dst
    if (-not (Test-Path $Parent)) {
        New-Item -ItemType Directory -Path $Parent -Force | Out-Null
    }

    if (Test-Path $Dst) {
        Remove-Item $Dst -Force
    }

    New-Item -ItemType SymbolicLink -Path $Dst -Target $FullSrc | Out-Null
    Write-Host "LINK  $Dst -> $FullSrc"
}

# PowerShell profile
Link "powershell\Microsoft.PowerShell_profile.ps1" $PROFILE

# Oh My Posh
Link "oh-my-posh\star-ghostty.omp.json" "$env:USERPROFILE\.config\oh-my-posh\star-ghostty.omp.json"
Link "oh-my-posh\star-win-term.omp.json" "$env:USERPROFILE\.config\oh-my-posh\star-win-term.omp.json"

# Windows Terminal
$WtDir = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
Link "windows-terminal\settings.json" "$WtDir\settings.json"

# VS Code
$VscodeDir = "$env:APPDATA\Code\User"
Link "vscode\settings.json" "$VscodeDir\settings.json"
Link "vscode\keybindings.json" "$VscodeDir\keybindings.json"

Write-Host "Done."
