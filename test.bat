@echo off
setlocal enabledelayedexpansion

:: Demander la lettre du disque à parcourir
set /p drive=Entrez la lettre du disque ou se trouve Star Citizen (ex: C, D, E) : 

:: Vérifier si le disque existe
if not exist %drive%:\ (
    echo Le disque %drive%: n'existe pas. Vérifiez la lettre et réessayez.
    pause
    exit /b
)

echo Recherche du dossier "StarCitizen" sur le disque %drive%: ...

:: Utilisation de dir pour rechercher le dossier StarCitizen
set StarCitizenPath=
for /f "delims=" %%d in ('dir "%drive%:\StarCitizen" /ad /s /b 2^>nul') do (
    set StarCitizenPath=%%d
    goto :found
)

if "%StarCitizenPath%"=="" (
    echo Aucun dossier "StarCitizen" trouvé sur le disque %drive%:.
    pause
    exit /b
)

:found
echo Dossier Star Citizen : %StarCitizenPath%
echo.

:: Recherche des sous-dossiers disponibles

set AvailableSubfolders=
set SubfolderCount=0

echo Version de Star Citizen installer :
for %%s in (LIVE PTU EPTU TECH-PREVIEW) do (
    if exist "%StarCitizenPath%\%%s" (
        echo - %%s
        set AvailableSubfolders=!AvailableSubfolders! %%s
	set /a SubfolderCount+=1
    )
)

:: Nettoyage des espaces au début de AvailableSubfolders
set AvailableSubfolders=%AvailableSubfolders:~1%

:: Si aucun sous-dossier n'est trouvé, arrêter le script
if %SubfolderCount% EQU 0 (
    echo Aucun version valide de Star Citizen trouver.
    pause
    exit /b
)

:: Demander à l'utilisateur de choisir un sous-dossier parmi ceux trouvés
echo.
set /p Subfolder=Entrez le nom de la version ou vous voulez installer la config : 

:: Vérifier si le choix est valide
echo %AvailableSubfolders% | findstr /i "\<%Subfolder%\>" >nul
if errorlevel 1 (
    echo La version "%Subfolder%" n'est pas valide ou n'existe pas.
    pause
    exit /b
)

:: Sauvegarder le chemin complet dans une variable
set SelectedPath=%StarCitizenPath%\%Subfolder%
echo Dossier sélectionné : %SelectedPath%

:: Vérifier si le dossier user\client\0\Controls\Mappings existe
set MappingPath=%SelectedPath%\user\client\0\Controls\Mappings
if not exist "%MappingPath%" (
    echo Le dossier "%MappingPath%" n'existe pas. Création en cours...
    mkdir "%MappingPath%"
    if exist "%MappingPath%" (
        echo Dossier "%MappingPath%" créé avec succès.
    ) else (
        echo Échec de la création du dossier "%MappingPath%".
    )
)
pause
exit
