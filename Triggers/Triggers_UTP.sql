-- 1. Validar el tipo de Persona al insertar Estudiante
DELIMITER //
CREATE TRIGGER validar_tipo_persona_estudiante
BEFORE INSERT ON Estudiante
FOR EACH ROW
BEGIN
    DECLARE tipo_persona VARCHAR(20);
    
    SELECT tipo INTO tipo_persona FROM Persona WHERE persona_id = NEW.persona_id;
    
    IF tipo_persona = 'Profesor' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Un profesor no puede ser registrado como estudiante';
    END IF;
END //
DELIMITER ;

-- 2. Validar estudiante no graduado al insertar Profesor
DELIMITER //
CREATE TRIGGER validar_estudiante_para_profesor
BEFORE INSERT ON Profesor
FOR EACH ROW
BEGIN
    DECLARE es_estudiante_activo INT;
    
    SELECT COUNT(*) INTO es_estudiante_activo
    FROM Estudiante 
    WHERE persona_id = NEW.persona_id 
    AND fecha_graduacion IS NULL;
    
    IF es_estudiante_activo > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La persona es estudiante activo. Debe graduarse primero.';
    END IF;
END //
DELIMITER ;

-- 3. Actualizar tipo de Persona al insertar Profesor
DELIMITER //
CREATE TRIGGER actualizar_tipo_persona_profesor
AFTER INSERT ON Profesor
FOR EACH ROW
BEGIN
    UPDATE Persona 
    SET tipo = CASE 
        WHEN tipo = 'Estudiante' THEN 'Estudiante,Profesor'
        ELSE 'Profesor'
    END
    WHERE persona_id = NEW.persona_id;
END //
DELIMITER ;

-- 4. Evitar eliminación de Persona con referencias
DELIMITER //
CREATE TRIGGER prevenir_eliminacion_persona
BEFORE DELETE ON Persona
FOR EACH ROW
BEGIN
    DECLARE existe_estudiante INT;
    DECLARE existe_profesor INT;
    
    SELECT COUNT(*) INTO existe_estudiante FROM Estudiante WHERE persona_id = OLD.persona_id;
    SELECT COUNT(*) INTO existe_profesor FROM Profesor WHERE persona_id = OLD.persona_id;
    
    IF existe_estudiante > 0 OR existe_profesor > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se puede eliminar la persona porque tiene registros como estudiante o profesor';
    END IF;
END //
DELIMITER ;

-- 5. Actualiza la nota final luego de añadir una calificacion
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

-- 6. Validar que un profesor solo dicte asignaturas de su especialidad
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

-- 7. Validar horarios de salones para evitar conflictos
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
