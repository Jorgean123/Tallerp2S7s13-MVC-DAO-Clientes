package com.utp.web;
import com.utp.dao.*;
import com.utp.model.Cliente;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.*;

@WebServlet(urlPatterns = {"/listarClientes", "/registrarCliente"})
public class ClienteServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Cache-Control", "no-store");
        HttpSession session = request.getSession();
        if (session.getAttribute("csrf") == null) session.setAttribute("csrf", UUID.randomUUID().toString());
        Object flash = session.getAttribute("exito");
        if (flash != null) { request.setAttribute("exito", flash); session.removeAttribute("exito"); }
        ClienteDAO dao = new ClienteDAOImpl();
        try {
            List<Cliente> lista = dao.listarClientes();
            request.setAttribute("listaClientes", lista);
            request.setAttribute("total", lista.size());
        } catch (SQLException e) {
            getServletContext().log("No se pudo listar clientes", e);
            response.setStatus(503);
            request.setAttribute("error", "No se pudo conectar con la base de datos. Intenta nuevamente.");
        }
        request.getRequestDispatcher("/WEB-INF/views/listarClientes.jsp").forward(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || !Objects.equals(session.getAttribute("csrf"), request.getParameter("csrf"))) {
            response.sendError(403, "Formulario vencido. Recarga la página."); return;
        }
        String nombre = Objects.toString(request.getParameter("nombre"), "").strip();
        String email = Objects.toString(request.getParameter("email"), "").strip();
        request.setAttribute("nombre", nombre);
        request.setAttribute("email", email);
        if (nombre.isEmpty() || nombre.length() > 100 || email.length() > 150
                || !email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
            response.setStatus(400);
            request.setAttribute("error", "Ingresa un nombre de hasta 100 caracteres y un correo válido de hasta 150 caracteres.");
            doGet(request, response); return;
        }
        ClienteDAO dao = new ClienteDAOImpl();
        if (!dao.registrarCliente(new Cliente(0, nombre, email))) {
            response.setStatus(409);
            request.setAttribute("error", "No se pudo registrar. Verifica que el correo no esté registrado e intenta nuevamente.");
            doGet(request, response); return;
        }
        session.setAttribute("exito", "Cliente registrado correctamente.");
        response.setStatus(303);
        response.setHeader("Location", request.getContextPath() + "/listarClientes");
    }
}
