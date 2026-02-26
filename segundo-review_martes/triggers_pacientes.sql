USE hospital_sede;

DROP TRIGGER IF EXISTS validar_paciente;

DELIMITER $$

CREATE TRIGGER validar_paciente
BEFORE INSERT ON Pacientes
FOR EACH ROW
BEGIN
    -- validar nombre
    IF NEW.Nombre = '' OR NEW.Nombre IS NULL THEN
        INSERT INTO Log_Errores(Procedimiento, Nombre_Tabla, Codigo_Error, Mensaje)
        VALUES('validar_paciente', 'Pacientes', 400,
                'El nombre del paciente no puede estar vacío');

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El nombre del paciente no puede estar vacío';
    END IF;

    -- validar telefono
    IF NEW.Telefono_Paciente = '' OR NEW.Telefono_Paciente IS NULL THEN
        INSERT INTO Log_Errores(Procedimiento, Nombre_Tabla, Codigo_Error, Mensaje)
        VALUES('validar_paciente', 'Pacientes', 400,
                'El teléfono del paciente no puede estar vacío');

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El teléfono del paciente no puede estar vacío';
    END IF;

    -- validar formato telefono
    IF NEW.Telefono_Paciente NOT REGEXP '^[0-9-]+$' THEN
        INSERT INTO Log_Errores(Procedimiento, Nombre_Tabla, Codigo_Error, Mensaje)
        VALUES('validar_paciente', 'Pacientes', 400,
                CONCAT('El teléfono ', NEW.Telefono_Paciente, ' tiene formato inválido'));

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El teléfono solo puede contener números y guiones';
    END IF;
END$$

DELIMITER ;

-- error nombre vacío
INSERT INTO Pacientes VALUES ('P-505', '', 'Lopez', '600-444');

-- error telefono vacío
INSERT INTO Pacientes VALUES ('P-505', 'Carlos', 'Lopez', '');

-- error formato telefono
INSERT INTO Pacientes VALUES ('P-505', 'Carlos', 'Lopez', 'abc-123');

-- correcto
INSERT INTO Pacientes VALUES ('P-505', 'Carlos', 'Lopez', '600-444');

SELECT * FROM Log_Errores ORDER BY Id_Log DESC;