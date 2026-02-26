USE hospital_sede;

-- 1) Tabla del informe
CREATE TABLE IF NOT EXISTS Informe_Diario (
    Informe_ID INT AUTO_INCREMENT PRIMARY KEY,
    Fecha DATE NOT NULL,
    Hospital_ID VARCHAR(50) NOT NULL,
    Hospital_Sede VARCHAR(30) NOT NULL,
    Medico_ID VARCHAR(50) NOT NULL,
    Nombre_Medico VARCHAR(20) NOT NULL,
    Total_Pacientes INT NOT NULL,
    Fecha_Generado DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 2) Activar scheduler (requiere permisos de admin)
SET GLOBAL event_scheduler = ON;

-- 3) Evento diario
DROP EVENT IF EXISTS actualizar_informe_diario;
DELIMITER $$

CREATE EVENT actualizar_informe_diario
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    DELETE FROM Informe_Diario WHERE Fecha = CURDATE();

    INSERT INTO Informe_Diario (Fecha, Hospital_ID, Hospital_Sede, Medico_ID, Nombre_Medico, Total_Pacientes)
    SELECT
        CURDATE(),
        h.Hospital_ID,
        h.Hospital_Sede,
        m.Medico_ID,
        m.Nombre,
        COUNT(DISTINCT c.Paciente_ID) AS Total_Pacientes
    FROM Citas c
    JOIN Hospitales h ON c.Hospital_ID = h.Hospital_ID
    JOIN Medicos m ON c.Medico_ID = m.Medico_ID
    WHERE c.Fecha_Cita = CURDATE()
    GROUP BY h.Hospital_ID, h.Hospital_Sede, m.Medico_ID, m.Nombre;
END$$

DELIMITER ;

-- 4) Generar manual (por si quieres probar hoy sin esperar al evento)
DELETE FROM Informe_Diario WHERE Fecha = CURDATE();

INSERT INTO Informe_Diario (Fecha, Hospital_ID, Hospital_Sede, Medico_ID, Nombre_Medico, Total_Pacientes)
SELECT
    CURDATE(),
    h.Hospital_ID,
    h.Hospital_Sede,
    m.Medico_ID,
    m.Nombre,
    COUNT(DISTINCT c.Paciente_ID) AS Total_Pacientes
FROM Citas c
JOIN Hospitales h ON c.Hospital_ID = h.Hospital_ID
JOIN Medicos m ON c.Medico_ID = m.Medico_ID
WHERE c.Fecha_Cita = CURDATE()
GROUP BY h.Hospital_ID, h.Hospital_Sede, m.Medico_ID, m.Nombre;

SELECT * FROM Informe_Diario;