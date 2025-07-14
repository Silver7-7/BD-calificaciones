-- Función para calcular el promedio de un estudiante en un curso específico
DELIMITER //
CREATE FUNCTION CalcularPromedioEstudianteCurso(
    p_estudiante_id INT,
    p_curso_id INT
)
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE promedio DECIMAL(5,2);
    
    SELECT AVG(c.nota * e.peso)
    INTO promedio
    FROM Calificacion c
    JOIN Inscripcion i ON c.inscripcion_id = i.inscripcion_id
    JOIN Evaluacion e ON c.evaluacion_id = e.evaluacion_id
    WHERE i.estudiante_id = p_estudiante_id
    AND i.curso_id = p_curso_id;
    
    RETURN IFNULL(promedio, 0);
END //
DELIMITER ;

-- Función para calcular el promedio general de un estudiante en todos los cursos
DELIMITER //
CREATE FUNCTION CalcularPromedioGeneralEstudiante(
    p_estudiante_id INT
)
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE promedio DECIMAL(5,2);
    
    SELECT AVG(c.nota * e.peso)
    INTO promedio
    FROM Calificacion c
    JOIN Inscripcion i ON c.inscripcion_id = i.inscripcion_id
    JOIN Evaluacion e ON c.evaluacion_id = e.evaluacion_id
    WHERE i.estudiante_id = p_estudiante_id;
    
    RETURN IFNULL(promedio, 0);
END //
DELIMITER ;

-- Calcula el promedio final del estudiante
DELIMITER //
CREATE FUNCTION CalcularPromedioFinalEstudianteCurso(
    p_inscripcion_id INT
)
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE promedio DECIMAL(5,2);
    DECLARE v_curso_id INT;
    
    -- Obtener el curso de la inscripción
    SELECT curso_id INTO v_curso_id FROM Inscripcion WHERE inscripcion_id = p_inscripcion_id;
    
    -- Calcular promedio ponderado solo de calificaciones definitivas
    SELECT SUM(c.nota * e.peso) / SUM(e.peso)
    INTO promedio
    FROM Calificacion c
    JOIN Evaluacion e ON c.evaluacion_id = e.evaluacion_id
    WHERE c.inscripcion_id = p_inscripcion_id
    AND c.es_definitiva = TRUE
    AND e.curso_id = v_curso_id;
    
    RETURN IFNULL(promedio, 0);
END //
DELIMITER ;

-- Función para calcular el promedio de un grupo para una evaluación específica
DELIMITER //
CREATE FUNCTION CalcularPromedioGrupoEvaluacion(
    p_evaluacion_id INT
)
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE promedio DECIMAL(5,2);
    
    SELECT AVG(c.nota)
    INTO promedio
    FROM Calificacion c
    WHERE c.evaluacion_id = p_evaluacion_id;
    
    RETURN IFNULL(promedio, 0);
END //
DELIMITER ;

-- Función para calcular el promedio de todos los estudiantes por profesor
DELIMITER //
CREATE FUNCTION CalcularPromedioPorProfesor(
    p_profesor_id INT
)
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE promedio DECIMAL(5,2);
    
    SELECT AVG(c.nota * e.peso)
    INTO promedio
    FROM Calificacion c
    JOIN Inscripcion i ON c.inscripcion_id = i.inscripcion_id
    JOIN Evaluacion e ON c.evaluacion_id = e.evaluacion_id
    JOIN Curso_Profesor cp ON i.curso_id = cp.curso_id
    WHERE cp.profesor_id = p_profesor_id
    AND cp.tipo_responsable = 'Titular';
    
    RETURN IFNULL(promedio, 0);
END //
DELIMITER ;

-- Actualiza las notas finales del curso
DELIMITER //
CREATE PROCEDURE ActualizarNotasFinalesCurso(
    IN p_curso_id INT
)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_inscripcion_id INT;
    DECLARE v_nota_final DECIMAL(5,2);
    DECLARE cur CURSOR FOR 
        SELECT inscripcion_id FROM Inscripcion WHERE curso_id = p_curso_id;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN cur;
    
    read_loop: LOOP
        FETCH cur INTO v_inscripcion_id;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- Calcular nota final para cada inscripción
        SET v_nota_final = CalcularPromedioFinalEstudianteCurso(v_inscripcion_id);
        
        -- Actualizar registro de inscripción
        UPDATE Inscripcion
        SET nota_final = v_nota_final,
            estado = CASE 
                WHEN v_nota_final >= 13 THEN 'Aprobado'
                ELSE 'Desaprobado'
            END
        WHERE inscripcion_id = v_inscripcion_id;
    END LOOP;
    
    CLOSE cur;
END //
DELIMITER ;