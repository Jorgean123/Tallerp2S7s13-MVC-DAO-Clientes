CREATE DATABASE IF NOT EXISTS utp_clientes_s7 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE utp_clientes_s7;
CREATE TABLE IF NOT EXISTS tb_cliente (
 id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 nombre VARCHAR(100) NOT NULL,
 email VARCHAR(150) NOT NULL,
 CONSTRAINT uq_cliente_email UNIQUE (email)
);
INSERT INTO tb_cliente (nombre,email)
SELECT 'Ana Torres', 'ana.torres@example.com' WHERE NOT EXISTS (SELECT 1 FROM tb_cliente WHERE email='ana.torres@example.com');
INSERT INTO tb_cliente (nombre,email)
SELECT 'Luis Mendoza', 'luis.mendoza@example.com' WHERE NOT EXISTS (SELECT 1 FROM tb_cliente WHERE email='luis.mendoza@example.com');
INSERT INTO tb_cliente (nombre,email)
SELECT 'María Fernández', 'maria.fernandez@example.com' WHERE NOT EXISTS (SELECT 1 FROM tb_cliente WHERE email='maria.fernandez@example.com');
