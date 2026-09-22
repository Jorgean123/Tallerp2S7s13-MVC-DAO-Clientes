package com.utp.dao;
import com.utp.model.Cliente;
import java.sql.SQLException;
import java.util.List;

public interface ClienteDAO {
    List<Cliente> listarClientes() throws SQLException;
    boolean registrarCliente(Cliente c);
}
