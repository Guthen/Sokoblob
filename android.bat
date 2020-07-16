set mypath=%~dp0
set mypath=%mypath:~0,-1%

adb shell rm -r /sdcard/lovegame

adb push %mypath% /sdcard/lovegame

adb shell am force-stop org.love2d.android
adb shell am start org.love2d.android/.GameActivity

pause