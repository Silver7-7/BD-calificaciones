CREATE DATABASE calificaciones_utp;

USE calificaciones_utp;

-- TABLAS PRINCIPALES

-- Tabla Persona (base para estudiantes y profesores)
CREATE TABLE Persona (
    persona_id INT PRIMARY KEY AUTO_INCREMENT,
    tipo ENUM('Estudiante', 'Profesor') NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    dni VARCHAR(20) UNIQUE NOT NULL,
    fecha_nacimiento DATE,
    correo VARCHAR(100) UNIQUE NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CHECK (correo LIKE '%@utp.ac.pa')
);

-- Tabla Estudiante (extiende Persona)
CREATE TABLE Estudiante (
    estudiante_id INT PRIMARY KEY AUTO_INCREMENT,
    persona_id INT UNIQUE NOT NULL,
    codigo_estudiante VARCHAR(20) UNIQUE NOT NULL,
    fecha_ingreso DATE NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (persona_id) REFERENCES Persona(persona_id)
);

-- Tabla Profesor (extiende Persona)
CREATE TABLE Profesor (
    profesor_id INT PRIMARY KEY AUTO_INCREMENT,
    persona_id INT UNIQUE NOT NULL,
    codigo_profesor VARCHAR(20) UNIQUE NOT NULL,
    especialidad VARCHAR(100) NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (persona_id) REFERENCES Persona(persona_id)
);

-- Tabla Asignatura (materias)
CREATE TABLE Asignatura (
    asignatura_id INT PRIMARY KEY AUTO_INCREMENT,
    codigo_asignatura VARCHAR(20) UNIQUE NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    creditos INT NOT NULL CHECK (creditos > 0),
    descripcion TEXT,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabla Salón (aulas físicas)
CREATE TABLE Salon (
    salon_id INT PRIMARY KEY AUTO_INCREMENT,
    codigo_salon VARCHAR(20) UNIQUE NOT NULL,
    edificio VARCHAR(50) NOT NULL,
    capacidad INT NOT NULL CHECK (capacidad > 0),
    recursos TEXT,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabla Periodo (ciclos académicos)
CREATE TABLE Periodo (
    periodo_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CHECK (fecha_fin > fecha_inicio)
);

-- TABLAS DE RELACIÓN

-- Tabla Curso (instancia de asignatura en periodo)
CREATE TABLE Curso (
    curso_id INT PRIMARY KEY AUTO_INCREMENT,
    asignatura_id INT NOT NULL,
    periodo_id INT NOT NULL,
    salon_id INT NOT NULL,
    hora_inicio TIME NOT NULL DEFAULT '08:00:00',
    hora_fin TIME NOT NULL DEFAULT '10:00:00',
    dias_semana VARCHAR(50) NOT NULL DEFAULT 'Lunes,Miércoles',
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (asignatura_id) REFERENCES Asignatura(asignatura_id),
    FOREIGN KEY (periodo_id) REFERENCES Periodo(periodo_id),
    FOREIGN KEY (salon_id) REFERENCES Salon(salon_id),
    UNIQUE (asignatura_id, periodo_id)
);

-- Tabla ProfesorAsignatura (qué profesores pueden dictar qué asignaturas)
CREATE TABLE ProfesorAsignatura (
    profesor_id INT NOT NULL,
    asignatura_id INT NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (profesor_id, asignatura_id),
    FOREIGN KEY (profesor_id) REFERENCES Profesor(profesor_id),
    FOREIGN KEY (asignatura_id) REFERENCES Asignatura(asignatura_id)
);

-- Tabla Curso Profesor (profesores asignados a cursos)
CREATE TABLE Curso_Profesor (
    curso_profesor_id INT PRIMARY KEY AUTO_INCREMENT,
    curso_id INT NOT NULL,
    profesor_id INT NOT NULL,
    tipo_responsable ENUM('Titular', 'Auxiliar') NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (curso_id) REFERENCES Curso(curso_id),
    FOREIGN KEY (profesor_id) REFERENCES Profesor(profesor_id),
    UNIQUE (curso_id, profesor_id, tipo_responsable)
);

-- Tabla Inscripción (matrículas de estudiantes)
CREATE TABLE Inscripcion (
    inscripcion_id INT PRIMARY KEY AUTO_INCREMENT,
    estudiante_id INT NOT NULL,
    curso_id INT NOT NULL,
    nota_final DECIMAL(5,2) CHECK (nota_final >= 0 AND nota_final <= 20),
    estado ENUM('Cursando', 'Aprobado', 'Desaprobado', 'Retirado') DEFAULT 'Cursando',
    fecha DATE NOT NULL DEFAULT (CURRENT_DATE),
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (estudiante_id) REFERENCES Estudiante(estudiante_id),
    FOREIGN KEY (curso_id) REFERENCES Curso(curso_id),
    UNIQUE (estudiante_id, curso_id)
);

-- Tabla Evaluación (exámenes/trabajos)
CREATE TABLE Evaluacion (
    evaluacion_id INT PRIMARY KEY AUTO_INCREMENT,
    curso_id INT NOT NULL,
    tipo ENUM('Parcial', 'Final', 'Trabajo', 'Práctica') NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    peso DECIMAL(3,2) NOT NULL CHECK (peso > 0 AND peso <= 1),
    fecha DATE NOT NULL,
    hora_inicio TIME,
    hora_fin TIME,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (curso_id) REFERENCES Curso(curso_id)
);

-- Tabla Calificación (notas de estudiantes)
CREATE TABLE Calificacion (
    calificacion_id INT PRIMARY KEY AUTO_INCREMENT,
    inscripcion_id INT NOT NULL,
    evaluacion_id INT NOT NULL,
    tipo ENUM('Parcial', 'Final', 'Trabajo', 'Práctica') NOT NULL,
    nota DECIMAL(5,2) NOT NULL CHECK (nota >= 0 AND nota <= 20),
    es_definitiva BOOLEAN DEFAULT FALSE,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (inscripcion_id) REFERENCES Inscripcion(inscripcion_id),
    FOREIGN KEY (evaluacion_id) REFERENCES Evaluacion(evaluacion_id),
    UNIQUE (inscripcion_id, evaluacion_id)
);

-- Mostrar todas las tablas
SHOW TABLES;