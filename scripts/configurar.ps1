param([string]$TomcatHome = 'C:\apache-tomcat-11.0.24', [string]$Usuario = 'root', [string]$Mysql = 'C:\Program Files\MySQL\MySQL Server 9.0\bin\mysql.exe')
$ErrorActionPreference = 'Stop'
$OutputEncoding = [Text.UTF8Encoding]::new()
$secret = Read-Host 'Clave de MySQL' -AsSecureString
$ptr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secret)
try {
    $password = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr)
    $env:MYSQL_PWD = $password
    Get-Content "$PSScriptRoot\..\database\01_clientes.sql" -Raw -Encoding UTF8 | & $Mysql -u $Usuario --default-character-set=utf8mb4
    if ($LASTEXITCODE -ne 0) { throw 'No se pudo preparar MySQL.' }
    $escaped = $password.Replace('\','\\').Replace(':','\:').Replace('=','\=')
    $config = [IO.File]::ReadAllText("$PSScriptRoot\..\config\db.properties.example").Replace('db.user=root', "db.user=$Usuario").Replace('CAMBIAR_EN_CONFIGURACION_LOCAL',$escaped)
    [IO.File]::WriteAllText("$TomcatHome\conf\utp-clientes.properties",$config)
    Write-Host 'Base de datos y configuracion listas.'
} finally {
    [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr)
    Remove-Item Env:MYSQL_PWD -ErrorAction SilentlyContinue
    $password = $null
}
