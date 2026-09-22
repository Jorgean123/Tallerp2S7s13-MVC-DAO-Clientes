<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>Clientes | Laboratorio UTP</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/styles.css"></head>
<body>
<header><div class="brand"><span class="logo">UTP</span><span>Desarrollo Web Integrado<small>FACULTAD DE INGENIERÍA</small></span></div><span class="lab">LABORATORIO 07</span></header>
<main>
<div class="eyebrow">SEMANA 7 / SESIÓN 13</div>
<div class="hero"><div><h1>Gestión de clientes</h1><p>Registra clientes y consulta su información en un solo lugar.</p></div><span class="badge">MVC + DAO</span></div>
<c:if test="${not empty exito}"><div class="alert success" role="status"><c:out value="${exito}"/></div></c:if>
<c:if test="${not empty error}"><div class="alert error" role="alert"><c:out value="${error}"/></div></c:if>
<div class="layout"><section class="card form-card"><span class="section-number">01 / REGISTRO</span><h2>Nuevo cliente</h2><p class="hint">Completa los datos para agregar un cliente.</p>
<form action="${pageContext.request.contextPath}/registrarCliente" method="post">
<input type="hidden" name="csrf" value="<c:out value='${sessionScope.csrf}'/>">
<label for="nombre">Nombre completo</label><input id="nombre" name="nombre" maxlength="100" required autocomplete="name" placeholder="Ej. Ana Torres" value="<c:out value='${nombre}'/>">
<label for="email">Correo electrónico</label><input id="email" name="email" type="email" maxlength="150" required autocomplete="email" placeholder="nombre@ejemplo.com" value="<c:out value='${email}'/>">
<p class="field-note">Todos los campos son obligatorios.</p><button type="submit">Registrar cliente <span aria-hidden="true">↗</span></button>
</form><div class="form-footer">Cada correo identifica a un único cliente.</div></section>
<section class="card list-card"><div class="list-heading"><div><span class="section-number">02 / DIRECTORIO</span><h2>Clientes registrados</h2></div><span class="count"><c:out value="${empty total ? '—' : total}"/> clientes</span></div>
<div class="table-wrap"><table><thead><tr><th scope="col">ID</th><th scope="col">Nombre completo</th><th scope="col">Correo electrónico</th></tr></thead><tbody>
<c:forEach var="c" items="${listaClientes}"><tr><td class="id">#<c:out value="${c.id}"/></td><td class="name"><c:out value="${c.nombre}"/></td><td><c:out value="${c.email}"/></td></tr></c:forEach>
<c:if test="${empty listaClientes and empty error}"><tr><td colspan="3" class="empty">Aún no hay clientes. Registra el primero con el formulario.</td></tr></c:if>
</tbody></table></div><div class="table-footer">Directorio de clientes <span>Ordenado por ID</span></div></section></div>
<footer><span>Acosta Loyola, Jorge Eduardo · U22205593</span><span>Universidad Tecnológica del Perú</span></footer>
</main></body></html>
