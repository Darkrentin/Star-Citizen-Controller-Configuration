@echo off
setlocal enabledelayedexpansion

echo Recherche du fichier "StarCitizen" dans le dossier actuel...

:: Recherche dans le dossier actuel et ses sous-répertoires
for /d /r %%d in (StarCitizen) do (
    echo Dossier trouvé : %%d
    goto :found
)

echo Aucune correspondance trouvée.
goto :end

:found
pause
:end
