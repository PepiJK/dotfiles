#Requires -RunAsAdministrator

param(
	[Parameter(Mandatory)]
	[string]$UserName
)

Write-Host "Setting up symlinks..."

$Dotfiles = Split-Path -Parent $MyInvocation.MyCommand.Path

$UserHome = "C:\Users\$UserName"
if (-not (Test-Path $UserHome)) {
	Write-Error "User profile directory not found: $UserHome"
	exit 1
}
$UserLocalAppData = "$UserHome\AppData\Local"
$UserAppData = "$UserHome\AppData\Roaming"

if (-not $env:SCOOP) {
	throw "SCOOP environment variable is not set. Please install Scoop first: https://scoop.sh"
}

$UserProfilePath = "$UserHome\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"

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

function LinkJunction {
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
		Remove-Item $Dst -Force -Recurse
	}

	New-Item -ItemType Junction -Path $Dst -Target $FullSrc | Out-Null
	Write-Host "JUNCTION  $Dst -> $FullSrc"
}

# PowerShell profile
Link "powershell\Microsoft.PowerShell_profile.ps1" $UserProfilePath

# Oh My Posh
Link "oh-my-posh\star-ghostty.omp.json" "$UserHome\.config\oh-my-posh\star-ghostty.omp.json"
Link "oh-my-posh\star-win-term.omp.json" "$UserHome\.config\oh-my-posh\star-win-term.omp.json"

# Windows Terminal
LinkJunction "windows-terminal" "$env:SCOOP\persist\windows-terminal\settings"

# Pi
Link "pi\AGENTS.md" "$UserHome\.pi\agent\AGENTS.md"

# Tmux
Link "tmux\.tmux.conf" "$UserHome\.tmux.conf"

# Lazygit
Link "lazygit\config.yml" "$UserAppData\lazygit\config.yml"

# Neovim
Link "nvim\init.lua" "$UserLocalAppData\nvim\init.lua"

# VS Code
$VscodeDir = "$env:SCOOP\persist\vscode\data\user-data\User"
Link "vscode\settings.json" "$VscodeDir\settings.json"
Link "vscode\keybindings.json" "$VscodeDir\keybindings.json"

Write-Host "Done."
