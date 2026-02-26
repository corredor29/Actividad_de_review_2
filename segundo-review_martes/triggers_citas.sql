USE hospital_sede;

-- Por si no existe la tabla de logs
CREATE TABLE IF NOT EXISTS Log_Errores (
    Id_Log INT AUTO_INCREMENT PRIMARY KEY,
    Procedimiento VARCHAR(100) NOT NULL,
    Nombre_Tabla VARCHAR(100) NOT NULL,
    Codigo_Error INT NULL,
    Mensaje TEXT NOT NULL,
    Fecha_Hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DROP TRIGGER IF EXISTS validar_fecha_cita;

DELIMITER $$

CREATE TRIGGER validar_fecha_cita
BEFORE INSERT ON Citas
FOR EACH ROW
BEGIN
    DECLARE v_cod INT;
    DECLARE v_msg TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_cod = MYSQL_ERRNO,
            v_msg = MESSAGE_TEXT;

        INSERT INTO Log_Errores(Procedimiento, Nombre_Tabla, Codigo_Error, Mensaje)
        VALUES('validar_fecha_cita', 'Citas', v_cod, v_msg);
    END;

    IF NEW.Fecha_Cita > CURDATE() THEN
        INSERT INTO Log_Errores(Procedimiento, Nombre_Tabla, Codigo_Error, Mensaje)
        VALUES('validar_fecha_cita', 'Citas', 400,
                CONCAT('La fecha ', NEW.Fecha_Cita, ' no puede ser futura'));

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La fecha de la cita no puede ser futura';
    END IF;
END$$

DELIMITER ;

-- PRUEBA (debe fallar y dejar log)
INSERT INTO Citas (Cod_Cita, Fecha_Cita, Paciente_ID, Medico_ID, Hospital_ID)
VALUES ('C-009', '2027-01-01', 'P-501', 'M-10', 'H-01');

SELECT * FROM Log_Errores ORDER BY Id_Log DESC;