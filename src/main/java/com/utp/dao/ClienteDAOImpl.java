package com.utp.dao;
import com.utp.config.ConectaDB;
import com.utp.model.Cliente;
import java.sql.*;
import java.util.*;
import java.util.logging.*;

public class ClienteDAOImpl implements ClienteDAO {
    private static final Logger LOG = Logger.getLogger(ClienteDAOImpl.class.getName());
    @Override
    public List<Cliente> listarClientes() throws SQLException {
        List<Cliente> lista = new ArrayList<>();
        String sql = "SELECT id, nombre, email FROM tb_cliente ORDER BY id";
        try (Connection con = ConectaDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(new Cliente(rs.getInt("id"), rs.getString("nombre"), rs.getString("email")));
            }
        }
        return lista;
    }
    @Override
    public boolean registrarCliente(Cliente c) {
        boolean estado = false;
        String sql = "INSERT INTO tb_cliente (nombre, email) VALUES (?, ?)";
        try (Connection con = ConectaDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, c.getNombre());
            ps.setString(2, c.getEmail());
            if (ps.executeUpdate() > 0) {
                estado = true;
            }
        } catch (SQLException e) {
            LOG.log(Level.WARNING, "Registro no completado. SQLState: " + e.getSQLState());
        }
        return estado;
    }
}
