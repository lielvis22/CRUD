-- =====================================================================
--  Base de datos del laboratorio CRUD (ASP.NET Web Forms + MySQL)
--  Ejecutar completo en MySQL Workbench o en phpMyAdmin (pestaña SQL).
-- =====================================================================

CREATE DATABASE IF NOT EXISTS crudasp
  CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE crudasp;

-- ---------------------------------------------------------------------
-- Tabla usuarios (con campos de auditoría y borrado lógico)
--   Anulado = 1  -> registro activo
--   Anulado = 0  -> registro eliminado (se guarda FechaEliminacion)
-- ---------------------------------------------------------------------
DROP TABLE IF EXISTS usuarios;
CREATE TABLE usuarios (
    idUsuario         INT AUTO_INCREMENT PRIMARY KEY,
    Nombre            VARCHAR(150) NOT NULL,
    Edad              INT          NOT NULL,
    Correo            VARCHAR(150) NOT NULL,
    FechaNacimiento   DATE         NOT NULL,
    FechaModificacion DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FechaDeInsercion  DATETIME DEFAULT CURRENT_TIMESTAMP,
    Anulado           TINYINT(1) NOT NULL DEFAULT 1,
    FechaEliminacion  DATETIME NULL,
    CONSTRAINT uk_correo UNIQUE (Correo)
);

-- ---------------------------------------------------------------------
-- Procedimientos almacenados
-- ---------------------------------------------------------------------
DROP PROCEDURE IF EXISTS insert_user;
DROP PROCEDURE IF EXISTS sp_load;
DROP PROCEDURE IF EXISTS sp_read;
DROP PROCEDURE IF EXISTS sp_update;
DROP PROCEDURE IF EXISTS sp_delete;

DELIMITER //

-- CREATE: inserta un usuario nuevo
CREATE PROCEDURE insert_user(
    IN _nombre varchar(150),
    IN _correo varchar(150),
    IN _edad int,
    IN _fechanacimiento date)
BEGIN
    INSERT INTO usuarios (Nombre, Correo, Edad, FechaNacimiento)
    VALUES (_nombre, _correo, _edad, _fechanacimiento);
END//

-- LOAD: lista todos los usuarios activos (llena el GridView del Index)
CREATE PROCEDURE sp_load()
BEGIN
    SELECT idUsuario, Nombre, Edad, Correo, FechaNacimiento, FechaDeInsercion
    FROM usuarios
    WHERE Anulado = 1
    ORDER BY idUsuario;
END//

-- READ: trae un solo usuario por su id
CREATE PROCEDURE sp_read(IN _idUsuario int)
BEGIN
    SELECT * FROM usuarios WHERE idUsuario = _idUsuario;
END//

-- UPDATE: modifica un usuario (FechaModificacion se actualiza sola)
CREATE PROCEDURE sp_update(
    IN _idUsuario int,
    IN _nombre varchar(150),
    IN _correo varchar(150),
    IN _edad int,
    IN _fechanacimiento date)
BEGIN
    UPDATE usuarios
       SET Nombre = _nombre,
           Correo = _correo,
           Edad = _edad,
           FechaNacimiento = _fechanacimiento
     WHERE idUsuario = _idUsuario;
END//

-- DELETE (lógico): marca el registro como anulado y guarda la fecha
CREATE PROCEDURE sp_delete(IN _idUsuario int)
BEGIN
    UPDATE usuarios
       SET Anulado = 0, FechaEliminacion = NOW()
     WHERE idUsuario = _idUsuario;
END//

DELIMITER ;

-- ---------------------------------------------------------------------
-- Registros de prueba (las fechas deben ir en formato AAAA-MM-DD)
-- ---------------------------------------------------------------------
CALL insert_user('Fulano Demetrio', 'fulano@gmail.com',         25, '1990-02-04');
CALL insert_user('Perencebo',       'perencebocorreo@gmail.com', 30, '1990-02-07');
CALL insert_user('Claudia',         'claudiashifer@gmail.com',   30, '2000-02-04');

SELECT * FROM usuarios;
