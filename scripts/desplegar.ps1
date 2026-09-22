param([string]$TomcatHome = 'C:\apache-tomcat-11.0.24')
$ErrorActionPreference = 'Stop'
& "$PSScriptRoot\compilar.ps1" -TomcatHome $TomcatHome
Copy-Item "$PSScriptRoot\..\dist\utp-clientes.war" "$TomcatHome\webapps\utp-clientes.war" -Force
& "$PSScriptRoot\iniciar-tomcat.ps1" -TomcatHome $TomcatHome
