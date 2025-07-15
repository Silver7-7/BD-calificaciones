-- Primero insertamos nuevas personas para las pruebas
INSERT INTO Persona (tipo, nombre, apellido, dni, fecha_nacimiento, correo) VALUES
-- Estudiante nuevo
('Estudiante', 'Pedro', 'Ramírez', '11223344', '2001-08-15', 'pedro.ramirez@utp.ac.pa'),
-- Estudiante graduado
('Estudiante', 'Laura', 'Fernández', '22334455', '2000-05-20', 'laura.fernandez@utp.ac.pa'),
-- Profesor nuevo
('Profesor', 'Ricardo', 'Silva', '33445566', '1978-11-30', 'ricardo.silva@utp.ac.pa'),
-- Persona sin tipo definido (para pruebas)
('Estudiante', 'Sofía', 'Gómez', '44556677', '2002-02-10', 'sofia.gomez@utp.ac.pa'),
-- Insertar una persona adicional sin relaciones para pruebas
('Estudiante', 'Daniel', 'Torres', '55667788', '2003-04-12', 'daniel.torres@utp.ac.pa');

-- Insertar como estudiante normal (Pedro)
INSERT INTO Estudiante (persona_id, codigo_estudiante, fecha_ingreso) 
VALUES (9, 'E2024006', '2024-03-01');

-- Insertar como estudiante graduado (Laura)
INSERT INTO Estudiante (persona_id, codigo_estudiante, fecha_ingreso, fecha_graduacion) 
VALUES (10, 'E2024007', '2023-03-01', '2024-01-15');




-- Trigger #1
-- Intentar insertar un estudiante con persona_id que es de tipo 'Profesor' (persona_id 11 - Ricardo)
INSERT INTO Estudiante (persona_id, codigo_estudiante, fecha_ingreso) 
VALUES (11, 'E2024009', '2024-03-01');

-- Trigger #2 / #3
-- Insertar como profesor a Laura (persona_id 10) que ya está graduada
INSERT INTO Profesor (persona_id, codigo_profesor, especialidad) 
VALUES (10, 'P2024004', 'Literatura');

-- Intentar insertar como profesor a Pedro (persona_id 9) que es estudiante activo
INSERT INTO Profesor (persona_id, codigo_profesor, especialidad) 
VALUES (9, 'P2024006', 'Biología');

-- Trigger #4
-- Intentar eliminar a Pedro (persona_id 9) que es estudiante activo
DELETE FROM Persona WHERE persona_id = 9;

-- Trigger #6
-- Intentar asignar profesor 3 (Miguel Díaz) al curso 4 (Física General) donde no está autorizado
INSERT INTO Curso_Profesor (curso_id, profesor_id, tipo_responsable) 
VALUES (4, 3, 'Titular');

-- Trigger #7
-- Intentar crear curso con horario conflictivo (mismo salón, mismo día, horario superpuesto)
INSERT INTO Curso (asignatura_id, periodo_id, salon_id, hora_inicio, hora_fin, dias_semana) 
VALUES (5, 1, 1, '09:00:00', '11:00:00', 'Lunes,Miércoles');