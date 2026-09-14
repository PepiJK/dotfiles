# PSReadLine
if ($PSVersionTable.PSVersion.Major -ge 7) {
	Set-PSReadLineOption -EditMode Windows `
						 -PredictionSource History `
						 -PredictionViewStyle ListView `
						 -Colors @{ "Error" = "#FF5555" }
} else {
	Set-PSReadLineOption -EditMode Windows `
						 -Colors @{ "Error" = "#FF5555" }
}

# aliases
Set-Alias -Name lg -Value lazygit
Set-Alias -Name co -Value copilot
function vibe { copilot --yolo @args }

# Herdr's server detachment requires the real Scoop binary, not its shim.
$HerdrExecutable = if ($env:SCOOP) {
	Join-Path $env:SCOOP "apps\herdr\current\herdr.exe"
}
if ($HerdrExecutable -and (Test-Path -LiteralPath $HerdrExecutable)) {
	function herdr {
		& $HerdrExecutable @args
	}
}

# fnm
fnm env --use-on-cd | Out-String | Invoke-Expression

# oh my posh
oh-my-posh init pwsh --config "$env:XDG_CONFIG_HOME\oh-my-posh\star-win-term.omp.json" --print | Out-String | Invoke-Expression
