-- 1. Validar el tipo de Persona (Estudiante o Profesor)
DELIMITER //
CREATE TRIGGER validar_tipo_persona
BEFORE INSERT ON Estudiante
FOR EACH ROW
BEGIN
    DECLARE tipo_persona ENUM('Estudiante', 'Profesor');
    
    -- Verificar el tipo en la tabla Persona
    SELECT tipo INTO tipo_persona FROM Persona WHERE persona_id = NEW.persona_id;
    
    -- Validar que corresponda
    IF tipo_persona != 'Estudiante' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La persona referenciada no está marcada como Estudiante';
    END IF;
END //

CREATE TRIGGER validar_tipo_profesor
BEFORE INSERT ON Profesor
FOR EACH ROW
BEGIN
    DECLARE tipo_persona ENUM('Estudiante', 'Profesor');
    
    -- Verificar el tipo en la tabla Persona
    SELECT tipo INTO tipo_persona FROM Persona WHERE persona_id = NEW.persona_id;
    
    -- Validar que corresponda
    IF tipo_persona != 'Profesor' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La persona referenciada no está marcada como Profesor';
    END IF;
END //
DELIMITER ;

-- 2. Evita los cambios de tipo en Persona
DELIMITER //
CREATE TRIGGER evitar_cambio_tipo_persona
BEFORE UPDATE ON Persona
FOR EACH ROW
BEGIN
    DECLARE existe_estudiante INT;
    DECLARE existe_profesor INT;
    
    -- Solo validar si se cambia el tipo
    IF NEW.tipo != OLD.tipo THEN
        -- Verificar si existe como estudiante
        SELECT COUNT(*) INTO existe_estudiante FROM Estudiante WHERE persona_id = OLD.persona_id;
        
        -- Verificar si existe como profesor
        SELECT COUNT(*) INTO existe_profesor FROM Profesor WHERE persona_id = OLD.persona_id;
        
        -- Validar coherencia
        IF (OLD.tipo = 'Estudiante' AND existe_estudiante > 0) OR 
           (OLD.tipo = 'Profesor' AND existe_profesor > 0) THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'No se puede cambiar el tipo de persona porque ya existe registro como estudiante/profesor';
        END IF;
    END IF;
END //
DELIMITER ;

-- 3. Evita la eliminación si existe referencia entre Persona y Estudiante o Profesor
DELIMITER //
CREATE TRIGGER prevenir_eliminacion_persona
BEFORE DELETE ON Persona
FOR EACH ROW
BEGIN
    DECLARE existe_estudiante INT;
    DECLARE existe_profesor INT;
    
    -- Verificar si existe como estudiante
    SELECT COUNT(*) INTO existe_estudiante FROM Estudiante WHERE persona_id = OLD.persona_id;
    
    -- Verificar si existe como profesor
    SELECT COUNT(*) INTO existe_profesor FROM Profesor WHERE persona_id = OLD.persona_id;
    
    -- Prevenir eliminación si hay registros relacionados
    IF existe_estudiante > 0 OR existe_profesor > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se puede eliminar la persona porque tiene registros como estudiante o profesor';
    END IF;
END //
DELIMITER ;

-- 4. Actualiza la nota final luego de añadir una calificacion
DELIMITER //
CREATE TRIGGER actualizar_nota_final_despues_calificacion
AFTER INSERT ON Calificacion
FOR EACH ROW
BEGIN
    DECLARE v_curso_id INT;
    
    -- Obtener el curso relacionado
    SELECT i.curso_id INTO v_curso_id
    FROM Inscripcion i
    WHERE i.inscripcion_id = NEW.inscripcion_id;
    
    -- Actualizar todas las notas finales del curso
    CALL ActualizarNotasFinalesCurso(v_curso_id);
END //
DELIMITER ;

-- 5. Validar que un profesor solo dicte asignaturas de su especialidad
DELIMITER //
CREATE TRIGGER validar_profesor_asignatura
BEFORE INSERT ON Curso_Profesor
FOR EACH ROW
BEGIN
    DECLARE es_valido INT DEFAULT 0;
    
    -- Verificar si el profesor está autorizado para esta asignatura
    SELECT COUNT(*) INTO es_valido
    FROM ProfesorAsignatura
    WHERE profesor_id = NEW.profesor_id
    AND asignatura_id = (SELECT asignatura_id FROM Curso WHERE curso_id = NEW.curso_id);
    
    IF es_valido = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El profesor no está autorizado para dictar esta asignatura';
    END IF;
END //
DELIMITER ;

-- 6. Validar horarios de salones para evitar conflictos
DELIMITER //
CREATE TRIGGER validar_horario_salon
BEFORE INSERT ON Curso
FOR EACH ROW
BEGIN
    DECLARE conflicto INT DEFAULT 0;
    
    -- Verificar conflictos en el mismo salón, mismo día y horario superpuesto
    SELECT COUNT(*) INTO conflicto
    FROM Curso
    WHERE salon_id = NEW.salon_id
    AND periodo_id = NEW.periodo_id
    AND dias_semana = NEW.dias_semana
    AND (
        (NEW.hora_inicio BETWEEN hora_inicio AND hora_fin) OR
        (NEW.hora_fin BETWEEN hora_inicio AND hora_fin) OR
        (hora_inicio BETWEEN NEW.hora_inicio AND NEW.hora_fin)
    );
    
    IF conflicto > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El salón ya está ocupado en este horario y días';
    END IF;
END //
DELIMITER ;
