USE calificaciones_utp;

-- CONSULTAS BÁSICAS (SELECT simples, filtros básicos y consultas de una sola tabla)

-- 1. Listar todos los estudiantes con sus nombres y códigos de estudiante
-- Propósito: Obtener información básica de todos los estudiantes registrados
SELECT p.nombre, p.apellido, e.codigo_estudiante
FROM Persona p
JOIN Estudiante e ON p.persona_id = e.persona_id
WHERE p.tipo LIKE '%Estudiante%';

-- 2. Listar todos los profesores con sus especialidades
-- Propósito: Mostrar todos los profesores y sus áreas de especialización
SELECT p.nombre, p.apellido, pr.codigo_profesor, pr.especialidad
FROM Persona p
JOIN Profesor pr ON p.persona_id = pr.persona_id
WHERE p.tipo LIKE '%Profesor%';

-- 3. Mostrar todos los cursos disponibles en el periodo 2024-1
-- Propósito: Listar cursos ofrecidos en un periodo académico específico
SELECT a.nombre AS asignatura, c.dias_semana, c.hora_inicio, c.hora_fin
FROM Curso c
JOIN Asignatura a ON c.asignatura_id = a.asignatura_id
JOIN Periodo p ON c.periodo_id = p.periodo_id
WHERE p.nombre = '2024-1';

-- 4. Listar todas las aulas con su capacidad y recursos
-- Propósito: Proporcionar una visión general de las aulas disponibles y sus instalaciones
SELECT codigo_salon, edificio, capacidad, recursos
FROM Salon;

-- 5. Mostrar todas las asignaturas con sus créditos
-- Propósito: Mostrar todas las materias académicas y sus valores de crédito
SELECT codigo_asignatura, nombre, creditos
FROM Asignatura;

-- 6. Listar estudiantes inscritos en un curso específico (ej. Cálculo I, curso_id = 1)
-- Propósito: Identificar estudiantes matriculados en un curso particular
SELECT p.nombre, p.apellido, e.codigo_estudiante
FROM Inscripcion i
JOIN Estudiante e ON i.estudiante_id = e.estudiante_id
JOIN Persona p ON e.persona_id = p.persona_id
WHERE i.curso_id = 1;

-- 7. Listar todas las evaluaciones para un curso específico (ej. Bases de Datos, curso_id = 3)
-- Propósito: Mostrar todas las evaluaciones programadas para un curso específico
SELECT tipo, nombre, peso, fecha
FROM Evaluacion
WHERE curso_id = 3;

-- 8. Mostrar todas las calificaciones de un estudiante específico (ej. María García, estudiante_id = 1)
-- Propósito: Obtener todas las calificaciones registradas para un estudiante específico
SELECT a.nombre AS asignatura, e.nombre AS evaluacion, c.nota
FROM Calificacion c
JOIN Inscripcion i ON c.inscripcion_id = i.inscripcion_id
JOIN Evaluacion e ON c.evaluacion_id = e.evaluacion_id
JOIN Curso cu ON i.curso_id = cu.curso_id
JOIN Asignatura a ON cu.asignatura_id = a.asignatura_id
WHERE i.estudiante_id = 1;

-- 9. Listar profesores que enseñan en un periodo específico (ej. 2024-1)
-- Propósito: Identificar qué profesores están asignados a cursos en un periodo dado
SELECT DISTINCT p.nombre, p.apellido, pr.codigo_profesor
FROM Curso_Profesor cp
JOIN Profesor pr ON cp.profesor_id = pr.profesor_id
JOIN Persona p ON pr.persona_id = p.persona_id
JOIN Curso c ON cp.curso_id = c.curso_id
JOIN Periodo pe ON c.periodo_id = pe.periodo_id
WHERE pe.nombre = '2024-1';

-- 10. Mostrar el horario de un aula específica (ej. A301, salon_id = 1)
-- Propósito: Mostrar el horario de cursos que se imparten en un aula específica
SELECT a.nombre AS asignatura, c.dias_semana, c.hora_inicio, c.hora_fin
FROM Curso c
JOIN Asignatura a ON c.asignatura_id = a.asignatura_id
WHERE c.salon_id = 1;

-- CONSULTAS INTERMEDIAS (Joins, agregaciones y filtros moderados)

-- 11. Contar el número de estudiantes inscritos en cada curso
-- Propósito: Proporcionar un resumen de números de inscripción por curso
SELECT a.nombre AS asignatura, COUNT(i.estudiante_id) AS total_estudiantes
FROM Inscripcion i
JOIN Curso c ON i.curso_id = c.curso_id
JOIN Asignatura a ON c.asignatura_id = a.asignatura_id
GROUP BY a.nombre;

-- 12. Listar cursos con sus profesores asignados (solo Titulares)
-- Propósito: Mostrar cursos y sus profesores principales (Titulares)
SELECT a.nombre AS asignatura, p.nombre, p.apellido
FROM Curso_Profesor cp
JOIN Curso c ON cp.curso_id = c.curso_id
JOIN Asignatura a ON c.asignatura_id = a.asignatura_id
JOIN Profesor pr ON cp.profesor_id = pr.profesor_id
JOIN Persona p ON pr.persona_id = p.persona_id
WHERE cp.tipo_responsable = 'Titular';

-- 13. Calcular el total de créditos en los que está inscrito un estudiante (ej. estudiante_id = 1)
-- Propósito: Sumar los créditos de todos los cursos que toma un estudiante específico
SELECT p.nombre, p.apellido, SUM(a.creditos) AS total_creditos
FROM Inscripcion i
JOIN Curso c ON i.curso_id = c.curso_id
JOIN Asignatura a ON c.asignatura_id = a.asignatura_id
JOIN Estudiante e ON i.estudiante_id = e.estudiante_id
JOIN Persona p ON e.persona_id = p.persona_id
WHERE i.estudiante_id = 1;

-- 14. Listar evaluaciones con pesos mayores a 0.3
-- Propósito: Identificar evaluaciones con alto peso en todos los cursos
SELECT a.nombre AS asignatura, e.nombre AS evaluacion, e.peso
FROM Evaluacion e
JOIN Curso c ON e.curso_id = c.curso_id
JOIN Asignatura a ON c.asignatura_id = a.asignatura_id
WHERE e.peso > 0.3;

-- 15. Mostrar estudiantes con calificaciones superiores a 15 en cualquier evaluación
-- Propósito: Identificar estudiantes con alto rendimiento basado en puntajes individuales
SELECT DISTINCT p.nombre, p.apellido, c.nota, e.nombre AS evaluacion
FROM Calificacion c
JOIN Inscripcion i ON c.inscripcion_id = i.inscripcion_id
JOIN Estudiante es ON i.estudiante_id = es.estudiante_id
JOIN Persona p ON es.persona_id = p.persona_id
JOIN Evaluacion e ON c.evaluacion_id = e.evaluacion_id
WHERE c.nota > 15;

-- 16. Listar cursos impartidos en un edificio específico (ej. Edificio A)
-- Propósito: Encontrar todos los cursos programados en un edificio específico
SELECT a.nombre AS asignatura, s.codigo_salon, s.edificio
FROM Curso c
JOIN Asignatura a ON c.asignatura_id = a.asignatura_id
JOIN Salon s ON c.salon_id = s.salon_id
WHERE s.edificio = 'Edificio A';

-- 17. Mostrar el número de evaluaciones por curso
-- Propósito: Contar cuántas evaluaciones están programadas para cada curso
SELECT a.nombre AS asignatura, COUNT(e.evaluacion_id) AS total_evaluaciones
FROM Evaluacion e
JOIN Curso c ON e.curso_id = c.curso_id
JOIN Asignatura a ON c.asignatura_id = a.asignatura_id
GROUP BY a.nombre;

-- 18. Listar estudiantes inscritos en más de un curso
-- Propósito: Identificar estudiantes que toman múltiples cursos
SELECT p.nombre, p.apellido, COUNT(i.curso_id) AS total_cursos
FROM Inscripcion i
JOIN Estudiante e ON i.estudiante_id = e.estudiante_id
JOIN Persona p ON e.persona_id = p.persona_id
GROUP BY p.nombre, p.apellido
HAVING COUNT(i.curso_id) > 1;

-- 19. Mostrar profesores que enseñan múltiples asignaturas
-- Propósito: Identificar profesores asignados a más de una asignatura
SELECT p.nombre, p.apellido, COUNT(pa.asignatura_id) AS total_asignaturas
FROM ProfesorAsignatura pa
JOIN Profesor pr ON pa.profesor_id = pr.profesor_id
JOIN Persona p ON pr.persona_id = p.persona_id
GROUP BY p.nombre, p.apellido
HAVING COUNT(pa.asignatura_id) > 1;

-- 20. Listar cursos con la capacidad de su aula
-- Propósito: Mostrar detalles de cursos junto con la capacidad del aula asignada
SELECT a.nombre AS asignatura, s.codigo_salon, s.capacidad
FROM Curso c
JOIN Asignatura a ON c.asignatura_id = a.asignatura_id
JOIN Salon s ON c.salon_id = s.salon_id;

-- CONSULTAS AVANZADAS (Joins complejos, subconsultas, agregaciones y funciones)

-- 21. Usar la función para calcular el promedio de un estudiante en un curso específico
-- Propósito: Utilizar CalcularPromedioEstudianteCurso para obtener el promedio de María en Cálculo I
SELECT p.nombre, p.apellido, a.nombre AS asignatura,
       CalcularPromedioEstudianteCurso(e.estudiante_id, c.curso_id) AS promedio
FROM Estudiante e
JOIN Persona p ON e.persona_id = p.persona_id
JOIN Inscripcion i ON e.estudiante_id = i.estudiante_id
JOIN Curso c ON i.curso_id = c.curso_id
JOIN Asignatura a ON c.asignatura_id = a.asignatura_id
WHERE e.estudiante_id = 1 AND c.curso_id = 1;

-- 22. Mostrar el promedio general de un estudiante usando la función
-- Propósito: Utilizar CalcularPromedioGeneralEstudiante para obtener el promedio global
SELECT p.nombre, p.apellido, CalcularPromedioGeneralEstudiante(e.estudiante_id) AS promedio_general
FROM Estudiante e
JOIN Persona p ON e.persona_id = p.persona_id
WHERE e.estudiante_id = 1;

-- 23. Listar cursos con el promedio de calificaciones de los estudiantes
-- Propósito: Mostrar el rendimiento promedio de los estudiantes por curso
SELECT a.nombre AS asignatura, 
       AVG(i.nota_final) AS promedio_curso,
       COUNT(i.estudiante_id) AS total_estudiantes
FROM Inscripcion i
JOIN Curso c ON i.curso_id = c.curso_id
JOIN Asignatura a ON c.asignatura_id = a.asignatura_id
WHERE i.nota_final IS NOT NULL
GROUP BY a.nombre;

-- 24. Mostrar estudiantes que están por debajo del promedio en un curso
-- Propósito: Identificar estudiantes con rendimiento inferior al promedio del curso
SELECT p.nombre, p.apellido, i.nota_final, 
       (SELECT AVG(nota_final) FROM Inscripcion WHERE curso_id = i.curso_id) AS promedio_curso
FROM Inscripcion i
JOIN Estudiante e ON i.estudiante_id = e.estudiante_id
JOIN Persona p ON e.persona_id = p.persona_id
WHERE i.nota_final < (SELECT AVG(nota_final) FROM Inscripcion WHERE curso_id = i.curso_id);

-- 25. Listar profesores con el promedio de calificaciones de sus cursos
-- Propósito: Mostrar el rendimiento promedio de los estudiantes por profesor
SELECT p.nombre, p.apellido, 
       AVG(i.nota_final) AS promedio_calificaciones,
       COUNT(DISTINCT c.curso_id) AS total_cursos
FROM Curso_Profesor cp
JOIN Profesor pr ON cp.profesor_id = pr.profesor_id
JOIN Persona p ON pr.persona_id = p.persona_id
JOIN Curso c ON cp.curso_id = c.curso_id
JOIN Inscripcion i ON c.curso_id = i.curso_id
WHERE cp.tipo_responsable = 'Titular' AND i.nota_final IS NOT NULL
GROUP BY p.nombre, p.apellido;
