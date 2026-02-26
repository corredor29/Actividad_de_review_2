USE hospital_sede;

CREATE TABLE Citas (
    Cod_Cita VARCHAR(50) NOT NULL,
    Fecha_Cita DATE NOT NULL,
    Paciente_ID VARCHAR(50) NOT NULL,
    Medico_ID VARCHAR(50) NOT NULL,
    Hospital_ID VARCHAR(50) NOT NULL,
    PRIMARY KEY (Cod_Cita, Fecha_Cita)
)
PARTITION BY RANGE (YEAR(Fecha_Cita)) (
    PARTITION p2023 VALUES LESS THAN (2024),
    PARTITION p2024 VALUES LESS THAN (2025),
    PARTITION p2025 VALUES LESS THAN (2026),
    PARTITION p_futuro VALUES LESS THAN MAXVALUE
);

CREATE TABLE Diagnostico (
    Cod_Cita VARCHAR(50) NOT NULL,
    Fecha_Cita DATE NOT NULL,
    Diagnostico VARCHAR(100) NOT NULL,
    PRIMARY KEY (Cod_Cita, Fecha_Cita),
    FOREIGN KEY (Cod_Cita, Fecha_Cita) REFERENCES Citas(Cod_Cita, Fecha_Cita)
);

CREATE TABLE Detalle_Receta (
    Cod_Cita VARCHAR(50) NOT NULL,
    Fecha_Cita DATE NOT NULL,
    Medicamento_ID VARCHAR(50) NOT NULL,
    Dosis_Medicamento VARCHAR(50) NOT NULL,
    PRIMARY KEY (Cod_Cita, Fecha_Cita, Medicamento_ID),
    FOREIGN KEY (Cod_Cita, Fecha_Cita) REFERENCES Citas(Cod_Cita, Fecha_Cita)
);