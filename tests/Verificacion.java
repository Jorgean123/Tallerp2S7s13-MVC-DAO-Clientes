import com.utp.dao.*;
import com.utp.config.ConectaDB;
import com.utp.model.Cliente;
import java.sql.*;
import java.net.*;
import java.net.http.*;
import java.nio.charset.StandardCharsets;
import java.util.regex.*;

public class Verificacion {
    static void check(boolean value, String msg) {
        if (!value) throw new AssertionError(msg);
        System.out.println("OK - " + msg);
    }
    public static void main(String[] args) throws Exception {
        String base = "http://localhost:8080/utp-clientes";
        HttpClient http = HttpClient.newBuilder().cookieHandler(new CookieManager()).build();
        var page = http.send(HttpRequest.newBuilder(URI.create(base+"/listarClientes")).build(), HttpResponse.BodyHandlers.ofString());
        check(page.statusCode()==200 && page.body().contains("Clientes registrados"), "Listado JSP y JSTL: HTTP 200");
        Matcher m = Pattern.compile("name=\"csrf\" value=\"([^\"]+)\"").matcher(page.body());
        check(m.find(), "Token del formulario disponible");
        String csrf = m.group(1);
        String email = "prueba."+System.nanoTime()+"@example.com";
        String name = "María O'Connor <script>alert(1)</script>";
        ClienteDAO dao = new ClienteDAOImpl();
        int before = dao.listarClientes().size();
        try {
            String data="csrf="+csrf+"&nombre="+URLEncoder.encode(name,StandardCharsets.UTF_8)+"&email="+email;
            var result = post(http,base,data);
            check(result.statusCode()==303,"Registro HTTP y redirección PRG 303");
            check(dao.listarClientes().stream().anyMatch(c->c.getEmail().equals(email)&&c.getNombre().equals(name)),"Persistencia JDBC: acentos, comilla y texto literal");
            var listing = http.send(HttpRequest.newBuilder(URI.create(base+"/listarClientes")).build(),HttpResponse.BodyHandlers.ofString());
            check(listing.body().contains("&lt;script&gt;") && !listing.body().contains(name),"Escape HTML en la vista (sin ejecutar etiquetas)");
            check(post(http,base,data).statusCode()==409,"Correo duplicado rechazado");
            check(post(http,base,"csrf="+csrf+"&nombre=&email=incorrecto").statusCode()==400,"Validación del servidor HTTP 400");
            check(post(http,base,"csrf=incorrecto&nombre=Prueba&email=test@example.com").statusCode()==403,"Token incorrecto rechazado HTTP 403");
            check(dao.listarClientes().size()==before+1,"Sin filas extra por solicitudes inválidas");
        } finally {
            try(Connection con=ConectaDB.getConexion();PreparedStatement ps=con.prepareStatement("DELETE FROM tb_cliente WHERE email=?")) {
                ps.setString(1,email); ps.executeUpdate();
            }
        }
        check(dao.listarClientes().size()==before,"Datos de prueba eliminados");
        System.out.println("VERIFICACIÓN COMPLETA");
    }
    static HttpResponse<String> post(HttpClient client,String base,String data) throws Exception {
        return client.send(HttpRequest.newBuilder(URI.create(base+"/registrarCliente"))
            .header("Content-Type","application/x-www-form-urlencoded")
            .POST(HttpRequest.BodyPublishers.ofString(data)).build(),HttpResponse.BodyHandlers.ofString());
    }
}
