# PSReadLine
Set-PSReadLineOption -EditMode Windows `
					 -PredictionSource History `
					 -PredictionViewStyle ListView `
					 -Colors @{ "Error" = "#FF5555" }

# aliases
Set-Alias -Name lg -Value lazygit

# oh my posh
oh-my-posh init pwsh --config "$env:USERPROFILE\.config\oh-my-posh\star-win-term.omp.json" | Invoke-Expression
