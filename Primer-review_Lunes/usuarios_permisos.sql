USE hospital_sede;

-- CREAR USUARIOS
CREATE USER 'admin_clinica'@'localhost' IDENTIFIED BY 'admin123';
CREATE USER 'medico_clinica'@'localhost' IDENTIFIED BY 'medico123';
CREATE USER 'recepcionista_clinica'@'localhost' IDENTIFIED BY 'recep123';
CREATE USER 'auditor_clinica'@'localhost' IDENTIFIED BY 'audit123';

-- =========================================================
-- ADMIN (todo)
-- =========================================================
GRANT ALL PRIVILEGES ON hospital_sede.* TO 'admin_clinica'@'localhost';

-- =========================================================
-- MEDICO
-- =========================================================
GRANT SELECT ON hospital_sede.Pacientes TO 'medico_clinica'@'localhost';
GRANT SELECT ON hospital_sede.Medicos TO 'medico_clinica'@'localhost';
GRANT SELECT, INSERT ON hospital_sede.Citas TO 'medico_clinica'@'localhost';
GRANT SELECT, INSERT ON hospital_sede.Detalle_Receta TO 'medico_clinica'@'localhost';
GRANT EXECUTE ON PROCEDURE hospital_sede.InsertarCita TO 'medico_clinica'@'localhost';
GRANT EXECUTE ON PROCEDURE hospital_sede.ListarCitas TO 'medico_clinica'@'localhost';

-- =========================================================
-- RECEPCIONISTA
-- =========================================================
GRANT SELECT, INSERT, UPDATE ON hospital_sede.Pacientes TO 'recepcionista_clinica'@'localhost';
GRANT SELECT, INSERT, UPDATE ON hospital_sede.Citas TO 'recepcionista_clinica'@'localhost';
GRANT SELECT ON hospital_sede.Medicos TO 'recepcionista_clinica'@'localhost';
GRANT SELECT ON hospital_sede.Hospitales TO 'recepcionista_clinica'@'localhost';

GRANT EXECUTE ON PROCEDURE hospital_sede.insert_paciente TO 'recepcionista_clinica'@'localhost';
GRANT EXECUTE ON PROCEDURE hospital_sede.update_paciente TO 'recepcionista_clinica'@'localhost';
GRANT EXECUTE ON PROCEDURE hospital_sede.select_paciente TO 'recepcionista_clinica'@'localhost';

-- =========================================================
-- AUDITOR
-- =========================================================
GRANT SELECT ON hospital_sede.* TO 'auditor_clinica'@'localhost';

FLUSH PRIVILEGES;