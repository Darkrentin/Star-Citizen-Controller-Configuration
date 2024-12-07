@echo off
setlocal enabledelayedexpansion

echo Recherche du fichier "Star Citizen" dans le dossier actuel...

:: Recherche dans le répertoire actuel et ses sous-dossiers
for /r %%f in (*Star Citizen*) do (
    echo %%f
)

echo Recherche terminée.
pause
