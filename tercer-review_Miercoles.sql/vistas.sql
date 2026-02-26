USE hospital_sede;

-- =========================================================
-- 1) Vista medico + especialidad + facultad + decano
-- =========================================================
DROP VIEW IF EXISTS vista_medico_facultad;

CREATE VIEW vista_medico_facultad AS
SELECT
    m.Medico_ID,
    m.Nombre AS Nombre_Medico,
    e.Especialidad,
    f.Facultad_Origen AS Nombre_Facultad,
    f.Decano_Facultad AS Decano
FROM Medicos m
JOIN Especialidades e ON m.Especialidad_ID = e.Especialidad_ID
JOIN Facultades f ON e.Facultad_ID = f.Facultad_ID;

-- =========================================================
-- 2) Vista pacientes por medicamento y dosis
-- =========================================================
DROP VIEW IF EXISTS vista_pacientes_medicamento;

CREATE VIEW vista_pacientes_medicamento AS
SELECT
    dr.Medicamento_ID,
    me.Medicamento_Recetado AS Medicamento,
    dr.Dosis_Medicamento AS Dosis,
    COUNT(DISTINCT c.Paciente_ID) AS Total_Pacientes
FROM Detalle_Receta dr
JOIN Citas c ON dr.Cod_Cita = c.Cod_Cita
JOIN Medicamentos me ON dr.Medicamento_ID = me.Medicamento_ID
GROUP BY dr.Medicamento_ID, me.Medicamento_Recetado, dr.Dosis_Medicamento;

-- Pruebas
SELECT * FROM vista_medico_facultad;
SELECT * FROM vista_pacientes_medicamento;