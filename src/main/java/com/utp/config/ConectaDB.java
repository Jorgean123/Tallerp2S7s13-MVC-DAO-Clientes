package com.utp.config;

import java.io.*;
import java.nio.file.*;
import java.sql.*;
import java.util.Properties;

public final class ConectaDB {
    private ConectaDB() { }
    public static Connection getConexion() throws SQLException {
        Properties p = new Properties();
        String file = System.getProperty("utp.clientes.config",
            System.getProperty("catalina.base", ".") + "/conf/utp-clientes.properties");
        try (InputStream in = Files.newInputStream(Path.of(file))) {
            p.load(in);
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (IOException | ClassNotFoundException e) {
            throw new SQLException("No se pudo cargar la configuración de clientes.", e);
        }
        return DriverManager.getConnection(p.getProperty("db.url"),
            p.getProperty("db.user"), p.getProperty("db.password"));
    }
}
