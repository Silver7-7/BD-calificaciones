-- DATOS PARA TABLAS PRINCIPALES

-- 1. Personas (5 estudiantes y 3 profesores)
INSERT INTO Persona (tipo, nombre, apellido, dni, fecha_nacimiento, correo) VALUES
-- Estudiantes
('Estudiante', 'María', 'García', '76543210', '2002-03-15', 'maria.garcia@utp.ac.pa'),
('Estudiante', 'Carlos', 'Martínez', '87654321', '2001-07-22', 'carlos.martinez@utp.ac.pa'),
('Estudiante', 'Lucía', 'Rodríguez', '98765432', '2003-01-30', 'lucia.rodriguez@utp.ac.pa'),
('Estudiante', 'Jorge', 'López', '65432109', '2000-11-10', 'jorge.lopez@utp.ac.pa'),
('Estudiante', 'Ana', 'Sánchez', '54321098', '2002-05-18', 'ana.sanchez@utp.ac.pa'),
-- Profesores
('Profesor', 'Roberto', 'Vargas', '11223344', '1980-09-12', 'roberto.vargas@utp.ac.pa'),
('Profesor', 'Elena', 'Morales', '22334455', '1975-04-25', 'elena.morales@utp.ac.pa'),
('Profesor', 'Miguel', 'Díaz', '33445566', '1982-12-05', 'miguel.diaz@utp.ac.pa');

-- 2. Estudiantes
INSERT INTO Estudiante (persona_id, codigo_estudiante, fecha_ingreso) VALUES
(1, 'E2024001', '2024-03-01'),
(2, 'E2024002', '2024-03-01'),
(3, 'E2024003', '2024-03-01'),
(4, 'E2024004', '2024-03-01'),
(5, 'E2024005', '2024-03-01');

-- 3. Profesores
INSERT INTO Profesor (persona_id, codigo_profesor, especialidad) VALUES
(6, 'P2024001', 'Matemáticas Avanzadas'),
(7, 'P2024002', 'Programación y Algoritmos'),
(8, 'P2024003', 'Bases de Datos');

-- 4. Asignaturas
INSERT INTO Asignatura (codigo_asignatura, nombre, creditos, descripcion) VALUES
('MAT202', 'Cálculo I', 4, 'Límites, derivadas e integrales'),
('PROG202', 'Programación II', 5, 'Estructuras de datos y POO'),
('BD202', 'Bases de Datos', 4, 'Modelado y SQL'),
('FIS202', 'Física General', 3, 'Mecánica clásica'),
('EST202', 'Estadística', 3, 'Probabilidad y distribuciones');

-- 5. Salones
INSERT INTO Salon (codigo_salon, edificio, capacidad, recursos) VALUES
('A301', 'Edificio A', 30, 'Proyector, pizarra inteligente'),
('B202', 'Edificio B', 25, 'Computadoras, aire acondicionado'),
('C101', 'Edificio C', 40, 'Pizarra acrílica, proyector'),
('D105', 'Edificio D', 20, 'Laboratorio de cómputo'),
('E201', 'Edificio E', 35, 'Mesas de trabajo en equipo');

-- 6. Periodos (2024-1 y 2024-2)
INSERT INTO Periodo (nombre, fecha_inicio, fecha_fin) VALUES
('2024-1', '2024-03-04', '2024-07-12'),
('2024-2', '2024-08-05', '2024-12-13');

-- 7. Relaciones Profesor-Asignatura (nueva tabla)
INSERT INTO ProfesorAsignatura (profesor_id, asignatura_id) VALUES
(1, 1), -- Roberto Vargas puede enseñar Cálculo I
(2, 2), -- Elena Morales puede enseñar Programación II
(2, 5), -- Elena Morales puede enseñar Estadística
(3, 3), -- Miguel Díaz puede enseñar Bases de Datos
(3, 2); -- Miguel Díaz puede enseñar Programación II

-- 8. Cursos (5 cursos en periodo 2024-1 con horarios)
INSERT INTO Curso (asignatura_id, periodo_id, salon_id, hora_inicio, hora_fin, dias_semana) VALUES
(1, 1, 1, '08:00:00', '10:00:00', 'Lunes,Miércoles'), -- Cálculo I en A301
(2, 1, 2, '10:00:00', '12:00:00', 'Martes,Jueves'),   -- Programación II en B202
(3, 1, 3, '14:00:00', '16:00:00', 'Lunes,Miércoles'), -- Bases de Datos en C101
(4, 1, 4, '16:00:00', '18:00:00', 'Martes,Jueves'),   -- Física General en D105
(5, 1, 5, '08:00:00', '11:00:00', 'Viernes');        -- Estadística en E201

-- 9. Curso_Profesor (Profesores asignados a cursos)
INSERT INTO Curso_Profesor (curso_id, profesor_id, tipo_responsable) VALUES
(1, 1, 'Titular'), -- Roberto Vargas enseña Cálculo I
(2, 2, 'Titular'), -- Elena Morales enseña Programación II
(3, 3, 'Titular'), -- Miguel Díaz enseña Bases de Datos
(1, 2, 'Auxiliar'), -- Elena Morales es auxiliar en Cálculo I
(3, 1, 'Auxiliar'); -- Roberto Vargas es auxiliar en Bases de Datos

-- 10. Inscripciones (5 estudiantes en distintos cursos)
INSERT INTO Inscripcion (estudiante_id, curso_id, fecha) VALUES
(1, 1, '2024-03-05'), -- María en Cálculo I
(2, 2, '2024-03-05'), -- Carlos en Programación II
(3, 3, '2024-03-06'), -- Lucía en Bases de Datos
(4, 4, '2024-03-06'), -- Jorge en Física General
(5, 5, '2024-03-07'); -- Ana en Estadística

-- 11. Evaluaciones (2 por curso)
INSERT INTO Evaluacion (curso_id, tipo, nombre, peso, fecha, hora_inicio, hora_fin) VALUES
-- Cálculo I
(1, 'Parcial', 'Parcial 1', 0.3, '2024-04-15', '08:00:00', '10:00:00'),
(1, 'Final', 'Examen Final', 0.4, '2024-07-01', '08:00:00', '11:00:00'),
-- Programación II
(2, 'Trabajo', 'Proyecto 1', 0.25, '2024-05-10', NULL, NULL),
(2, 'Práctica', 'Laboratorio 2', 0.35, '2024-06-20', '14:00:00', '16:00:00'),
-- Bases de Datos
(3, 'Parcial', 'Parcial 1', 0.3, '2024-04-20', '10:00:00', '12:00:00'),
(3, 'Final', 'Examen Final', 0.5, '2024-07-05', '10:00:00', '13:00:00');

-- 12. Calificaciones (1 nota por evaluación inscrita)
INSERT INTO calificacion (inscripcion_id, evaluacion_id, tipo, nota, es_definitiva) VALUES
-- María (Cálculo I)
(1, 1, 'Parcial', 15.5, TRUE),  -- Parcial 1 (definitiva)
(1, 2, 'Final', 18.0, TRUE),     -- Examen Final (definitiva)

-- Carlos (Programación II)
(2, 3, 'Trabajo', 17.0, TRUE),   -- Proyecto 1 (definitiva)
(2, 4, 'Práctica', 16.5, TRUE),  -- Laboratorio 2 (definitiva)

-- Lucía (Bases de Datos)
(3, 5, 'Parcial', 14.0, TRUE),   -- Parcial 1 (definitiva)
(3, 6, 'Final', 15.5, TRUE);     -- Examen Final (definitiva)
