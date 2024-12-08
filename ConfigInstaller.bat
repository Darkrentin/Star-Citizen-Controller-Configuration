chcp 65001
@echo off
setlocal enabledelayedexpansion

cls
echo ============================
echo    Star Citizen Controller
echo    Configuration Installer
echo ============================
echo.
echo Script d'installation d'une configuration manette pour Star Citizen.
echo.
echo Auteur: Varius
echo Proposé par: La légion Écarlate
echo.
echo Appuyez sur une touche pour commencer l'installation...
pause >nul
echo.

:: Demander la lettre du disque où se trouve Star Citizen
set /p drive=Entrez la lettre du disque où se trouve Star Citizen (ex: C, D, E) : 

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
echo.
echo Dossier Star Citizen trouvé : %StarCitizenPath%
echo.

:: Recherche des sous-dossiers disponibles

set AvailableSubfolders=
set SubfolderCount=0

:chooseVersion
echo Versions de Star Citizen installées :
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
    echo Aucune version valide de Star Citizen trouvée.
    pause
    exit /b
)

:: Demander à l'utilisateur de choisir un sous-dossier parmi ceux trouvés
echo.
set /p Subfolder=Entrez le nom de la version pour laquelle vous voulez installer la configuration : 

:: Vérifier si le choix est vide
if "%Subfolder%"=="" (
    echo.
    echo Vous devez entrer un nom de version.
    goto :chooseVersion
)

:: Vérifier si le choix est valide
echo %AvailableSubfolders% | findstr /i "\<%Subfolder%\>" >nul
if errorlevel 1 (
    echo.
    echo La version "%Subfolder%" n'est pas valide ou n'existe pas.
    goto :chooseVersion
)

:: Sauvegarder le chemin complet dans une variable
set SelectedPath=%StarCitizenPath%\%Subfolder%
echo Dossier sélectionné : %SelectedPath%

:: Vérifier si le dossier user\client\0\Controls\Mappings existe
set MappingPath=%SelectedPath%\user\client\0\Controls\Mappings
if not exist "%MappingPath%" (
    mkdir "%MappingPath%"
    
)

:: Télécharger le fichier test.txt depuis GitHub
curl -sL https://raw.githubusercontent.com/Darkrentin/Star-Citizen-Controller-Configuration/main/test.txt -o "%SelectedPath%\user\client\0\Controls\Mappings\test.txt"

:: Vérifier si le téléchargement a réussi
if exist "%SelectedPath%\user\client\0\Controls\Mappings\test.txt" (
    echo La configuration a été installée avec succès.
) else (
    echo Erreur de téléchargement du fichier.
)

echo.
echo Vous pouvez maintenant lancer Star Citizen et charger le profil :
echo.
pause
