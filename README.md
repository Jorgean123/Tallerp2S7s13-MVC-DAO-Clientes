# Laboratorio 7 · MVC y DAO · Clientes

**Estudiante:** Acosta Loyola, Jorge Eduardo · U22205593  
**Curso:** Desarrollo Web Integrado · Semana 7, sesión 13  
**Aplicación:** http://localhost:8080/utp-clientes/listarClientes

## Descargas

- [Documento Word desarrollado](entrega/Ficha_Laboratorio_7_MVC_DAO_Acosta_Loyola.docx)
- [Programa completo en ZIP](entrega/Programa_Clientes_MVC_DAO.zip)
- [WAR compilado para Tomcat](dist/utp-clientes.war)

La aplicación se ejecuta localmente con Tomcat y MySQL; el repositorio contiene el código y los entregables.

## Funcionalidad

Listado y registro de clientes con Servlet controlador, JavaBean, interfaz DAO, JDBC con PreparedStatement y vista JSP con EL/JSTL. Validación del servidor, correos únicos, escape HTML, token de formulario y redirección posterior al registro. La base `utp_clientes_s7` es independiente de otros proyectos.

## Ejecutar en este equipo

Ya se creó la base y se desplegó `dist/utp-clientes.war` en el Tomcat instalado. La configuración privada está en `C:\apache-tomcat-11.0.24\conf\utp-clientes.properties`; no se incluye la contraseña en el código ni en la entrega.

```powershell
powershell -ExecutionPolicy Bypass -File scripts/iniciar-tomcat.ps1
```

Abrir la URL indicada. Si otro proceso usa 8080, comprobar que corresponde a este Tomcat.

## Instalar desde el ZIP en otro equipo

Se requiere JDK 17 o superior (probado con JDK 21), Tomcat 11 y MySQL. No se requiere Maven: los JAR están incluidos.

```powershell
powershell -ExecutionPolicy Bypass -File scripts/configurar.ps1
powershell -ExecutionPolicy Bypass -File scripts/desplegar.ps1
powershell -ExecutionPolicy Bypass -File scripts/verificar.ps1
```

Los scripts admiten `-TomcatHome`. `configurar.ps1` admite `-Mysql` y `-Usuario` y solicita la clave de manera oculta. La configuración predeterminada usa MySQL local; para otra dirección editar el archivo privado de Tomcat. El script SQL es repetible y no elimina tablas existentes. Para caracteres no ASCII en los datos de ejemplo, ejecutar PowerShell con salida UTF-8 (`$OutputEncoding = [Text.UTF8Encoding]::new()`).

Alternativa con Maven instalado: `mvn clean package` genera `target/utp-clientes.war`.

## Estructura

```text
src/main/java/com/utp/
  model/Cliente.java             JavaBean
  dao/ClienteDAO.java            Contrato de persistencia
  dao/ClienteDAOImpl.java        SQL parametrizado y cierre de recursos
  config/ConectaDB.java          Conexión y configuración externa
  web/ClienteServlet.java        GET, POST, validación y navegación
src/main/webapp/WEB-INF/views/listarClientes.jsp
src/main/webapp/assets/styles.css
database/01_clientes.sql
scripts/                        Configuración, compilación, despliegue y pruebas
tests/Verificacion.java          Integración real HTTP + MySQL
evidencias/pruebas.txt           Resultado de las pruebas ejecutadas
dist/utp-clientes.war            Aplicación compilada
```

## Compatibilidad con la ficha

La ficha usa Java EE y la URI antigua de JSTL. El programa usa `jakarta.servlet.*` y `jakarta.tags.core`, compatibles con Tomcat 11. La vista se protege bajo `WEB-INF` para ingresar a través del controlador. Las respuestas literales de la ficha y la explicación de estas adaptaciones están en el documento final.

Referencias oficiales: https://tomcat.apache.org/migration-11.0.html y https://jakarta.ee/specifications/tags/3.0/tagdocs/c/tld-summary.

## Evidencia y alcance

Las pruebas ejecutadas verifican listado, registro persistente, duplicados, validación, escape HTML y rechazo de token inválido. El programa es un laboratorio local sin autenticación de usuarios. El navegador conectado no estuvo disponible: queda pendiente capturar la tabla visualmente para Canvas. Abrir la URL, usar `Win + Shift + S` y guardar la captura. La entrega no ha sido subida a Canvas.
