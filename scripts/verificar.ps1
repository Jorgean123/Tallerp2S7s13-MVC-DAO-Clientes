param([string]$TomcatHome = 'C:\apache-tomcat-11.0.24')
$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$cp = "$root\build\war\WEB-INF\classes;$root\lib\*"
New-Item -ItemType Directory -Force "$root\build\tests" | Out-Null
& javac -encoding UTF-8 -cp $cp -d "$root\build\tests" "$root\tests\Verificacion.java"
if ($LASTEXITCODE -ne 0) { throw 'No se pudo compilar la prueba.' }
& java "-Dutp.clientes.config=$TomcatHome\conf\utp-clientes.properties" -cp "$root\build\tests;$cp" Verificacion
if ($LASTEXITCODE -ne 0) { throw 'La verificacion fallo.' }
