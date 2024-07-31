CREATE TABLE MENU (
    IdMenu SERIAL PRIMARY KEY,
    Nombre VARCHAR(60),
    Icono VARCHAR(60),
    Activo BOOLEAN DEFAULT TRUE,
    FechaRegistro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE SUBMENU (
    IdSubMenu SERIAL PRIMARY KEY,
    IdMenu INT REFERENCES MENU(IdMenu),
    Nombre VARCHAR(60),
    NombreFormulario VARCHAR(60),
    Accion VARCHAR(50),
    Activo BOOLEAN DEFAULT TRUE,
    FechaRegistro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE ROL (
    IdRol SERIAL PRIMARY KEY,
    Descripcion VARCHAR(60),
    Activo BOOLEAN DEFAULT TRUE,
    FechaRegistro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE PERMISOS (
    IdPermisos SERIAL PRIMARY KEY,
    IdRol INT REFERENCES ROL(IdRol),
    IdSubMenu INT REFERENCES SUBMENU(IdSubMenu),
    Activo BOOLEAN DEFAULT TRUE,
    FechaRegistro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE USUARIO (
    IdUsuario SERIAL PRIMARY KEY,
    Nombres VARCHAR(100),
    Apellidos VARCHAR(100),
    IdRol INT REFERENCES ROL(IdRol),
    LoginUsuario VARCHAR(50),
    LoginClave VARCHAR(50),
    DescripcionReferencia VARCHAR(50),
    IdReferencia INT,
    Activo BOOLEAN DEFAULT TRUE,
    FechaRegistro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE ALUMNO (
    IdAlumno SERIAL PRIMARY KEY,
    ValorCodigo INT,
    Codigo VARCHAR(50),
    Nombres VARCHAR(100),
    Apellidos VARCHAR(100),
    DocumentoIdentidad VARCHAR(100),
    FechaNacimiento DATE,
    Sexo VARCHAR(50),
    Ciudad VARCHAR(100),
    Direccion VARCHAR(100),
    Activo BOOLEAN DEFAULT TRUE,
    FechaRegistro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE DOCENTE (
    IdDocente SERIAL PRIMARY KEY,
    ValorCodigo INT,
    Codigo VARCHAR(50),
    DocumentoIdentidad VARCHAR(100),
    Nombres VARCHAR(100),
    Apellidos VARCHAR(100),
    FechaNacimiento DATE,
    Sexo VARCHAR(50),
    GradoEstudio VARCHAR(100),
    Ciudad VARCHAR(100),
    Direccion VARCHAR(100),
    Email VARCHAR(50),
    NumeroTelefono VARCHAR(50),
    Activo BOOLEAN DEFAULT TRUE,
    FechaRegistro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE APODERADO (
    IdApoderado SERIAL PRIMARY KEY,
    TipoRelacion VARCHAR(50),
    Nombres VARCHAR(100),
    Apellidos VARCHAR(100),
    DocumentoIdentidad VARCHAR(100),
    FechaNacimiento DATE,
    Sexo VARCHAR(50),
    EstadoCivil VARCHAR(50),
    Ciudad VARCHAR(100),
    Direccion VARCHAR(100),
    Activo BOOLEAN DEFAULT TRUE,
    FechaRegistro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE PERIODO (
    IdPeriodo SERIAL PRIMARY KEY,
    Descripcion VARCHAR(50),
    FechaInicio DATE,
    FechaFin DATE,
    Activo BOOLEAN DEFAULT TRUE,
    FechaRegistro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE GRADO_SECCION (
    IdGradoSeccion SERIAL PRIMARY KEY,
    DescripcionGrado VARCHAR(100),
    DescripcionSeccion VARCHAR(100),
    Activo BOOLEAN DEFAULT TRUE,
    FechaRegistro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE CURSO (
    IdCurso SERIAL PRIMARY KEY,
    Descripcion VARCHAR(100),
    Activo BOOLEAN DEFAULT TRUE,
    FechaRegistro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE NIVEL (
    IdNivel SERIAL PRIMARY KEY,
    IdPeriodo INT REFERENCES PERIODO(IdPeriodo),
    DescripcionNivel VARCHAR(100),
    DescripcionTurno VARCHAR(100),
    HoraInicio TIME,
    HoraFin TIME,
    Activo BOOLEAN DEFAULT TRUE,
    FechaRegistro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE NIVEL_DETALLE (
    IdNivelDetalle SERIAL PRIMARY KEY,
    IdNivel INT REFERENCES NIVEL(IdNivel),
    IdGradoSeccion INT REFERENCES GRADO_SECCION(IdGradoSeccion),
    TotalVacantes INT,
    VacantesDisponibles INT,
    VacantesOcupadas INT,
    Activo BOOLEAN DEFAULT TRUE,
    FechaRegistro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE NIVEL_DETALLE_CURSO (
    IdNivelDetalleCurso SERIAL PRIMARY KEY,
    IdNivelDetalle INT REFERENCES NIVEL_DETALLE(IdNivelDetalle),
    IdCurso INT REFERENCES CURSO(IdCurso),
    Activo BOOLEAN DEFAULT TRUE,
    FechaRegistro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE HORARIO (
    IdHorario SERIAL PRIMARY KEY,
    IdNivelDetalleCurso INT REFERENCES NIVEL_DETALLE_CURSO(IdNivelDetalleCurso),
    DiaSemana VARCHAR(50),
    HoraInicio TIME,
    HoraFin TIME,
    Activo BOOLEAN DEFAULT TRUE,
    FechaRegistro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE DOCENTE_NIVELDETALLE_CURSO (
    IdDocenteNivelDetalleCurso SERIAL PRIMARY KEY,
    IdNivelDetalleCurso INT REFERENCES NIVEL_DETALLE_CURSO(IdNivelDetalleCurso),
    IdDocente INT REFERENCES DOCENTE(IdDocente),
    Activo BOOLEAN DEFAULT TRUE,
    FechaRegistro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE CURRICULA (
    IdCurricula SERIAL PRIMARY KEY,
    IdDocenteNivelDetalleCurso INT REFERENCES DOCENTE_NIVELDETALLE_CURSO(IdDocenteNivelDetalleCurso),
    Descripcion VARCHAR(100),
    Activo BOOLEAN DEFAULT TRUE,
    FechaRegistro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE CALIFICACION (
    IdCalificacion SERIAL PRIMARY KEY,
    IdCurricula INT REFERENCES CURRICULA(IdCurricula),
    IdAlumno INT REFERENCES ALUMNO(IdAlumno),
    Nota FLOAT,
    Activo BOOLEAN DEFAULT TRUE,
    FechaRegistro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE MATRICULA (
    IdMatricula SERIAL PRIMARY KEY,
    ValorCodigo INT,
    Codigo VARCHAR(50),
    Situacion VARCHAR(50),
    IdAlumno INT REFERENCES ALUMNO(IdAlumno),
    IdNivelDetalle INT REFERENCES NIVEL_DETALLE(IdNivelDetalle),
    IdApoderado INT REFERENCES APODERADO(IdApoderado),
    InstitucionProcedencia VARCHAR(50),
    EsRepitente BOOLEAN,
    Activo BOOLEAN DEFAULT TRUE,
    FechaRegistro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- obtener nombre de los usuarios autogenerados- metadata
select * FROM obtener_nombres_usuarios()

CREATE OR REPLACE FUNCTION obtener_nombres_usuarios()
RETURNS SETOF TEXT AS $$
DECLARE 
    nombre_usuario RECORD;
BEGIN
    FOR nombre_usuario IN SELECT usename FROM pg_user LOOP
        RETURN NEXT nombre_usuario.usename;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- OBTENER TABLAS CREADAS Y AUTOGENERADAS - METADATA
SELECT obtener_tablas();
CREATE OR REPLACE FUNCTION obtener_tablas()
RETURNS TABLE(tabla_nombre text, tabla_tipo text)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Consulta las tablas de usuario
    FOR tabla_nombre, tabla_tipo IN SELECT tablename, 'usuario' FROM pg_catalog.pg_tables WHERE schemaname = 'public' ORDER BY tablename
    LOOP
        RETURN NEXT;
    END LOOP;
    
    -- Consulta las tablas de la metadata
    FOR tabla_nombre, tabla_tipo IN SELECT tablename, 'metadata' FROM pg_catalog.pg_tables WHERE schemaname = 'pg_catalog' ORDER BY tablename
    LOOP
        RETURN NEXT;
    END LOOP;
END;
$$;


-- Consultar los roles creados y los autogenerados - METADATA
SELECT buscar_roles()
CREATE OR REPLACE FUNCTION buscar_roles()
RETURNS SETOF TEXT AS $$
DECLARE
    nombre_rol TEXT;
BEGIN
    -- Busca los roles creados por el usuario
    FOR nombre_rol IN SELECT rolname FROM pg_catalog.pg_roles WHERE rolcanlogin = true LOOP
        RETURN NEXT 'Rol creado por el usuario: ' || nombre_rol;
    END LOOP;
    
    -- Busca los roles de la metadata, incluyendo los que comienzan con 'pg_'
    FOR nombre_rol IN SELECT rolname FROM pg_catalog.pg_roles WHERE rolsuper = true OR rolcreaterole = true OR rolname LIKE 'pg\_%' ESCAPE '\' LOOP
        RETURN NEXT 'Rol de metadata: ' || nombre_rol;
    END LOOP;
END;
$$ LANGUAGE plpgsql;


-- crear usuario
call crear_usuario('rodolfo', '123');
CREATE OR REPLACE PROCEDURE crear_usuario(
    IN nombre_usuario TEXT,
    IN contraseña TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Crea el usuario sin privilegios específicos
    EXECUTE 'CREATE USER ' || quote_ident(nombre_usuario) || ' WITH PASSWORD ' || quote_literal(contraseña);
    
    RAISE NOTICE 'Usuario creado exitosamente';
END;
$$;

-- crear un rol
CREATE OR REPLACE PROCEDURE crear_rol(
    IN nombre_rol TEXT,
    IN contraseña TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Crea el rol sin privilegios específicos
    EXECUTE 'CREATE ROLE ' || quote_ident(nombre_rol) || ' LOGIN PASSWORD ' || quote_literal(contraseña);
    
    RAISE NOTICE 'Rol creado exitosamente';
END;
$$;






-- asignar rol a usuario
CALL asignar_rol_a_usuario('jostin', 'nuevo_rol');
CREATE OR REPLACE PROCEDURE asignar_rol_a_usuario(
    IN nombre_usuario TEXT,
    IN nombre_rol TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Verifica si el usuario existe
    IF EXISTS (SELECT 1 FROM pg_catalog.pg_user WHERE usename = nombre_usuario) THEN
        -- Verifica si el rol existe
        IF EXISTS (SELECT 1 FROM pg_catalog.pg_roles WHERE rolname = nombre_rol) THEN
            -- Asigna el rol al usuario
            EXECUTE 'GRANT ' || quote_ident(nombre_rol) || ' TO ' || quote_ident(nombre_usuario);
            RAISE NOTICE 'Rol asignado exitosamente';
        ELSE
            RAISE EXCEPTION 'El rol especificado no existe';
        END IF;
    ELSE
        RAISE EXCEPTION 'El usuario especificado no existe';
    END IF;
END;
$$;








-- modificar un usuario
CALL modificar_usuario('walter', 'yaadsa', 'jostinsitasa');
 SELECT 1 FROM pg_catalog.pg_user WHERE usename = 'rodolfo'
SELECT * FROM pg_catalog.pg_user WHERE usename = 'jostin';

CREATE OR REPLACE PROCEDURE modificar_usuario(
    IN nombre_usuario_actual TEXT,
    IN nuevo_nombre_usuario TEXT,
    IN nueva_contraseña TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
	RAISE NOTICE 'nombre_usuario_actual: %', nombre_usuario_actual;
    RAISE NOTICE 'nuevo_nombre_usuario: %', nuevo_nombre_usuario;
    RAISE NOTICE 'nueva_contraseña: %', nueva_contraseña;
    -- Verifica si el usuario existe
    IF EXISTS (SELECT 1 FROM pg_catalog.pg_user WHERE usename = nombre_usuario_actual) THEN
        -- Modifica el nombre de usuario si se proporciona un nuevo nombre
        IF nuevo_nombre_usuario IS NOT NULL THEN
            EXECUTE 'ALTER USER ' || quote_ident(nombre_usuario_actual) || ' RENAME TO ' || quote_ident(nuevo_nombre_usuario);
        END IF;
        
        -- Modifica la contraseña si se proporciona una nueva contraseña
        IF nueva_contraseña IS NOT NULL THEN
            EXECUTE 'ALTER USER ' || quote_ident(nuevo_nombre_usuario) || ' WITH PASSWORD ' || quote_literal(nueva_contraseña);
        END IF;
        
        RAISE NOTICE 'Usuario modificado exitosamente';
    ELSE
        RAISE EXCEPTION 'El usuario especificado no existe';
    END IF;
END;
$$;


-- eliminar un usuario
CALL eliminar_usuario('yaa');
CREATE OR REPLACE PROCEDURE eliminar_usuario(
    IN nombre_usuario TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Verifica si el usuario existe
    IF EXISTS (SELECT 1 FROM pg_catalog.pg_user WHERE usename = nombre_usuario) THEN
        -- Elimina el usuario
        EXECUTE 'DROP USER ' || quote_ident(nombre_usuario);
        
        RAISE NOTICE 'Usuario eliminado exitosamente';
    ELSE
        RAISE EXCEPTION 'El usuario especificado no existe';
    END IF;
END;
$$;

-- Function para listar los atributos por entidads
CREATE OR REPLACE FUNCTION listar_atributos_por_entidad_fun(nombre_entidad TEXT)
RETURNS TABLE(entidad TEXT, atributo TEXT) AS
$$
BEGIN
    RETURN QUERY
    SELECT nombre_entidad::TEXT AS entidad, column_name::TEXT AS atributo
    FROM information_schema.columns
    WHERE table_name = nombre_entidad
        AND table_schema = 'public';
END;
$$
LANGUAGE plpgsql;

-- Agregar entidad con atributos...
CREATE OR REPLACE PROCEDURE agregar_entidad_con_atributos(
    IN nombre_entidad TEXT,
    IN atributos TEXT[]
)
LANGUAGE plpgsql
AS $$
DECLARE
    atributo TEXT;
BEGIN
    -- Crea la tabla para la nueva entidad
    EXECUTE 'CREATE TABLE ' || quote_ident(nombre_entidad) || ' (id SERIAL PRIMARY KEY)';
    
    -- Agrega cada atributo a la tabla
    FOREACH atributo IN ARRAY atributos LOOP
        EXECUTE 'ALTER TABLE ' || quote_ident(nombre_entidad) || ' ADD COLUMN ' || quote_ident(atributo) || ' TEXT';
    END LOOP;
    
    RAISE NOTICE 'Entidad % creada exitosamente con atributos %', nombre_entidad, atributos;
END;
$$;




-- Listar los atributos por entidades
call listar_atributos_por_entidad('alumno')
CREATE OR REPLACE PROCEDURE listar_atributos_por_entidad(
    IN nombre_entidad TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    atributo_record RECORD;
    mensaje TEXT := 'Atributos de la entidad ' || nombre_entidad || ':'; -- Inicializar el mensaje
BEGIN
    -- Verifica si la entidad existe
    IF EXISTS (
        SELECT 1
        FROM information_schema.tables
        WHERE table_name = nombre_entidad
            AND table_schema = 'public'
    ) THEN
        -- Recupera los atributos de la entidad
        FOR atributo_record IN
            SELECT column_name
            FROM information_schema.columns
            WHERE table_name = nombre_entidad
                AND table_schema = 'public'
        LOOP
            -- Concatena los nombres de los atributos al mensaje
            mensaje := mensaje || E'\n    ' || atributo_record.column_name;
        END LOOP;
    ELSE
        mensaje := 'La entidad especificada no existe'; -- Actualizar el mensaje si la entidad no existe
    END IF;
    
    -- Devuelve el mensaje como resultado de la consulta
    RAISE NOTICE '%', mensaje;
END;
$$;

-- obtener datos de la tabla especificada
CREATE OR REPLACE FUNCTION obtener_datos(tabla text)
RETURNS SETOF record AS $$
DECLARE
    query text;
BEGIN
    query := 'SELECT * FROM ' || tabla;
    RETURN QUERY EXECUTE query;
END; $$
LANGUAGE plpgsql;


INSERT INTO cancha (dimensiones, color, descripcionterreno)
VALUES ('10x20', 'verde', 'césped artificial');




-- update cualquier tabla
CREATE OR REPLACE PROCEDURE actualizar_entidad(
    nombre_entidad TEXT,
    nombre_columna TEXT,
    nuevo_valor TEXT,
    condicion TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Verifica si la entidad (tabla) existe
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.tables
        WHERE table_name = nombre_entidad
        AND table_schema = 'public'
    ) THEN
        RAISE EXCEPTION 'La entidad "%" no existe.', nombre_entidad;
    END IF;

    -- Actualiza los datos según la condición dada
    EXECUTE format('UPDATE %I SET %I = %L WHERE %s', nombre_entidad, nombre_columna, nuevo_valor, condicion);
    RAISE NOTICE 'Los datos en la entidad "%" han sido actualizados.', nombre_entidad;
END;
$$;



-- eliminar cualquier entidad
CREATE OR REPLACE PROCEDURE eliminar_entidad(nombre_entidad TEXT)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Verifica si la entidad (tabla) existe
    IF EXISTS (
        SELECT 1
        FROM information_schema.tables
        WHERE table_name = nombre_entidad
        AND table_schema = 'public'
    ) THEN
        -- Elimina la entidad (tabla)
        EXECUTE format('DROP TABLE %I', nombre_entidad);
        RAISE NOTICE 'La entidad "%" ha sido eliminada correctamente.', nombre_entidad;
    ELSE
        RAISE EXCEPTION 'La entidad "%" no existe.', nombre_entidad;
    END IF;
END;
$$;



select * from cancha

