# Sistema Hospitalario — Base de Datos SQL

## Descripción
Este proyecto implementa el diseño y desarrollo de una base de datos para un sistema hospitalario utilizando **MySQL**, aplicando:

- Normalización (hasta 4FN)
- Procedimientos almacenados (CRUD)
- Funciones
- Triggers
- Eventos
- Vistas
- Usuarios y permisos
- Logs de errores
- Particionamiento
- SQL dinámico

---

## Modelo de datos

### Tablas principales
- Pacientes
- Medicos
- Especialidades
- Facultades
- Hospitales
- Citas
- Diagnostico
- Medicamentos
- Detalle_Receta
- Log_Errores
- Informe_Diario

---

## Normalización
El modelo cumple:

- 1FN → datos atómicos
- 2FN → eliminación de dependencias parciales
- 3FN → eliminación de dependencias transitivas
- 4FN → separación de listas multivaluadas

---

## Procedimientos almacenados (CRUD)

Se implementaron CRUD completos para:

- Pacientes
- Facultades
- Especialidades
- Medicos
- Hospitales
- Citas
- Diagnostico
- Medicamentos
- Detalle_Receta

Incluyen:

- Validaciones
- SQL dinámico
- Manejo de errores
- Registro en logs

---

## Funciones implementadas

- TotalDoctoresPorEspecialidad()
- TotalPacientesPorMedico()
- TotalPacientesPorSede()
- Funciones de validación (ValidarPaciente, ValidarCita, etc.)

---

## Triggers

### Validación de citas
- Impide fechas futuras
- Registra errores en Log_Errores

### Validación de pacientes
- Nombre obligatorio
- Teléfono obligatorio
- Validación de formato del teléfono

---

## Eventos

### Informe diario
Evento programado que:

- Genera informe de pacientes atendidos por médico y sede
- Se ejecuta diariamente
- Guarda resultados en Informe_Diario

---

## Logs de errores
Tabla `Log_Errores` para registrar:

- Procedimiento
- Tabla afectada
- Código de error
- Mensaje
- Fecha y hora

Se usa en:

- CRUD
- Triggers
- Funciones

---

## Vistas

### vista_medico_facultad
Relaciona:

- Médico
- Especialidad
- Facultad
- Decano

### vista_pacientes_medicamento
Muestra:

- Medicamento
- Dosis
- Total de pacientes atendidos

---

## Usuarios y permisos

Usuarios creados:

- admin_clinica → acceso total
- medico_clinica → consultas + registro de citas y medicamentos
- recepcionista_clinica → gestión de pacientes y citas
- auditor_clinica → solo lectura

---

## Particionamiento
La tabla **Citas** se particiona por año usando:

## Creador 
Felipe corredor silva