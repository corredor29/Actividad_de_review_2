USE hospital_sede;

-- TABLA DE LOGS 
CREATE TABLE IF NOT EXISTS Log_Errores (
    Id_Log INT AUTO_INCREMENT PRIMARY KEY,
    Procedimiento VARCHAR(100) NOT NULL,
    Nombre_Tabla VARCHAR(100) NOT NULL,
    Codigo_Error INT NULL,
    Mensaje TEXT NOT NULL,
    Fecha_Hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================================================
-- SELECT PACIENTE 
-- =========================================================
DROP PROCEDURE IF EXISTS select_paciente;
DELIMITER $$

CREATE PROCEDURE select_paciente(IN p_id VARCHAR(50))
BEGIN
    DECLARE existe INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = MYSQL_ERRNO, @msg = MESSAGE_TEXT;

        INSERT INTO Log_Errores(Procedimiento, Nombre_Tabla, Codigo_Error, Mensaje)
        VALUES('select_paciente', 'Pacientes', @cod,
                CONCAT('Error al consultar paciente: ', @msg));
    END;

    IF p_id IS NULL THEN
        SET @v_sql = 'SELECT * FROM Pacientes';
        PREPARE stmt FROM @v_sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    ELSE
        SELECT COUNT(*) INTO existe
        FROM Pacientes
        WHERE Paciente_ID = p_id;

        IF existe = 0 THEN
            INSERT INTO Log_Errores(Procedimiento, Nombre_Tabla, Codigo_Error, Mensaje)
            VALUES('select_paciente', 'Pacientes', 404,
                    CONCAT('El paciente ', p_id, ' no existe'));
        ELSE
            SET @v_sql = 'SELECT * FROM Pacientes WHERE Paciente_ID = ?';
            SET @pid = p_id;
            PREPARE stmt FROM @v_sql;
            EXECUTE stmt USING @pid;
            DEALLOCATE PREPARE stmt;
        END IF;
    END IF;
END$$
DELIMITER ;

-- =========================================================
-- INSERT PACIENTE
-- =========================================================
DROP PROCEDURE IF EXISTS insert_paciente;
DELIMITER $$

CREATE PROCEDURE insert_paciente(
    IN p_id VARCHAR(50),
    IN p_nombre VARCHAR(20),
    IN p_apellido VARCHAR(20),
    IN p_tel VARCHAR(20)
)
BEGIN
    DECLARE existe INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = MYSQL_ERRNO, @msg = MESSAGE_TEXT;

        INSERT INTO Log_Errores(Procedimiento, Nombre_Tabla, Codigo_Error, Mensaje)
        VALUES('insert_paciente', 'Pacientes', @cod,
                CONCAT('Error al insertar paciente: ', @msg));
    END;

    SELECT COUNT(*) INTO existe
    FROM Pacientes
    WHERE Paciente_ID = p_id;

    IF existe > 0 THEN
        INSERT INTO Log_Errores(Procedimiento, Nombre_Tabla, Codigo_Error, Mensaje)
        VALUES('insert_paciente', 'Pacientes', 409,
                CONCAT('El paciente ', p_id, ' ya existe'));
    ELSE
        SET @v_sql = 'INSERT INTO Pacientes(Paciente_ID, Nombre, Apellido, Telefono_Paciente) VALUES(?, ?, ?, ?)';
        SET @pid = p_id;
        SET @pnombre = p_nombre;
        SET @papellido = p_apellido;
        SET @ptel = p_tel;

        PREPARE stmt FROM @v_sql;
        EXECUTE stmt USING @pid, @pnombre, @papellido, @ptel;
        DEALLOCATE PREPARE stmt;
    END IF;
END$$
DELIMITER ;

-- =========================================================
-- UPDATE PACIENTE
-- =========================================================
DROP PROCEDURE IF EXISTS update_paciente;
DELIMITER $$

CREATE PROCEDURE update_paciente(
    IN p_id VARCHAR(50),
    IN p_nombre VARCHAR(20),
    IN p_apellido VARCHAR(20),
    IN p_tel VARCHAR(20)
)
BEGIN
    DECLARE existe INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = MYSQL_ERRNO, @msg = MESSAGE_TEXT;

        INSERT INTO Log_Errores(Procedimiento, Nombre_Tabla, Codigo_Error, Mensaje)
        VALUES('update_paciente', 'Pacientes', @cod,
                CONCAT('Error al actualizar paciente: ', @msg));
    END;

    SELECT COUNT(*) INTO existe
    FROM Pacientes
    WHERE Paciente_ID = p_id;

    IF existe = 0 THEN
        INSERT INTO Log_Errores(Procedimiento, Nombre_Tabla, Codigo_Error, Mensaje)
        VALUES('update_paciente', 'Pacientes', 404,
                CONCAT('El paciente ', p_id, ' no existe'));
    ELSE
        SET @v_sql = 'UPDATE Pacientes SET Nombre = ?, Apellido = ?, Telefono_Paciente = ? WHERE Paciente_ID = ?';
        SET @pnombre = p_nombre;
        SET @papellido = p_apellido;
        SET @ptel = p_tel;
        SET @pid = p_id;

        PREPARE stmt FROM @v_sql;
        EXECUTE stmt USING @pnombre, @papellido, @ptel, @pid;
        DEALLOCATE PREPARE stmt;
    END IF;
END$$
DELIMITER ;

-- =========================================================
-- DELETE PACIENTE
-- =========================================================
DROP PROCEDURE IF EXISTS delete_paciente;
DELIMITER $$

CREATE PROCEDURE delete_paciente(IN p_id VARCHAR(50))
BEGIN
    DECLARE existe INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = MYSQL_ERRNO, @msg = MESSAGE_TEXT;

        INSERT INTO Log_Errores(Procedimiento, Nombre_Tabla, Codigo_Error, Mensaje)
        VALUES('delete_paciente', 'Pacientes', @cod,
                CONCAT('Error al eliminar paciente: ', @msg));
    END;

    SELECT COUNT(*) INTO existe
    FROM Pacientes
    WHERE Paciente_ID = p_id;

    IF existe = 0 THEN
        INSERT INTO Log_Errores(Procedimiento, Nombre_Tabla, Codigo_Error, Mensaje)
        VALUES('delete_paciente', 'Pacientes', 404,
                CONCAT('El paciente ', p_id, ' no existe'));
    ELSE
        SET @v_sql = 'DELETE FROM Pacientes WHERE Paciente_ID = ?';
        SET @pid = p_id;

        PREPARE stmt FROM @v_sql;
        EXECUTE stmt USING @pid;
        DEALLOCATE PREPARE stmt;
    END IF;
END$$
DELIMITER ;

-- =========================================================
-- PRUEBAS
-- =========================================================
CALL insert_paciente('P-504', 'Carlos', 'Lopez', '600-444');
CALL update_paciente('P-504', 'Carlos', 'Lopez Jr', '600-555');
CALL select_paciente(NULL);
CALL select_paciente('P-504');
CALL delete_paciente('P-504');

-- Ver logs
SELECT * FROM Log_Errores ORDER BY Id_Log DESC;