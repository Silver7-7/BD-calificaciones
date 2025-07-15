-- Función #1
-- Calcular promedio de María (estudiante_id 1) en Cálculo I (curso_id 1)
SELECT CalcularPromedioEstudianteCurso(1, 1) AS promedio_maria;

-- Calcular promedio de Carlos (estudiante_id 2) en Programación II (curso_id 2)
SELECT CalcularPromedioEstudianteCurso(2, 2) AS promedio_carlos;


-- Función #2
-- Calcular promedio general de Lucía (estudiante_id 3)
SELECT CalcularPromedioGeneralEstudiante(3) AS promedio_general_lucia;


-- Función #3
-- Calcular promedio final para la inscripción de María (inscripcion_id 1)
SELECT CalcularPromedioFinalEstudianteCurso(1) AS promedio_final_maria;


-- Función #4
-- Calcular promedio del grupo en el Parcial 1 de Cálculo I (evaluacion_id 1)
SELECT CalcularPromedioGrupoEvaluacion(1) AS promedio_grupo_parcial1;


-- Función #5
-- Calcular promedio de todos los estudiantes del profesor Roberto Vargas (profesor_id 1)
SELECT CalcularPromedioPorProfesor(1) AS promedio_profesor_vargas;


-- Función #6
-- Actualizar todas las notas finales del curso de Cálculo I (curso_id 1)
CALL ActualizarNotasFinalesCurso(1);

-- Ver resultados
SELECT i.inscripcion_id, e.nombre, e.apellido, i.nota_final, i.estado 
FROM Inscripcion i
JOIN Estudiante est ON i.estudiante_id = est.estudiante_id
JOIN Persona e ON est.persona_id = e.persona_id
WHERE i.curso_id = 1;