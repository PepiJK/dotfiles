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

# Resolve the actual Documents folder (may be redirected to OneDrive)
$UserSID = (New-Object System.Security.Principal.NTAccount($UserName)).Translate([System.Security.Principal.SecurityIdentifier]).Value
$UserDocuments = (Get-ItemProperty "Registry::HKEY_USERS\$UserSID\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" -ErrorAction SilentlyContinue).Personal
if (-not $UserDocuments) {
	$UserDocuments = "$UserHome\Documents"
}

if (-not $env:SCOOP) {
	throw "SCOOP environment variable is not set. Please install Scoop first: https://scoop.sh"
}

foreach ($xdgVar in @("XDG_CONFIG_HOME", "XDG_DATA_HOME", "XDG_CACHE_HOME")) {
	if (-not (Get-Item "Env:$xdgVar" -ErrorAction SilentlyContinue)) {
		throw "$xdgVar environment variable is not set. Please set it (e.g. C:\DeveloperArea\.config) before running setup."
	}
}

$UserProfilePath = "$UserDocuments\PowerShell\Microsoft.PowerShell_profile.ps1"
$UserProfilePath51 = "$UserDocuments\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"

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

# PowerShell profile (PS 7)
Link "powershell\Microsoft.PowerShell_profile.ps1" $UserProfilePath
# PowerShell profile (PS 5.1)
Link "powershell\Microsoft.PowerShell_profile.ps1" $UserProfilePath51

# Oh My Posh
Link "oh-my-posh\star-ghostty.omp.json" "$env:XDG_CONFIG_HOME\oh-my-posh\star-ghostty.omp.json"
Link "oh-my-posh\star-win-term.omp.json" "$env:XDG_CONFIG_HOME\oh-my-posh\star-win-term.omp.json"

# Windows Terminal (MS Store)
Link "windows-terminal\settings.json" "$UserLocalAppData\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

# Windows Terminal Preview (MS Store, same settings as stable)
Link "windows-terminal\settings.json" "$UserLocalAppData\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json"

# Scoop custom bucket manifests
Link "scoop-bucket\bucket\windows-terminal-canary.json" "$env:SCOOP\buckets\my-apps\bucket\windows-terminal-canary.json"

# Pi
Link "pi\AGENTS.md" "$UserHome\.pi\agent\AGENTS.md"

# Tmux
Link "tmux\.tmux.conf" "$UserHome\.tmux.conf"

# Lazygit
Link "lazygit\config.yml" "$env:XDG_CONFIG_HOME\lazygit\config.yml"

# Neovim
Link "nvim\init.lua" "$env:XDG_CONFIG_HOME\nvim\init.lua"

# VS Code
$VscodeDir = "$env:SCOOP\persist\vscode\data\user-data\User"
Link "vscode\settings.json" "$VscodeDir\settings.json"
Link "vscode\keybindings.json" "$VscodeDir\keybindings.json"

# Psmux
$PsmuxTarget = "$env:XDG_CONFIG_HOME\psmux"
$PsmuxLink = "$UserHome\.psmux"
if (-not (Test-Path $PsmuxTarget)) {
	New-Item -ItemType Directory -Path $PsmuxTarget -Force | Out-Null
}
if (Test-Path $PsmuxLink) {
	Remove-Item $PsmuxLink -Force -Recurse
}
New-Item -ItemType Junction -Path $PsmuxLink -Target $PsmuxTarget | Out-Null
Write-Host "JUNCTION  $PsmuxLink -> $PsmuxTarget"

Write-Host "Done."
