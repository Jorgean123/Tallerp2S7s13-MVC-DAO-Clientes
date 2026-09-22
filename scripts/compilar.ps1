param([string]$TomcatHome = 'C:\apache-tomcat-11.0.24')
$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$stage = Join-Path $root 'build\war'
$classes = Join-Path $stage 'WEB-INF\classes'
$lib = Join-Path $stage 'WEB-INF\lib'
New-Item -ItemType Directory -Force $classes,$lib,(Join-Path $root 'dist') | Out-Null
Copy-Item -Path (Join-Path $root 'src\main\webapp\*') -Destination $stage -Recurse -Force
Copy-Item -Path (Join-Path $root 'lib\*.jar') -Destination $lib -Force
$sources = @(Get-ChildItem (Join-Path $root 'src\main\java') -Filter '*.java' -Recurse | ForEach-Object FullName)
& javac --release 17 -encoding UTF-8 -cp (Join-Path $TomcatHome 'lib\servlet-api.jar') -d $classes @sources
if ($LASTEXITCODE -ne 0) { throw 'La compilacion Java fallo.' }
& jar --create --file (Join-Path $root 'dist\utp-clientes.war') -C $stage .
if ($LASTEXITCODE -ne 0) { throw 'No se pudo generar el WAR.' }
Write-Host 'Compilacion correcta: dist\utp-clientes.war'
