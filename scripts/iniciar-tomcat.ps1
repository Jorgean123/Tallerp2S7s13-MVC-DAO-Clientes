param([string]$TomcatHome = 'C:\apache-tomcat-11.0.24')
$ErrorActionPreference = 'Stop'
if (Get-NetTCPConnection -State Listen -LocalPort 8080 -ErrorAction SilentlyContinue) {
    Write-Host 'El puerto 8080 ya esta ocupado. Comprueba http://localhost:8080/utp-clientes/'
    exit 0
}
$java = (Get-Command java -ErrorAction Stop).Source
$javaArgs = @(
    ('-Dcatalina.home="{0}"' -f $TomcatHome),
    ('-Dcatalina.base="{0}"' -f $TomcatHome),
    ('-Djava.io.tmpdir="{0}\temp"' -f $TomcatHome),
    '-Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager',
    ('-Djava.util.logging.config.file="{0}\conf\logging.properties"' -f $TomcatHome),
    '-cp', ('"{0}\bin\bootstrap.jar;{0}\bin\tomcat-juli.jar"' -f $TomcatHome),
    'org.apache.catalina.startup.Bootstrap', 'start'
)
Start-Process -FilePath $java -ArgumentList $javaArgs -WindowStyle Hidden -WorkingDirectory $TomcatHome
Write-Host 'Tomcat iniciado en segundo plano. URL: http://localhost:8080/utp-clientes/'
