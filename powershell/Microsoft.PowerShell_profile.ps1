# PSReadLine
Set-PSReadLineOption -EditMode Windows `
					 -PredictionSource History `
					 -PredictionViewStyle ListView `
					 -Colors @{ "Error" = "#FF5555" }

# aliases
Set-Alias -Name lg -Value lazygit
Set-Alias -Name co -Value copilot
function vibe { copilot --yolo @args }
function Update-Pwsh {
	scoop update pwsh
	Remove-Item "$env:SCOOP\apps\pwsh\current\profile.ps1", "$env:SCOOP\apps\pwsh\current\Microsoft.PowerShell_profile.ps1" -Force -ErrorAction SilentlyContinue
}
Set-Alias -Name uppwsh -Value Update-Pwsh

# oh my posh
# uses --print to omit group policy errors because oh-my-posh init is located in AppData
(@(& oh-my-posh init pwsh --print --config "$env:USERPROFILE\.config\oh-my-posh\star-win-term.omp.json") -join "`n") | Invoke-Expression
