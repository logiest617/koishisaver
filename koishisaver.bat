@echo off &PUSHD %~DP0 &TITLE logbot
chcp 65001  > nul
mode con cols=100 lines=35
color 02
:menu
cls
echo.
echo                        脚本菜单   
echo ==========================================================
echo.
echo ――――――――――【1】koishi救砖（抢救not found）   ―――――――
echo.
echo ――――――――――【2】ffmpeg 安装 （测试）          ―――――――
echo.
echo ――――――――――【3】ntqq 安装 （测试）            ―――――――
echo.
echo ――――――――――【4】liteloaderqqnt 安装 （测试）  ―――――――
echo.
echo ――――――――――【5】qsign 安装 （测试）           ―――――――
echo.
echo ――――――――――【6】云崽 安装 （测试）            ―――――――
echo.
echo ――――――――――【7】单独部署qsign 安装 （测试）   ―――――――
echo.
echo ――――――――――【0】关闭脚本                     ―――――――
echo.
echo ==========================================================
 
set /p user_input=选择并进入命令：
if %user_input%==1 goto a
if %user_input%==2 goto b
if %user_input%==3 goto c
if %user_input%==4 goto d
if %user_input%==5 goto e
if %user_input%==6 goto f
if %user_input%==7 goto g
if %user_input%==0 goto end
if not %user_input%=="" goto menu 
 
:a
REM 设置koishi实例安装位置
set KOISHI_PATH=%AppData%\Koishi\Desktop\data\instances
echo Koishi 实例位置： %KOISHI_PATH%
REM 遍历实例文件夹
setlocal EnableDelayedExpansion
set /a idx=0
REM 遍历主文件夹及其子文件夹中的所有文件夹，并将存在的文件夹名填充到数组中
for /d %%a in ("%KOISHI_PATH%\*") do (
  set /a "idx+=1"
  set "instance[!idx!]=%%~nxa"
  set "instancePath[!idx!]=%%~fa"
)
REM 显示数组元素
for /l %%i in (1,1,%idx%) do (
  echo [%%i] !instance[%%i]!
)
REM 要求用户输入数字以选择一个文件夹
set /p choice=请输入数字以选择需要修复的实例:
REM 如果只有一个结果，则直接将其设置为变量
if %idx%==1 (
  set "SelectedinstancePath=!instancePath[1]!"
) else (
  REM 设置变量为所选文件夹的路径
  set "SelectedinstancePath=!instancePath[%choice%]!"
)
echo 所选实例为: !instance[%choice%]!

REM 选择修复方式
echo.
echo 请选择修复方式：
echo.
echo 【1】重装依赖
echo.
echo 【2】迁移实例
echo.
echo 【3】新开实例
echo.
echo 三种修复方式自上而下保留的数据越少，修复的能力越强
echo.
set /p repair_choice=请输入数字以选择一个修复方式:
if %repair_choice%==1 goto repair1
if %repair_choice%==2 goto repair2
if %repair_choice%==3 goto repair2

:repair1
rem 修复方式一的代码段...
echo.
echo 你选择了重装依赖。
echo.
:: 重装依赖的命令
setlocal
:: 切换到C:\Program Files\Koishi\Desktop目录
cd /D "C:\Program Files\Koishi\Desktop"
:: 在这个目录下执行koi yarn -n default
koi --debug yarn -n default install
echo.
echo 依赖已重装，请尝试打开实例，如果依然not found，请尝试其他修复方式
echo.
goto end

:repair2
rem 修复方式三的代码段...
:: 在这里添加迁移实例的命令
set instance_LINK=https://ghproxy.com/https://github.com/koishijs/boilerplate/releases/download/v1.10.0/boilerplate-v1.10.0-windows-amd64-node18.zip

echo.
echo 正在下载实例压缩包
echo.
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%instance_LINK%', '%KOISHI_PATH%\default.zip')"
echo.
echo 实例压缩包下载完成
echo.

set "instancename=default"
set "counter=1"

for /L %%x in (1, 1, 100) do (
    if exist "!SelectedinstancePath!\!instancename!!counter!" (
        set /a counter+=1
        set "instancename=default!counter!"
    ) else (
        goto :unzipFile
    )
)

:unzipFile
:: 使用PowerShell解压zip文件到新的文件夹
echo.
echo 正在解压实例压缩包
echo.
powershell -Command "Expand-Archive -Path '%KOISHI_PATH%\default.zip' -DestinationPath '%KOISHI_PATH%\default%counter%'"
echo.
echo 实例压缩包解压完成
echo.
echo.
echo 实例名default%counter%
echo.

if "%repair_choice%"=="3" (
    goto end
) elseif "%repair_choice%"=="2" (
    goto copyfile
)

rem 修复方式二的代码段...
:copyfile
set "destpath=%KOISHI_PATH%\default%counter%"

:: 使用xcopy命令迁移文件夹
echo.
echo 正在迁移实例
echo.
xcopy /E /I /Y "%SelectedinstancePath%\data" "%destpath%\data"
xcopy /E /I /Y "%SelectedinstancePath%\node_modules" "%destpath%\node_modules"
xcopy /E /I /Y "%SelectedinstancePath%\logs" "%destpath%\logs"
echo.
echo 实例迁移完成
echo.
goto end

:b
set ffmpegUrl=https://ghproxy.com/https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-gpl.zip
set ffmpegoutputFile=ffmpeg.zip

echo 正在下载 FFmpeg 安装包...
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%ffmpegUrl%', '%ffmpegoutputFile%')"

echo 解压 FFmpeg 安装包...
powershell -Command "Expand-Archive -Path %ffmpegoutputFile% -DestinationPath .\"

echo 设置环境变量...
set PATH=%PATH%;%CD%\ffmpeg-master-latest-win64-gpl\bin

echo 测试 FFmpeg 是否成功安装...
ffmpeg -version

echo FFmpeg 安装完成！

:c
set ntqqdownloadUrl=https://dldir1.qq.com/qqfile/qq/QQNT/bef02a45/QQ9.9.2.16183_x64.exe
set ntqqoutputFile=QQ9.9.2.16183_x64.exe

echo.
echo 正在下载 ntQQ 安装包...
echo.
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%ntqqdownloadUrl%', '%ntqqoutputFile%')"

echo.
echo 正在打开 ntqqQQ 安装程序...
echo.
start %ntqqoutputFile%

echo.
echo ntQQ 安装程序已启动
echo.
pause

:d
set llntqqdownloadUrl=https://ghproxy.com/https://github.com/LiteLoaderQQNT/LiteLoaderQQNT/releases/download/0.5.3/LiteLoaderQQNT.zip
set llntqqlauncherurl=https://ghproxy.com/https://github.com/LiteLoaderQQNT/LiteLoaderQQNT/releases/download/0.5.3/LiteLoaderQQNT-Launcher_x64.exe
set llntqqoutputFolder=C:\Program Files\Tencent\QQNT\resources\app

echo.
echo 正在下载 LiteLoaderQQNT.zip...
echo.
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%llntqqdownloadUrl%', 'LiteLoaderQQNT.zip')"
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%llntqqlauncherurl%', '%llntqqoutputFolder%\LiteLoaderQQNT-Launcher_x64.exe')"

echo.
echo 正在解压 LiteLoaderQQNT.zip...
echo.
expand LiteLoaderQQNT.zip -F:* %llntqqoutputFolder%
powershell -Command "Expand-Archive -Path 'LiteLoaderQQNT.zip' -DestinationPath '%llntqqoutputFolder%'"

echo.
echo 解压完成！
echo.

set llntqqfile="C:\Program Files\Tencent\QQNT\resources\app\LiteLoaderQQNT-Launcher_x64.exe"

echo.
echo 正在以管理员身份启动 %llntqqfile%...
echo.

powershell Start-Process %llntqqfile% -Verb RunAs

echo.
echo %llntqqfile% 启动完成。
echo.

goto end


:e 
echo.
echo 安装qisin前，我非常建议你看一下hf部署qsign，免费、稳定、快捷，仓库地址：
echo https://github.com/logiest617/hf-bot
echo.
pause

echo.
echo 正在下载压缩包...
echo.
REM 在此处添加你的程序代码
:: 下载
set qsignurl=https://ghproxy.com/https://github.com/logiest617/unidbg-fetch-qsign-onekey/archive/refs/heads/main.zip
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%qsignurl%', 'main.zip')"

:: 解压
echo.
echo 正在解压压缩包...
echo.
powershell -Command "Expand-Archive -Path main.zip -DestinationPath '.\\'"


echo.
echo qsign&gocq已经下载完成，位置为脚本同级目录下unidbg-fetch-qsign-onekey文件夹内
echo 直接运行Start_Qsign.bat，并按提示输入账号和密码即可
echo 如果有任何疑问，可以前往https://github.com/logiest617/unidbg-fetch-qsign-onekey
echo.

goto end

:f 
echo.
echo 正在下载启动器...
echo.
set yunzaiurl=https://ghproxy.com/https://github.com/logiest617/YzLauncher-windows/blob/main/YzLauncher-windows.exe
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%yunzaiurl%', 'YzLauncher-windows.exe')"

echo.
echo 云崽启动器下载完成
echo 安装nodejs以及git后脚本同级目录下寻找YzLauncher-windows.exe并运行即可
echo odejs以及git的安装脚本正在紧急制作中
echo.
goto end

:g
echo.
echo 正在下载qsign启动器...
echo.
set qsign2url=https://ghproxy.com/https://github.com/CikeyQi/unidbg-fetch-qsign-gui/releases/download/1.0.4/unidbg-fetch-qsign-gui-1.0.4.exe
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%qsign2url%', 'YzLauncher-windows.exe')"

echo.
echo qsign启动器下载完成
echo 脚本同级目录下寻找unidbg-fetch-qsign-gui-1.0.4.exe并运行即可
echo.
goto end




:end
echo 修复完成。

