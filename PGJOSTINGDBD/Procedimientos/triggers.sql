
        CREATE TABLE IF NOT EXISTS auditoria (
            id_auditoria SERIAL PRIMARY KEY,
            accion VARCHAR(10) NOT NULL,
            tabla_afectada VARCHAR(50) NOT NULL,
            usuario VARCHAR(50) NOT NULL,
            fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            antes TEXT,
            despues TEXT
        );
    
            CREATE OR REPLACE FUNCTION audit_MENU_before_delete() RETURNS TRIGGER AS $$
            BEGIN
                INSERT INTO auditoria (accion, tabla_afectada, usuario, antes)
                VALUES ('DELETE', TG_TABLE_NAME, current_user, row_to_json(OLD)::text);
                RETURN OLD;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER trg_audit_MENU_before_delete
            BEFORE DELETE ON MENU
            FOR EACH ROW EXECUTE FUNCTION audit_MENU_before_delete();

            CREATE OR REPLACE FUNCTION audit_MENU_before_insert() RETURNS TRIGGER AS $$
            BEGIN
                INSERT INTO auditoria (accion, tabla_afectada, usuario, despues)
                VALUES ('INSERT', TG_TABLE_NAME, current_user, row_to_json(NEW)::text);
                RETURN NEW;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER trg_audit_MENU_before_insert
            BEFORE INSERT ON MENU
            FOR EACH ROW EXECUTE FUNCTION audit_MENU_before_insert();

            CREATE OR REPLACE FUNCTION audit_MENU_before_update() RETURNS TRIGGER AS $$
            BEGIN
                INSERT INTO auditoria (accion, tabla_afectada, usuario, antes, despues)
                VALUES ('UPDATE', TG_TABLE_NAME, current_user, row_to_json(OLD)::text, row_to_json(NEW)::text);
                RETURN NEW;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER trg_audit_MENU_before_update
            BEFORE UPDATE ON MENU
            FOR EACH ROW EXECUTE FUNCTION audit_MENU_before_update();
        
            CREATE OR REPLACE FUNCTION audit_SUBMENU_before_delete() RETURNS TRIGGER AS $$
            BEGIN
                INSERT INTO auditoria (accion, tabla_afectada, usuario, antes)
                VALUES ('DELETE', TG_TABLE_NAME, current_user, row_to_json(OLD)::text);
                RETURN OLD;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER trg_audit_SUBMENU_before_delete
            BEFORE DELETE ON SUBMENU
            FOR EACH ROW EXECUTE FUNCTION audit_SUBMENU_before_delete();

            CREATE OR REPLACE FUNCTION audit_SUBMENU_before_insert() RETURNS TRIGGER AS $$
            BEGIN
                INSERT INTO auditoria (accion, tabla_afectada, usuario, despues)
                VALUES ('INSERT', TG_TABLE_NAME, current_user, row_to_json(NEW)::text);
                RETURN NEW;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER trg_audit_SUBMENU_before_insert
            BEFORE INSERT ON SUBMENU
            FOR EACH ROW EXECUTE FUNCTION audit_SUBMENU_before_insert();

            CREATE OR REPLACE FUNCTION audit_SUBMENU_before_update() RETURNS TRIGGER AS $$
            BEGIN
                INSERT INTO auditoria (accion, tabla_afectada, usuario, antes, despues)
                VALUES ('UPDATE', TG_TABLE_NAME, current_user, row_to_json(OLD)::text, row_to_json(NEW)::text);
                RETURN NEW;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER trg_audit_SUBMENU_before_update
            BEFORE UPDATE ON SUBMENU
            FOR EACH ROW EXECUTE FUNCTION audit_SUBMENU_before_update();
        
            CREATE OR REPLACE FUNCTION audit_ROL_before_delete() RETURNS TRIGGER AS $$
            BEGIN
                INSERT INTO auditoria (accion, tabla_afectada, usuario, antes)
                VALUES ('DELETE', TG_TABLE_NAME, current_user, row_to_json(OLD)::text);
                RETURN OLD;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER trg_audit_ROL_before_delete
            BEFORE DELETE ON ROL
            FOR EACH ROW EXECUTE FUNCTION audit_ROL_before_delete();

            CREATE OR REPLACE FUNCTION audit_ROL_before_insert() RETURNS TRIGGER AS $$
            BEGIN
                INSERT INTO auditoria (accion, tabla_afectada, usuario, despues)
                VALUES ('INSERT', TG_TABLE_NAME, current_user, row_to_json(NEW)::text);
                RETURN NEW;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER trg_audit_ROL_before_insert
            BEFORE INSERT ON ROL
            FOR EACH ROW EXECUTE FUNCTION audit_ROL_before_insert();

            CREATE OR REPLACE FUNCTION audit_ROL_before_update() RETURNS TRIGGER AS $$
            BEGIN
                INSERT INTO auditoria (accion, tabla_afectada, usuario, antes, despues)
                VALUES ('UPDATE', TG_TABLE_NAME, current_user, row_to_json(OLD)::text, row_to_json(NEW)::text);
                RETURN NEW;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER trg_audit_ROL_before_update
            BEFORE UPDATE ON ROL
            FOR EACH ROW EXECUTE FUNCTION audit_ROL_before_update();
        
            CREATE OR REPLACE FUNCTION audit_PERMISOS_before_delete() RETURNS TRIGGER AS $$
            BEGIN
                INSERT INTO auditoria (accion, tabla_afectada, usuario, antes)
                VALUES ('DELETE', TG_TABLE_NAME, current_user, row_to_json(OLD)::text);
                RETURN OLD;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER trg_audit_PERMISOS_before_delete
            BEFORE DELETE ON PERMISOS
            FOR EACH ROW EXECUTE FUNCTION audit_PERMISOS_before_delete();

            CREATE OR REPLACE FUNCTION audit_PERMISOS_before_insert() RETURNS TRIGGER AS $$
            BEGIN
                INSERT INTO auditoria (accion, tabla_afectada, usuario, despues)
                VALUES ('INSERT', TG_TABLE_NAME, current_user, row_to_json(NEW)::text);
                RETURN NEW;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER trg_audit_PERMISOS_before_insert
            BEFORE INSERT ON PERMISOS
            FOR EACH ROW EXECUTE FUNCTION audit_PERMISOS_before_insert();

            CREATE OR REPLACE FUNCTION audit_PERMISOS_before_update() RETURNS TRIGGER AS $$
            BEGIN
                INSERT INTO auditoria (accion, tabla_afectada, usuario, antes, despues)
                VALUES ('UPDATE', TG_TABLE_NAME, current_user, row_to_json(OLD)::text, row_to_json(NEW)::text);
                RETURN NEW;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER trg_audit_PERMISOS_before_update
            BEFORE UPDATE ON PERMISOS
            FOR EACH ROW EXECUTE FUNCTION audit_PERMISOS_before_update();
        
            CREATE OR REPLACE FUNCTION audit_USUARIO_before_delete() RETURNS TRIGGER AS $$
            BEGIN
                INSERT INTO auditoria (accion, tabla_afectada, usuario, antes)
                VALUES ('DELETE', TG_TABLE_NAME, current_user, row_to_json(OLD)::text);
                RETURN OLD;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER trg_audit_USUARIO_before_delete
            BEFORE DELETE ON USUARIO
            FOR EACH ROW EXECUTE FUNCTION audit_USUARIO_before_delete();

            CREATE OR REPLACE FUNCTION audit_USUARIO_before_insert() RETURNS TRIGGER AS $$
            BEGIN
                INSERT INTO auditoria (accion, tabla_afectada, usuario, despues)
                VALUES ('INSERT', TG_TABLE_NAME, current_user, row_to_json(NEW)::text);
                RETURN NEW;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER trg_audit_USUARIO_before_insert
            BEFORE INSERT ON USUARIO
            FOR EACH ROW EXECUTE FUNCTION audit_USUARIO_before_insert();

            CREATE OR REPLACE FUNCTION audit_USUARIO_before_update() RETURNS TRIGGER AS $$
            BEGIN
                INSERT INTO auditoria (accion, tabla_afectada, usuario, antes, despues)
                VALUES ('UPDATE', TG_TABLE_NAME, current_user, row_to_json(OLD)::text, row_to_json(NEW)::text);
                RETURN NEW;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER trg_audit_USUARIO_before_update
            BEFORE UPDATE ON USUARIO
            FOR EACH ROW EXECUTE FUNCTION audit_USUARIO_before_update();
        
            CREATE OR REPLACE FUNCTION audit_ALUMNO_before_delete() RETURNS TRIGGER AS $$
            BEGIN
                INSERT INTO auditoria (accion, tabla_afectada, usuario, antes)
                VALUES ('DELETE', TG_TABLE_NAME, current_user, row_to_json(OLD)::text);
                RETURN OLD;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER trg_audit_ALUMNO_before_delete
            BEFORE DELETE ON ALUMNO
            FOR EACH ROW EXECUTE FUNCTION audit_ALUMNO_before_delete();

            CREATE OR REPLACE FUNCTION audit_ALUMNO_before_insert() RETURNS TRIGGER AS $$
            BEGIN
                INSERT INTO auditoria (accion, tabla_afectada, usuario, despues)
                VALUES ('INSERT', TG_TABLE_NAME, current_user, row_to_json(NEW)::text);
                RETURN NEW;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER trg_audit_ALUMNO_before_insert
            BEFORE INSERT ON ALUMNO
            FOR EACH ROW EXECUTE FUNCTION audit_ALUMNO_before_insert();

            CREATE OR REPLACE FUNCTION audit_ALUMNO_before_update() RETURNS TRIGGER AS $$
            BEGIN
                INSERT INTO auditoria (accion, tabla_afectada, usuario, antes, despues)
                VALUES ('UPDATE', TG_TABLE_NAME, current_user, row_to_json(OLD)::text, row_to_json(NEW)::text);
                RETURN NEW;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER trg_audit_ALUMNO_before_update
            BEFORE UPDATE ON ALUMNO
            FOR EACH ROW EXECUTE FUNCTION audit_ALUMNO_before_update();
        
            CREATE OR REPLACE FUNCTION audit_DOCENTE_before_delete() RETURNS TRIGGER AS $$
            BEGIN
                INSERT INTO auditoria (accion, tabla_afectada, usuario, antes)
                VALUES ('DELETE', TG_TABLE_NAME, current_user, row_to_json(OLD)::text);
                RETURN OLD;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER trg_audit_DOCENTE_before_delete
            BEFORE DELETE ON DOCENTE
            FOR EACH ROW EXECUTE FUNCTION audit_DOCENTE_before_delete();

            CREATE OR REPLACE FUNCTION audit_DOCENTE_before_insert() RETURNS TRIGGER AS $$
            BEGIN
                INSERT INTO auditoria (accion, tabla_afectada, usuario, despues)
                VALUES ('INSERT', TG_TABLE_NAME, current_user, row_to_json(NEW)::text);
                RETURN NEW;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER trg_audit_DOCENTE_before_insert
            BEFORE INSERT ON DOCENTE
            FOR EACH ROW EXECUTE FUNCTION audit_DOCENTE_before_insert();

            CREATE OR REPLACE FUNCTION audit_DOCENTE_before_update() RETURNS TRIGGER AS $$
            BEGIN
                INSERT INTO auditoria (accion, tabla_afectada, usuario, antes, despues)
                VALUES ('UPDATE', TG_TABLE_NAME, current_user, row_to_json(OLD)::text, row_to_json(NEW)::text);
                RETURN NEW;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER trg_audit_DOCENTE_before_update
            BEFORE UPDATE ON DOCENTE
            FOR EACH ROW EXECUTE FUNCTION audit_DOCENTE_before_update();
        
            CREATE OR REPLACE FUNCTION audit_APODERADO_before_delete() RETURNS TRIGGER AS $$
            BEGIN
                INSERT INTO auditoria (accion, tabla_afectada, usuario, antes)
                VALUES ('DELETE', TG_TABLE_NAME, current_user, row_to_json(OLD)::text);
                RETURN OLD;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER trg_audit_APODERADO_before_delete
            BEFORE DELETE ON APODERADO
            FOR EACH ROW EXECUTE FUNCTION audit_APODERADO_before_delete();

            CREATE OR REPLACE FUNCTION audit_APODERADO_before_insert() RETURNS TRIGGER AS $$
            BEGIN
                INSERT INTO auditoria (accion, tabla_afectada, usuario, despues)
                VALUES ('INSERT', TG_TABLE_NAME, current_user, row_to_json(NEW)::text);
                RETURN NEW;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER trg_audit_APODERADO_before_insert
            BEFORE INSERT ON APODERADO
            FOR EACH ROW EXECUTE FUNCTION audit_APODERADO_before_insert();

            CREATE OR REPLACE FUNCTION audit_APODERADO_before_update() RETURNS TRIGGER AS $$
            BEGIN
                INSERT INTO auditoria (accion, tabla_afectada, usuario, antes, despues)
                VALUES ('UPDATE', TG_TABLE_NAME, current_user, row_to_json(OLD)::text, row_to_json(NEW)::text);
                RETURN NEW;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER trg_audit_APODERADO_before_update
            BEFORE UPDATE ON APODERADO
            FOR EACH ROW EXECUTE FUNCTION audit_APODERADO_before_update();
        
            CREATE OR REPLACE FUNCTION audit_PERIODO_before_delete() RETURNS TRIGGER AS $$
            BEGIN
                INSERT INTO auditoria (accion, tabla_afectada, usuario, antes)
                VALUES ('DELETE', TG_TABLE_NAME, current_user, row_to_json(OLD)::text);
                RETURN OLD;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER trg_audit_PERIODO_before_delete
            BEFORE DELETE ON PERIODO
            FOR EACH ROW EXECUTE FUNCTION audit_PERIODO_before_delete();

            CREATE OR REPLACE FUNCTION audit_PERIODO_before_insert() RETURNS TRIGGER AS $$
            BEGIN
                INSERT INTO auditoria (accion, tabla_afectada, usuario, despues)
                VALUES ('INSERT', TG_TABLE_NAME, current_user, row_to_json(NEW)::text);
                RETURN NEW;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER trg_audit_PERIODO_before_insert
            BEFORE INSERT ON PERIODO
            FOR EACH ROW EXECUTE FUNCTION audit_PERIODO_before_insert();

            CREATE OR REPLACE FUNCTION audit_PERIODO_before_update() RETURNS TRIGGER AS $$
            BEGIN
                INSERT INTO auditoria (accion, tabla_afectada, usuario, antes, despues)
                VALUES ('UPDATE', TG_TABLE_NAME, current_user, row_to_json(OLD)::text, row_to_json(NEW)::text);
                RETURN NEW;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER trg_audit_PERIODO_before_update
            BEFORE UPDATE ON PERIODO
            FOR EACH ROW EXECUTE FUNCTION audit_PERIODO_before_update();
        
            CREATE OR REPLACE FUNCTION audit_GRADO_SECCION_before_delete() RETURNS TRIGGER AS $$
            BEGIN
                INSERT INTO auditoria (accion, tabla_afectada, usuario, antes)
                VALUES ('DELETE', TG_TABLE_NAME, current_user, row_to_json(OLD)::text);
                RETURN OLD;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER trg_audit_GRADO_SECCION_before_delete
            BEFORE DELETE ON GRADO_SECCION
            FOR EACH ROW EXECUTE FUNCTION audit_GRADO_SECCION_before_delete();

            CREATE OR REPLACE FUNCTION audit_GRADO_SECCION_before_insert() RETURNS TRIGGER AS $$
            BEGIN
                INSERT INTO auditoria (accion, tabla_afectada, usuario, despues)
                VALUES ('INSERT', TG_TABLE_NAME, current_user, row_to_json(NEW)::text);
                RETURN NEW;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER trg_audit_GRADO_SECCION_before_insert
            BEFORE INSERT ON GRADO_SECCION
            FOR EACH ROW EXECUTE FUNCTION audit_GRADO_SECCION_before_insert();

            CREATE OR REPLACE FUNCTION audit_GRADO_SECCION_before_update() RETURNS TRIGGER AS $$
            BEGIN
                INSERT INTO auditoria (accion, tabla_afectada, usuario, antes, despues)
                VALUES ('UPDATE', TG_TABLE_NAME, current_user, row_to_json(OLD)::text, row_to_json(NEW)::text);
                RETURN NEW;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER trg_audit_GRADO_SECCION_before_update
            BEFORE UPDATE ON GRADO_SECCION
            FOR EACH ROW EXECUTE FUNCTION audit_GRADO_SECCION_before_update();
        
            CREATE OR REPLACE FUNCTION audit_CURSO_before_delete() RETURNS TRIGGER AS $$
            BEGIN
                INSERT INTO auditoria (accion, tabla_afectada, usuario, antes)
                VALUES ('DELETE', TG_TABLE_NAME, current_user, row_to_json(OLD)::text);
                RETURN OLD;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER trg_audit_CURSO_before_delete
            BEFORE DELETE ON CURSO
            FOR EACH ROW EXECUTE FUNCTION audit_CURSO_before_delete();

            CREATE OR REPLACE FUNCTION audit_CURSO_before_insert() RETURNS TRIGGER AS $$
            BEGIN
                INSERT INTO auditoria (accion, tabla_afectada, usuario, despues)
                VALUES ('INSERT', TG_TABLE_NAME, current_user, row_to_json(NEW)::text);
                RETURN NEW;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER trg_audit_CURSO_before_insert
            BEFORE INSERT ON CURSO
            FOR EACH ROW EXECUTE FUNCTION audit_CURSO_before_insert();

            CREATE OR REPLACE FUNCTION audit_CURSO_before_update() RETURNS TRIGGER AS $$
            BEGIN
                INSERT INTO auditoria (accion, tabla_afectada, usuario, antes, despues)
                VALUES ('UPDATE', TG_TABLE_NAME, current_user, row_to_json(OLD)::text, row_to_json(NEW)::text);
                RETURN NEW;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER trg_audit_CURSO_before_update
            BEFORE UPDATE ON CURSO
            FOR EACH ROW EXECUTE FUNCTION audit_CURSO_before_update();
        
            CREATE OR REPLACE FUNCTION audit_NIVEL_before_delete() RETURNS TRIGGER AS $$
            BEGIN
                INSERT INTO auditoria (accion, tabla_afectada, usuario, antes)
                VALUES ('DELETE', TG_TABLE_NAME, current_user, row_to_json(OLD)::text);
                RETURN OLD;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER trg_audit_NIVEL_before_delete
            BEFORE DELETE ON NIVEL
            FOR EACH ROW EXECUTE FUNCTION audit_NIVEL_before_delete();

            CREATE OR REPLACE FUNCTION audit_NIVEL_before_insert() RETURNS TRIGGER AS $$
            BEGIN
                INSERT INTO auditoria (accion, tabla_afectada, usuario, despues)
                VALUES ('INSERT', TG_TABLE_NAME, current_user, row_to_json(NEW)::text);
                RETURN NEW;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER trg_audit_NIVEL_before_insert
            BEFORE INSERT ON NIVEL
            FOR EACH ROW EXECUTE FUNCTION audit_NIVEL_before_insert();

            CREATE OR REPLACE FUNCTION audit_NIVEL_before_update() RETURNS TRIGGER AS $$
            BEGIN
                INSERT INTO auditoria (accion, tabla_afectada, usuario, antes, despues)
                VALUES ('UPDATE', TG_TABLE_NAME, current_user, row_to_json(OLD)::text, row_to_json(NEW)::text);
                RETURN NEW;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER trg_audit_NIVEL_before_update
            BEFORE UPDATE ON NIVEL
            FOR EACH ROW EXECUTE FUNCTION audit_NIVEL_before_update();
        
            CREATE OR REPLACE FUNCTION audit_NIVEL_DETALLE_before_delete() RETURNS TRIGGER AS $$
            BEGIN
                INSERT INTO auditoria (accion, tabla_afectada, usuario, antes)
                VALUES ('DELETE', TG_TABLE_NAME, current_user, row_to_json(OLD)::text);
                RETURN OLD;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER trg_audit_NIVEL_DETALLE_before_delete
            BEFORE DELETE ON NIVEL_DETALLE
            FOR EACH ROW EXECUTE FUNCTION audit_NIVEL_DETALLE_before_delete();

            CREATE OR REPLACE FUNCTION audit_NIVEL_DETALLE_before_insert() RETURNS TRIGGER AS $$
            BEGIN
                INSERT INTO auditoria (accion, tabla_afectada, usuario, despues)
                VALUES ('INSERT', TG_TABLE_NAME, current_user, row_to_json(NEW)::text);
                RETURN NEW;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER trg_audit_NIVEL_DETALLE_before_insert
            BEFORE INSERT ON NIVEL_DETALLE
            FOR EACH ROW EXECUTE FUNCTION audit_NIVEL_DETALLE_before_insert();

            CREATE OR REPLACE FUNCTION audit_NIVEL_DETALLE_before_update() RETURNS TRIGGER AS $$
            BEGIN
                INSERT INTO auditoria (accion, tabla_afectada, usuario, antes, despues)
                VALUES ('UPDATE', TG_TABLE_NAME, current_user, row_to_json(OLD)::text, row_to_json(NEW)::text);
                RETURN NEW;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER trg_audit_NIVEL_DETALLE_before_update
            BEFORE UPDATE ON NIVEL_DETALLE
            FOR EACH ROW EXECUTE FUNCTION audit_NIVEL_DETALLE_before_update();
        
            CREATE OR REPLACE FUNCTION audit_NIVEL_DETALLE_CURSO_before_delete() RETURNS TRIGGER AS $$
            BEGIN
                INSERT INTO auditoria (accion, tabla_afectada, usuario, antes)
                VALUES ('DELETE', TG_TABLE_NAME, current_user, row_to_json(OLD)::text);
                RETURN OLD;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER trg_audit_NIVEL_DETALLE_CURSO_before_delete
            BEFORE DELETE ON NIVEL_DETALLE_CURSO
            FOR EACH ROW EXECUTE FUNCTION audit_NIVEL_DETALLE_CURSO_before_delete();

            CREATE OR REPLACE FUNCTION audit_NIVEL_DETALLE_CURSO_before_insert() RETURNS TRIGGER AS $$
            BEGIN
                INSERT INTO auditoria (accion, tabla_afectada, usuario, despues)
                VALUES ('INSERT', TG_TABLE_NAME, current_user, row_to_json(NEW)::text);
                RETURN NEW;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER trg_audit_NIVEL_DETALLE_CURSO_before_insert
            BEFORE INSERT ON NIVEL_DETALLE_CURSO
            FOR EACH ROW EXECUTE FUNCTION audit_NIVEL_DETALLE_CURSO_before_insert();

            CREATE OR REPLACE FUNCTION audit_NIVEL_DETALLE_CURSO_before_update() RETURNS TRIGGER AS $$
            BEGIN
                INSERT INTO auditoria (accion, tabla_afectada, usuario, antes, despues)
                VALUES ('UPDATE', TG_TABLE_NAME, current_user, row_to_json(OLD)::text, row_to_json(NEW)::text);
                RETURN NEW;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER trg_audit_NIVEL_DETALLE_CURSO_before_update
            BEFORE UPDATE ON NIVEL_DETALLE_CURSO
            FOR EACH ROW EXECUTE FUNCTION audit_NIVEL_DETALLE_CURSO_before_update();
        
            CREATE OR REPLACE FUNCTION audit_HORARIO_before_delete() RETURNS TRIGGER AS $$
            BEGIN
                INSERT INTO auditoria (accion, tabla_afectada, usuario, antes)
                VALUES ('DELETE', TG_TABLE_NAME, current_user, row_to_json(OLD)::text);
                RETURN OLD;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER trg_audit_HORARIO_before_delete
            BEFORE DELETE ON HORARIO
            FOR EACH ROW EXECUTE FUNCTION audit_HORARIO_before_delete();

            CREATE OR REPLACE FUNCTION audit_HORARIO_before_insert() RETURNS TRIGGER AS $$
            BEGIN
                INSERT INTO auditoria (accion, tabla_afectada, usuario, despues)
                VALUES ('INSERT', TG_TABLE_NAME, current_user, row_to_json(NEW)::text);
                RETURN NEW;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER trg_audit_HORARIO_before_insert
            BEFORE INSERT ON HORARIO
            FOR EACH ROW EXECUTE FUNCTION audit_HORARIO_before_insert();

            CREATE OR REPLACE FUNCTION audit_HORARIO_before_update() RETURNS TRIGGER AS $$
            BEGIN
                INSERT INTO auditoria (accion, tabla_afectada, usuario, antes, despues)
                VALUES ('UPDATE', TG_TABLE_NAME, current_user, row_to_json(OLD)::text, row_to_json(NEW)::text);
                RETURN NEW;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER trg_audit_HORARIO_before_update
            BEFORE UPDATE ON HORARIO
            FOR EACH ROW EXECUTE FUNCTION audit_HORARIO_before_update();
        
            CREATE OR REPLACE FUNCTION audit_DOCENTE_NIVELDETALLE_CURSO_before_delete() RETURNS TRIGGER AS $$
            BEGIN
                INSERT INTO auditoria (accion, tabla_afectada, usuario, antes)
                VALUES ('DELETE', TG_TABLE_NAME, current_user, row_to_json(OLD)::text);
                RETURN OLD;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER trg_audit_DOCENTE_NIVELDETALLE_CURSO_before_delete
            BEFORE DELETE ON DOCENTE_NIVELDETALLE_CURSO
            FOR EACH ROW EXECUTE FUNCTION audit_DOCENTE_NIVELDETALLE_CURSO_before_delete();

            CREATE OR REPLACE FUNCTION audit_DOCENTE_NIVELDETALLE_CURSO_before_insert() RETURNS TRIGGER AS $$
            BEGIN
                INSERT INTO auditoria (accion, tabla_afectada, usuario, despues)
                VALUES ('INSERT', TG_TABLE_NAME, current_user, row_to_json(NEW)::text);
                RETURN NEW;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER trg_audit_DOCENTE_NIVELDETALLE_CURSO_before_insert
            BEFORE INSERT ON DOCENTE_NIVELDETALLE_CURSO
            FOR EACH ROW EXECUTE FUNCTION audit_DOCENTE_NIVELDETALLE_CURSO_before_insert();

            CREATE OR REPLACE FUNCTION audit_DOCENTE_NIVELDETALLE_CURSO_before_update() RETURNS TRIGGER AS $$
            BEGIN
                INSERT INTO auditoria (accion, tabla_afectada, usuario, antes, despues)
                VALUES ('UPDATE', TG_TABLE_NAME, current_user, row_to_json(OLD)::text, row_to_json(NEW)::text);
                RETURN NEW;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER trg_audit_DOCENTE_NIVELDETALLE_CURSO_before_update
            BEFORE UPDATE ON DOCENTE_NIVELDETALLE_CURSO
            FOR EACH ROW EXECUTE FUNCTION audit_DOCENTE_NIVELDETALLE_CURSO_before_update();
        
            CREATE OR REPLACE FUNCTION audit_CURRICULA_before_delete() RETURNS TRIGGER AS $$
            BEGIN
                INSERT INTO auditoria (accion, tabla_afectada, usuario, antes)
                VALUES ('DELETE', TG_TABLE_NAME, current_user, row_to_json(OLD)::text);
                RETURN OLD;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER trg_audit_CURRICULA_before_delete
            BEFORE DELETE ON CURRICULA
            FOR EACH ROW EXECUTE FUNCTION audit_CURRICULA_before_delete();

            CREATE OR REPLACE FUNCTION audit_CURRICULA_before_insert() RETURNS TRIGGER AS $$
            BEGIN
                INSERT INTO auditoria (accion, tabla_afectada, usuario, despues)
                VALUES ('INSERT', TG_TABLE_NAME, current_user, row_to_json(NEW)::text);
                RETURN NEW;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER trg_audit_CURRICULA_before_insert
            BEFORE INSERT ON CURRICULA
            FOR EACH ROW EXECUTE FUNCTION audit_CURRICULA_before_insert();

            CREATE OR REPLACE FUNCTION audit_CURRICULA_before_update() RETURNS TRIGGER AS $$
            BEGIN
                INSERT INTO auditoria (accion, tabla_afectada, usuario, antes, despues)
                VALUES ('UPDATE', TG_TABLE_NAME, current_user, row_to_json(OLD)::text, row_to_json(NEW)::text);
                RETURN NEW;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER trg_audit_CURRICULA_before_update
            BEFORE UPDATE ON CURRICULA
            FOR EACH ROW EXECUTE FUNCTION audit_CURRICULA_before_update();
        
            CREATE OR REPLACE FUNCTION audit_CALIFICACION_before_delete() RETURNS TRIGGER AS $$
            BEGIN
                INSERT INTO auditoria (accion, tabla_afectada, usuario, antes)
                VALUES ('DELETE', TG_TABLE_NAME, current_user, row_to_json(OLD)::text);
                RETURN OLD;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER trg_audit_CALIFICACION_before_delete
            BEFORE DELETE ON CALIFICACION
            FOR EACH ROW EXECUTE FUNCTION audit_CALIFICACION_before_delete();

            CREATE OR REPLACE FUNCTION audit_CALIFICACION_before_insert() RETURNS TRIGGER AS $$
            BEGIN
                INSERT INTO auditoria (accion, tabla_afectada, usuario, despues)
                VALUES ('INSERT', TG_TABLE_NAME, current_user, row_to_json(NEW)::text);
                RETURN NEW;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER trg_audit_CALIFICACION_before_insert
            BEFORE INSERT ON CALIFICACION
            FOR EACH ROW EXECUTE FUNCTION audit_CALIFICACION_before_insert();

            CREATE OR REPLACE FUNCTION audit_CALIFICACION_before_update() RETURNS TRIGGER AS $$
            BEGIN
                INSERT INTO auditoria (accion, tabla_afectada, usuario, antes, despues)
                VALUES ('UPDATE', TG_TABLE_NAME, current_user, row_to_json(OLD)::text, row_to_json(NEW)::text);
                RETURN NEW;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER trg_audit_CALIFICACION_before_update
            BEFORE UPDATE ON CALIFICACION
            FOR EACH ROW EXECUTE FUNCTION audit_CALIFICACION_before_update();
        
            CREATE OR REPLACE FUNCTION audit_MATRICULA_before_delete() RETURNS TRIGGER AS $$
            BEGIN
                INSERT INTO auditoria (accion, tabla_afectada, usuario, antes)
                VALUES ('DELETE', TG_TABLE_NAME, current_user, row_to_json(OLD)::text);
                RETURN OLD;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER trg_audit_MATRICULA_before_delete
            BEFORE DELETE ON MATRICULA
            FOR EACH ROW EXECUTE FUNCTION audit_MATRICULA_before_delete();

            CREATE OR REPLACE FUNCTION audit_MATRICULA_before_insert() RETURNS TRIGGER AS $$
            BEGIN
                INSERT INTO auditoria (accion, tabla_afectada, usuario, despues)
                VALUES ('INSERT', TG_TABLE_NAME, current_user, row_to_json(NEW)::text);
                RETURN NEW;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER trg_audit_MATRICULA_before_insert
            BEFORE INSERT ON MATRICULA
            FOR EACH ROW EXECUTE FUNCTION audit_MATRICULA_before_insert();

            CREATE OR REPLACE FUNCTION audit_MATRICULA_before_update() RETURNS TRIGGER AS $$
            BEGIN
                INSERT INTO auditoria (accion, tabla_afectada, usuario, antes, despues)
                VALUES ('UPDATE', TG_TABLE_NAME, current_user, row_to_json(OLD)::text, row_to_json(NEW)::text);
                RETURN NEW;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER trg_audit_MATRICULA_before_update
            BEFORE UPDATE ON MATRICULA
            FOR EACH ROW EXECUTE FUNCTION audit_MATRICULA_before_update();
        