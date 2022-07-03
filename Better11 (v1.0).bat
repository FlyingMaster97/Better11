@echo off
rem Initial Release of Better11 (V1.0)

echo Welcome to the Better11 Project! (V1.0)

ver | find "n 10.0.22" >nul
if NOT %ERRORLEVEL%==0 (
	echo This could be because of an update, but we have seen that your Windows installation is not 11.
	goto exit
)

dism /? >nul
if NOT %ERRORLEVEL%==0 (
	echo You need to run this program as administrator.
	goto exit
)
if EXIST "%APPDATA%\Better11\warn.txt" goto skip_warning
echo ! WARNING ! Windows 11 could be damaged during the process.
echo If Windows 11 gets damaged, we are not responsible.
echo.
choice /c YN /m "Are you sure"
if %ERRORLEVEL%==2 goto exit
mkdir "%APPDATA%\Better11\"
echo This file was made because you agreed to the warning on Better11.>"%APPDATA%\Better11\warn.txt"
echo By deleting this file, you will add back the warning.>>"%APPDATA%\Better11\warn.txt"
:skip_warning

set explorer-ribbon=enabled
set context-menu=enabled
set desktop-mode=disabled
set advertisements=enabled
goto custom_menu

:custom_menu
if %explorer-ribbon%==enabled (set explorer-ribbon-select=*) else if %explorer-ribbon%==disabled (set explorer-ribbon-select=_)
if %context-menu%==enabled (set context-menu-select=*) else if %context-menu%==disabled (set context-menu-select=_)
if %desktop-mode%==enabled (set desktop-mode-select=*) else if %desktop-mode%==disabled (set desktop-mode-select=_)
if %advertisements%==enabled (set advertisements-select=*) else if %advertisements%==disabled (set advertisements-select=_)
cls
echo  What do you want to enable/disable?
echo.
echo   1: Classic Explorer Ribbon. [%explorer-ribbon-select%]
echo   2: Classic Context Menu. [%context-menu-select%]
echo   3: Classic Desktop Mode. [%desktop-mode-select%]
echo   4: Disable Advertisements. [%advertisements-select%]
echo   5: Apply Changes.
echo   6: Exit.
choice /c 123456 /n
if %ERRORLEVEL%==1 (
	if %explorer-ribbon%==enabled (
		set explorer-ribbon=disabled
		goto custom_menu
	) else if %explorer-ribbon%==disabled (
		set explorer-ribbon=enabled
		goto custom_menu
	)
)

if %ERRORLEVEL%==2 (
	if %context-menu%==enabled (
		set context-menu=disabled
		goto custom_menu
	) else if %context-menu%==disabled (
		set context-menu=enabled
		goto custom_menu
	)
)

if %ERRORLEVEL%==3 (
	if %desktop-mode%==enabled (
		set desktop-mode=disabled
		goto custom_menu
	) else if %desktop-mode%==disabled (
		set desktop-mode=enabled
		goto custom_menu
	)
)

if %ERRORLEVEL%==4 (
	if %advertisements%==enabled (
		set advertisements=disabled
		goto custom_menu
	) else if %advertisements%==disabled (
		set advertisements=enabled
		goto custom_menu
	)
)

if %ERRORLEVEL%==5 goto custom_apply
if %ERRORLEVEL%==6 goto exit

:custom_apply
cls
echo Applying Registry Tweaks.....
if %explorer-ribbon%==enabled ( reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /v "{e2bf9676-5f8f-435c-97eb-11607a5bedf7}" /t REG_SZ /f ) else if %explorer-ribbon%==disabled ( reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /v "{e2bf9676-5f8f-435c-97eb-11607a5bedf7}" /f )
if %context-menu%==enabled ( reg add "HKCU\SOFTWARE\CLASSES\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /ve /t REG_SZ /f ) else if %context-menu%==disabled ( reg delete "HKCU\SOFTWARE\CLASSES\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" /f )
if %desktop-mode%==enabled (
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell\Update\Packages" /v "UndockingDisabled" /t REG_DWORD /d 1 /f
	reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d 0 /f
	reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_ShowClassicMode" /t REG_DWORD /d 1 /f
	echo @echo off>"%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\explorer_shell_win10mode.cmd"
	echo start explorer.exe shell:::{05d7b0f4-2121-4eff-bf6b-ed3f69b894d9}>>"%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\explorer_shell_win10mode.cmd"
	echo del "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\explorer_shell_win10mode.cmd" /f>>"%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\explorer_shell_win10mode.cmd"
) else if %desktop-mode%==disabled (
	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell\Update\Packages" /v "UndockingDisabled" /f
	reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /f
	reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_ShowClassicMode" /f
	if EXIST "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\explorer_shell_win10mode.cmd" del "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\explorer_shell_win10mode.cmd" /f
)
if %advertisements%==enabled (
	reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSyncProviderNotifications" /t REG_DWORD /d 0 /f 
	reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "RotatingLockScreenEnabled" /t REG_DWORD /d 0 /f
	reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "RotatingLockScreenOverlayEnabled" /t REG_DWORD /d 0 /f
	reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338387Enabled" /t REG_DWORD /d 0 /f
) else if %advertisements%==disabled (
	reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSyncProviderNotifications" /f
	reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "RotatingLockScreenEnabled" /f
	reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "RotatingLockScreenOverlayEnabled" /f
	reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338387Enabled" /f
)
echo Please restart Windows 11.
echo.
pause
goto custom_menu

:exit
echo Exiting.....
timeout 3 >nul