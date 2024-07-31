// Importa el cliente PostgreSQL
const { Pool } = require('pg');
const pdf = require('html-pdf'); 
const { exec } = require('child_process');
const path = require('path');
// const fs = require('fs-extra');
const fs = require('fs');
const prompt = require('prompt-sync')({ sigint: true });; // Asegurando el uso de prompt-sync
const PDFDocument = require('pdfkit');
const puppeteer = require('puppeteer');


const pool = new Pool({
    user: 'postgres',
    host: 'localhost',
    database: 'bdcolegioweb',
    password: 'jostin345gta',
    port: 5432, 
});

// Función para conectarse a la base de datos
async function connectToDatabase() {
    try {
        const client = await pool.connect();
        console.log('Conexión exitosa a la base de datos');
        
        return client; 
    } catch (error) {
        console.error('Error al conectar a la base de datos:', error.message);
        throw error;
    }
    
}



//  ¡¡¡¡¡¡¡¡Insert¡¡¡¡¡¡¡¡¡
//  ¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡


// crear usuario
async function crearUsuario(client, nombreUsuario, clave) {
    try {
        const query = 'CALL crear_usuario($1, $2)';
        await client.query(query, [nombreUsuario, clave]);
        console.log('Usuario creado con éxito');
    } catch (error) {
        console.error('Error al crear el usuario:', error.message);
    }
}

// Crear rol
async function crearRol(client, nombreRol, contraseña) {
    try {
        const query = 'CALL crear_rol($1, $2)';
        await client.query(query, [nombreRol, contraseña]);
        console.log('Rol creado con éxito');
    } catch (error) {
        console.error('Error al crear el rol:', error.message);
    }
}

async function agregarEntidadConAtributos(nombreEntidad, atributosStr) {
    const atributos = atributosStr.split(',').map(atributo => atributo.trim());

    const sqlQuery = {
        text: 'CALL agregar_entidad_con_atributos($1, $2)',
        values: [nombreEntidad, atributos],
    };
    try {
        const res = await pool.query(sqlQuery);
        console.log('Entidad creada exitosamente');
    } catch (err) {
        console.error('Error al ejecutar el procedimiento almacenado: ', err);
    }
}




// eliminar usuario
async function eliminarUsuario(client, nombreUsuario) {
    try {
        const query = 'CALL eliminar_usuario($1)';
        await client.query(query, [nombreUsuario]);
        console.log('Usuario eliminado con éxito');
    } catch (error) {
        console.error('Error al eliminar el usuario:', error.message);
    }
} 

// Asignar rol a usuario
async function asignarRolAUsuario(client, nombreUsuario, nombreRol) {
    try {
        const query = 'CALL asignar_rol_a_usuario($1, $2)';
        await client.query(query, [nombreUsuario, nombreRol]);
        console.log('Rol asignado con éxito');
    } catch (error) {
        console.error('Error al asignar el rol:', error.message);
    }
}

//  ¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡
//  ¡¡¡¡¡¡¡¡¡¡¡¡MODIFICAR¡¡¡¡¡¡¡¡¡¡¡¡¡¡
//  ¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡
// Modificar usuario
async function modificarUsuario(client, nombreUsuarioActual, nuevoNombreUsuario, nuevaClave) {
    try {
        const query = {
            text: 'CALL modificar_usuario($1, $2, $3)',
            values: [nombreUsuarioActual, nuevoNombreUsuario, nuevaClave],
        };
        await client.query(query);
        console.log('Usuario modificado con éxito');
    } catch (error) {
        console.error('Error al modificar el usuario:', error.message);
    }
}



//  ¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡
//  ¡¡¡¡¡¡¡¡CONSULTAS -  METADATA¡¡¡¡¡¡
//  ¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡

// consultar usurios creados y no creados - metadata
async function consultarUsuariosMetadata(client) {
    try {
        const result = await client.query('SELECT * FROM obtener_nombres_usuarios()');
        result.rows.forEach(row => {
            console.log('USUARIOS: \n', row);
        });
    } catch (error) {
        console.error('Error al ejecutar el procedimiento almacenado consultar_usuarios_metadata:', error);
    }
}

// consultar tablas creadas - metadata
async function consultarTablas(client) {
    try {
        const result = await client.query('SELECT * FROM obtener_tablas()');
        let currentType = null;
        result.rows.forEach(row => {
            if (row.tabla_tipo !== currentType) {
                currentType = row.tabla_tipo;
                console.log(currentType === 'usuario' ? 'TABLAS DE USUARIO:' : 'TABLAS METADATA:');
            }
            console.log(row.tabla_nombre);
        });
    } catch (error) {
        console.error('Error al ejecutar el procedimiento almacenado consultar_tablas:', error);
    }
}


// consultar roles
async function consultarRoles(client) {
    try {
        const result = await client.query('SELECT * FROM buscar_roles()');
        let currentType = null;
        result.rows.forEach(row => {
            let tipoRol = row.buscar_roles.includes('Rol creado por el usuario') ? 'usuario' : 'metadata';
            if (tipoRol !== currentType) {
                currentType = tipoRol;
                console.log(currentType === 'usuario' ? 'ROLES DE USUARIO:' : 'ROLES METADATA:');
            }
            console.log(row.buscar_roles);
        });
    } catch (error) {
        console.error('Error al ejecutar el procedimiento almacenado buscar_roles:', error);
    }
}

// mostrar atributos por entidad
async function mostrarAtributosPorEntidad(client, nombreEntidad) {
    try {
        const query = 'SELECT * FROM listar_atributos_por_entidad_fun($1)';
        const result = await client.query(query, [nombreEntidad]);
        result.rows.forEach(row => {
            console.log("---",row.atributo);
        });
    } catch (error) {
        console.error('Error al mostrar atributos de la entidad:', error);
    }
}


// Obtener datos de una tabla
async function obtenerDatos(client, tabla) {
    try {
        const result = await client.query('SELECT * FROM ' + tabla);
        return result.rows;
    } catch (error) {
        console.error(`Error al obtener datos de la tabla ${tabla}:`, error);
    }
}

// generar reporte en pdf
// async function generarReporte(client, tabla) {
//     try {
//         const datos = await obtenerDatos(client, tabla);

//         const contenido = construirContenido(datos);

//         const docDefinition = {
//             content: contenido,
//             styles: {
//                 header: {
//                     fontSize: 18,
//                     bold: true,
//                     margin: [0, 0, 0, 10]
//                 },
//                 listItem: {
//                     margin: [0, 5]
//                 }
//             }
//         };

//         const pdfDoc = pdfmake.createPdf(docDefinition);

//         pdfDoc.getBase64(async (data) => {

//             const buffer = Buffer.from(data, 'base64');

//             const rutaArchivo = path.join(__dirname, 'reportes', `${tabla}.pdf`);
//             fs.writeFileSync(rutaArchivo, buffer);

//             console.log(`Reporte de ${tabla} generado exitosamente en ${rutaArchivo}`);
//         });
//     } catch (error) {
//         console.error('Error al generar el reporte:', error.message);
//     }
// }

// function construirContenido(datos) {
//     const contenido = [
//         { text: 'Reporte', style: 'header' },
//         { text: 'Datos:', style: 'subheader' }
//     ];

//     const listaDatos = datos.map((dato, index) => {
//         return { text: formatoDato(dato), style: 'listItem' };
//     });
//     contenido.push(listaDatos);

//     return contenido;
// }

// function formatoDato(dato) {
//     // Formatear cada dato como una cadena legible
//     return `ID: ${dato.id}\nDimensiones: ${dato.dimensiones}\nColor: ${dato.color}\nDescripción del terreno: ${dato.descripcionterreno}\n`;
// }

//  ¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡
//  ¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡
//  ¡¡¡¡¡¡¡¡Restaurar y Respaldar¡¡¡¡¡¡¡¡¡
//  ¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡
async function respaldarBaseDeDatos() {
    const nombreBaseDeDatos = await prompt('Ingrese el nombre de la base de datos a respaldar: ');
    const nombreArchivoRespaldo = await prompt('Ingrese el nombre del archivo de respaldo (.bak): ');
    const nombreUsuario = 'postgres';
    const rutaRespaldo = `./backups/${nombreArchivoRespaldo}`;
    const comando = `pg_dump -U ${nombreUsuario} -h localhost -d ${nombreBaseDeDatos} -Fc -W -f ${rutaRespaldo}`;
    exec(comando, (error) => {
        if (error) {
            console.log(`Error al respaldar la base de datos: ${error}`);
        } else {
            console.log('Respaldo de la base de datos completado con éxito');
        }
    });
}

// Restaurar base de datos
async function restaurarBaseDeDatos() {
    const nombreNuevaBaseDeDatos = await prompt('Ingrese el nombre de la nueva base de datos: ');
    const nombreArchivoRespaldo = await prompt('Ingrese el nombre del archivo de respaldo (.bak): ');
    const rutaRespaldo = `./backups/${nombreArchivoRespaldo}`;

    const comandoCrear = `createdb -U postgres -h localhost ${nombreNuevaBaseDeDatos}`;
    exec(comandoCrear, (error) => {
        if (error) {
            console.log(`Error al crear la base de datos: ${error}`);
        } else {
            console.log('Base de datos creada con éxito');

            const comandoRestaurar = `pg_restore -U postgres -h localhost -d ${nombreNuevaBaseDeDatos} < ${rutaRespaldo}`;
            exec(comandoRestaurar, (error) => {
                if (error) {
                    console.log(`Error al restaurar la base de datos: ${error}`);
                } else {
                    console.log('Restauración de la base de datos completada con éxito');
                }
            });
        }
    });
}

// Insert 
async function insertarDatos(client, tablaNombre, columnas, valores) {
    try {
        const query = {
            text: 'CALL insertar_datos($1::text, $2::text[], $3::text[])',
            values: [tablaNombre, columnas, valores],
        };
        await client.query(query);
        console.log(`Datos insertados en la tabla ${tablaNombre} correctamente.`);
    } catch (error) {
        console.error(`Error al insertar datos en la tabla ${tablaNombre}:`, error);
    }
}

// update -  entidad
async function actualizarEntidad(client, nombreEntidad, nombreColumna, nuevoValor, condicion) {
    try {
        const query = 'CALL actualizar_entidad($1, $2, $3, $4)';
        await client.query(query, [nombreEntidad, nombreColumna, nuevoValor, condicion]);
        console.log(`Datos de la entidad "${nombreEntidad}" actualizados con éxito.`);
    } catch (error) {
        console.error('Error al actualizar la entidad:', error.message);
    }
}

// Eliminar entidad
async function eliminarEntidad(client, nombreEntidad) {
    try {
        const query = 'CALL eliminar_entidad($1)';
        await client.query(query, [nombreEntidad]);
        console.log(`Entidad "${nombreEntidad}" eliminada con éxito.`);
    } catch (error) {
        console.error('Error al eliminar la entidad:', error.message);
    }
}


// PL- GENERATE
async function createStoredProc(operation, tableName,  data, columnsToUpdate, newValues) {
    let sql = '';
    switch (operation) {
        case 'select':
        sql = `
            CREATE OR REPLACE FUNCTION select_${tableName}()
            RETURNS SETOF ${tableName} AS $$
            BEGIN
                RETURN QUERY SELECT * FROM ${tableName};
            END;
            $$ LANGUAGE plpgsql;
            `;
        break;
        case 'insert':
            sql = `
                CREATE OR REPLACE PROCEDURE insert_${tableName}(data JSONB)
                LANGUAGE plpgsql
                AS $$
                BEGIN
                    INSERT INTO ${tableName} SELECT * FROM jsonb_populate_record(NULL::${tableName}, data);
                END $$;
            `;
            break;
        case 'update':
            // Genera la cláusula SET de la consulta SQL
            const setClause = Object.keys(data).map(columnName => `${columnName} = data->>'${columnName}'`).join(', ');

            sql = `
                CREATE OR REPLACE PROCEDURE update_${tableName}(record_id INT, data JSONB)
                LANGUAGE plpgsql
                AS $$
                BEGIN
                    UPDATE ${tableName}
                    SET ${setClause}
                    WHERE id = record_id;
                END $$;
                `;
            break;
        case 'delete':
            sql = `
            CREATE OR REPLACE PROCEDURE delete_${tableName}(record_id INT)
            LANGUAGE plpgsql
            AS $$
            BEGIN
                DELETE FROM ${tableName} WHERE id = record_id;
            END $$;
            `;
            break;
        default:
            console.log('Operación no soportada');
            return;
    }

    try {
        const client = await pool.connect();
        await client.query(sql);
        console.log(`Procedimiento almacenado ${operation}_${tableName} creado exitosamente`);
        client.release();
    } catch (error) {
        console.error('Error al crear el procedimiento almacenado:', error.message);
    }
}

// Disparadores de auditoria
const entities = [
    'MENU',
    'SUBMENU',
    'ROL',
    'PERMISOS',
    'USUARIO',
    'ALUMNO',
    'DOCENTE',
    'APODERADO',
    'PERIODO',
    'GRADO_SECCION',
    'CURSO',
    'NIVEL',
    'NIVEL_DETALLE',
    'NIVEL_DETALLE_CURSO',
    'HORARIO',
    'DOCENTE_NIVELDETALLE_CURSO',
    'CURRICULA',
    'CALIFICACION',
    'MATRICULA'
];

// Función para generar los disparadores
async function generateTriggers(client) {
    let sql = `
        CREATE TABLE IF NOT EXISTS auditoria (
            id_auditoria SERIAL PRIMARY KEY,
            accion VARCHAR(10) NOT NULL,
            tabla_afectada VARCHAR(50) NOT NULL,
            usuario VARCHAR(50) NOT NULL,
            fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            antes TEXT,
            despues TEXT
        );
    `;

    entities.forEach(entity => {
        sql += `
            CREATE OR REPLACE FUNCTION audit_${entity}_before_delete() RETURNS TRIGGER AS $$
            BEGIN
                INSERT INTO auditoria (accion, tabla_afectada, usuario, antes)
                VALUES ('DELETE', TG_TABLE_NAME, current_user, row_to_json(OLD)::text);
                RETURN OLD;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER trg_audit_${entity}_before_delete
            BEFORE DELETE ON ${entity}
            FOR EACH ROW EXECUTE FUNCTION audit_${entity}_before_delete();

            CREATE OR REPLACE FUNCTION audit_${entity}_before_insert() RETURNS TRIGGER AS $$
            BEGIN
                INSERT INTO auditoria (accion, tabla_afectada, usuario, despues)
                VALUES ('INSERT', TG_TABLE_NAME, current_user, row_to_json(NEW)::text);
                RETURN NEW;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER trg_audit_${entity}_before_insert
            BEFORE INSERT ON ${entity}
            FOR EACH ROW EXECUTE FUNCTION audit_${entity}_before_insert();

            CREATE OR REPLACE FUNCTION audit_${entity}_before_update() RETURNS TRIGGER AS $$
            BEGIN
                INSERT INTO auditoria (accion, tabla_afectada, usuario, antes, despues)
                VALUES ('UPDATE', TG_TABLE_NAME, current_user, row_to_json(OLD)::text, row_to_json(NEW)::text);
                RETURN NEW;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER trg_audit_${entity}_before_update
            BEFORE UPDATE ON ${entity}
            FOR EACH ROW EXECUTE FUNCTION audit_${entity}_before_update();
        `;
    });

    try {
        // Ejecutar la creación de la tabla y los disparadores en la base de datos
        await client.query(sql);
        console.log('Tabla de auditoría y disparadores creados exitosamente.');

        // Crear la carpeta 'Procedimientos' si no existe
        const folderPath = path.join(__dirname, 'Procedimientos');
        if (!fs.existsSync(folderPath)) {
            fs.mkdirSync(folderPath);
        }

        // Escribir el script en un archivo SQL en la carpeta 'Procedimientos'
        fs.writeFileSync(path.join(folderPath, 'triggers.sql'), sql);
        console.log('Archivo triggers.sql generado exitosamente en la carpeta Procedimientos.');
    } catch (error) {
        console.error('Error:', error);
    }
}



// async function getAuditLogs() {
//     const client = new Pool({
//         user: 'postgres',
//         host: 'localhost',
//         database: 'bdcolegioweb',
//         password: 'jostin345gta',
//         port: 5432,  // o el puerto correspondiente
//     });

//     try {
//         await client.connect();

//         const tiempo = prompt('Filtro de búsqueda (hoy, personalizado): ');

//         let logFilePath = 'log/postgresql.log'; // Ajusta según la ubicación de tus archivos de log
//         let query = `SELECT pg_read_file('${logFilePath}', 0, 100000) AS log_content`;

//         const result = await client.query(query);

//         const logFileContent = result.rows[0].log_content;
//         const logLines = logFileContent.split('\n').filter(line => line.trim() !== '');

//         let filtroTiempo;
//         let filteredLogs = logLines;

//         switch (tiempo) {
//             case 'hoy':
//                 const today = new Date().toISOString().split('T')[0];
//                 filteredLogs = logLines.filter(line => line.includes(today));
//                 break;
//             case 'personalizado':
//                 const fechaInicio = prompt('Ingrese la fecha de inicio (formato: YYYY-MM-DD HH:MI:SS): ');
//                 const fechaFin = prompt('Ingrese la fecha de fin (formato: YYYY-MM-DD HH:MI:SS): ');
//                 filtroTiempo = { start: new Date(fechaInicio), end: new Date(fechaFin) };
//                 filteredLogs = logLines.filter(line => {
//                     const logDate = new Date(line.split(' ')[0]);
//                     return logDate >= filtroTiempo.start && logDate <= filtroTiempo.end;
//                 });
//                 break;
//             default:
//                 console.error("Tiempo no válido especificado");
//                 return;
//         }

//         let formattedLogs = filteredLogs.map(line => {
//             return `<tr><td>${line}</td></tr>`;
//         }).join('');

//         if (formattedLogs.length === 0) {
//             formattedLogs = "<tr><td colspan='1'>No hay registros en el período de tiempo seleccionado.</td></tr>";
//         }

//         const html = `
//             <html>
//                 <head>
//                     <style>
//                         table { width: 100%; border-collapse: collapse; }
//                         th, td { border: 1px solid black; padding: 8px; text-align: left; }
//                         th { background-color: #f2f2f2; }
//                     </style>
//                 </head>
//                 <body>
//                     <h1>Logs del Sistema</h1>
//                     <table>
//                         <thead>
//                             <tr>
//                                 <th>Log</th>
//                             </tr>
//                         </thead>
//                         <tbody>
//                             ${formattedLogs}
//                         </tbody>
//                     </table>
//                 </body>
//             </html>
//         `;

//         const options = { format: 'A4' };

//         const reportesDir = path.join(__dirname, 'reportes');
//         if (!fs.existsSync(reportesDir)) {
//             fs.mkdirSync(reportesDir);
//         }

//         const filePath = path.join(reportesDir, 'SystemLogs.pdf');
//         pdf.create(html, options).toFile(filePath, (err, res) => {
//             if (err) return console.error(err);
//             console.log('PDF generado exitosamente:', res.filename);
//         });

//     } catch (error) {
//         console.error("Error al obtener los logs del sistema:", error);
//     } finally {
//         await client.end();
//     }
// }

// async function generatePDFWithPDFKit(logs) {
//     try {
//         const outputPath = path.join(__dirname, 'audit_logs.pdf');
//         console.log("Ruta de salida del PDF:", outputPath);

//         // Crear el directorio si no existe
//         await fs.ensureDir(path.dirname(outputPath));
//         console.log("Directorio asegurado:", path.dirname(outputPath));

//         const doc = new PDFDocument();
//         const writeStream = fs.createWriteStream(outputPath);
//         doc.pipe(writeStream);

//         doc.fontSize(16).text('Logs de Auditoría', { align: 'center' });
//         doc.moveDown();

//         logs.split('\n').forEach(line => {
//             doc.fontSize(12).text(line, { align: 'left' });
//             doc.moveDown(0.5);
//         });

//         doc.end();
//         writeStream.on('finish', () => {
//             console.log('PDF generado exitosamente:', outputPath);
//         });

//     } catch (error) {
//         console.error('Error durante la generación del PDF:', error);
//     }
// }





// Función para obtener LOGS
// con pg_stat_activity
// async function getSystemLogs() {
//     const pool = new Pool({
//         user: 'postgres',
//         host: 'localhost',
//         database: 'bdcolegioweb',
//         password: 'jostin345gta',
//         port: 5432,
//     });
//    // Obtener la fecha actual
//    const now = new Date();
//    const today = now.toISOString().split('T')[0]; // Obtener la fecha de hoy en formato YYYY-MM-DD

//    try {
//        console.log("Conectando a la base de datos...");
//        const client = await pool.connect();
//        console.log("Conexión exitosa.");

//        // Consulta para obtener todas las actividades del día actual desde pg_stat_activity
//        console.log("Ejecutando consulta para obtener logs de actividad...");
//        const activityResult = await client.query(`
//            SELECT
//                pid,
//                usename,
//                application_name,
//                client_addr,
//                client_hostname,
//                client_port,
//                backend_start,
//                xact_start,
//                query_start,
//                state_change,
//                wait_event_type,
//                wait_event,
//                state,
//                query
//            FROM pg_stat_activity
//            WHERE datname = 'bdcolegioweb'
//              AND backend_start::date = $1;
//        `, [today]);

//        const activityLogs = activityResult.rows;

//        console.log(`Total de logs obtenidos de pg_stat_activity: ${activityLogs.length}`);

//        // Consulta para obtener todas las consultas ejecutadas hoy desde pg_stat_statements
//        console.log("Ejecutando consulta para obtener logs de pg_stat_statements...");
//        const statementsResult = await client.query(`
//            SELECT
//                query,
//                calls,
//                total_exec_time,
//                rows,
//                shared_blks_hit,
//                shared_blks_read,
//                shared_blks_dirtied,
//                shared_blks_written
//            FROM pg_stat_statements
//            WHERE dbid = (SELECT oid FROM pg_database WHERE datname = 'bdcolegioweb');
//        `);

//        const statementLogs = statementsResult.rows;

//        console.log(`Total de logs obtenidos de pg_stat_statements: ${statementLogs.length}`);

//        if (activityLogs.length === 0 && statementLogs.length === 0) {
//            console.log('No se encontraron logs para la base de datos especificada en el rango de tiempo proporcionado.');
//            client.release();
//            await pool.end();
//            return;
//        }

//        // Generación del HTML para el PDF
//        console.log("Generando HTML para el PDF...");
//        let html = `
//            <html>
//                <head>
//                    <style>
//                        table { width: 100%; border-collapse: collapse; }
//                        th, td { border: 1px solid black; padding: 8px; text-align: left; }
//                        th { background-color: #f2f2f2; }
//                    </style>
//                </head>
//                <body>
//                    <h1>Logs de Actividad de la Base de Datos</h1>
//                    <h2>Logs de pg_stat_activity</h2>
//                    <table>
//                        <thead>
//                            <tr>
//                                <th>PID</th>
//                                <th>Usuario</th>
//                                <th>Nombre de la aplicación</th>
//                                <th>Dirección del cliente</th>
//                                <th>Nombre del host del cliente</th>
//                                <th>Puerto del cliente</th>
//                                <th>Inicio del backend</th>
//                                <th>Inicio de la transacción</th>
//                                <th>Inicio de la consulta</th>
//                                <th>Cambio de estado</th>
//                                <th>Tipo de evento de espera</th>
//                                <th>Evento de espera</th>
//                                <th>Estado</th>
//                                <th>Consulta</th>
//                            </tr>
//                        </thead>
//                        <tbody>
//        `;

//        activityLogs.forEach(log => {
//            html += `
//                <tr>
//                    <td>${log.pid}</td>
//                    <td>${log.usename}</td>
//                    <td>${log.application_name}</td>
//                    <td>${log.client_addr}</td>
//                    <td>${log.client_hostname}</td>
//                    <td>${log.client_port}</td>
//                    <td>${log.backend_start}</td>
//                    <td>${log.xact_start}</td>
//                    <td>${log.query_start}</td>
//                    <td>${log.state_change}</td>
//                    <td>${log.wait_event_type}</td>
//                    <td>${log.wait_event}</td>
//                    <td>${log.state}</td>
//                    <td>${log.query}</td>
//                </tr>
//            `;
//        });

//        html += `
//                        </tbody>
//                    </table>
//                    <h2>Logs de pg_stat_statements</h2>
//                    <table>
//                        <thead>
//                            <tr>
//                                <th>Consulta</th>
//                                <th>Llamadas</th>
//                                <th>Tiempo Total de Ejecución (ms)</th>
//                                <th>Filas Afectadas</th>
//                                <th>Bloques Compartidos (Hit)</th>
//                                <th>Bloques Compartidos (Leídos)</th>
//                                <th>Bloques Compartidos (Ensuciados)</th>
//                                <th>Bloques Compartidos (Escritos)</th>
//                            </tr>
//                        </thead>
//                        <tbody>
//        `;

//        statementLogs.forEach(log => {
//            html += `
//                <tr>
//                    <td>${log.query}</td>
//                    <td>${log.calls}</td>
//                    <td>${log.total_exec_time}</td>
//                    <td>${log.rows}</td>
//                    <td>${log.shared_blks_hit}</td>
//                    <td>${log.shared_blks_read}</td>
//                    <td>${log.shared_blks_dirtied}</td>
//                    <td>${log.shared_blks_written}</td>
//                </tr>
//            `;
//        });

//        html += `
//                        </tbody>
//                    </table>
//                </body>
//            </html>
//        `;

//        console.log("HTML generado:");
//        console.log(html); // Imprimir el HTML generado

//        console.log("Creando PDF...");

//        const browser = await puppeteer.launch();
//        const page = await browser.newPage();
//        await page.setContent(html);
//        const reportesDir = path.join(__dirname, 'reportes');
//        if (!fs.existsSync(reportesDir)) {
//            fs.mkdirSync(reportesDir);
//        }
//        const filePath = path.join(reportesDir, 'DatabaseActivityLogs.pdf');
//        await page.pdf({ path: filePath, format: 'A4' });
//        await browser.close();

//        console.log('PDF generado exitosamente:', filePath);

//        client.release();
//        await pool.end();

//    } catch (error) {
//        console.error("Error al obtener los logs de la base de datos:", error);
//        await pool.end();
//    }
// }



// con los archivos de log

async function getSystemLogs() {
    const logDir = 'C:\\Program Files\\PostgreSQL\\14\\data\\log';
    const databaseName = 'bdcolegioweb';
    const option = prompt('Seleccione el intervalo de tiempo (1: últimos 15 minutos, 2: última hora, 3: hoy): ');

    let startDate;

    switch (option) {
        case '1':
            startDate = new Date(Date.now() - 15 * 60 * 1000);
            break;
        case '2':
            startDate = new Date(Date.now() - 60 * 60 * 1000);
            break;
        case '3':
            startDate = new Date();
            startDate.setHours(0, 0, 0, 0);
            break;
        default:
            console.log('Opción no válida.');
            return;
    }

    // Obtener la lista de archivos en el directorio de logs
    const files = fs.readdirSync(logDir).filter(file => path.extname(file) === '.log');

    if (files.length === 0) {
        console.log('No se encontraron archivos de log.');
        return;
    }

    // Obtener el archivo más reciente
    const latestLogFile = files.reduce((latest, file) => {
        const latestFilePath = path.join(logDir, latest);
        const filePath = path.join(logDir, file);

        return fs.statSync(latestFilePath).mtime > fs.statSync(filePath).mtime ? latest : file;
    });

    // Leer el contenido del archivo de log más reciente
    const logContent = fs.readFileSync(path.join(logDir, latestLogFile), 'utf8');
    const logLines = logContent.split('\n');
    
    // Filtrar las líneas que contienen el nombre de la base de datos y están dentro del rango de tiempo
    const dbLogLines = logLines.filter(line => {
        const regex = /^(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\.\d{3}) [+-]\d{2}/;
        const match = line.match(regex);

        if (match) {
            const logDate = new Date(match[1]);
            return line.includes(databaseName) && logDate >= startDate;
        }

        return false;
    });

    // Crear una tabla HTML para mostrar el contenido del log, asegurando que las líneas largas se dividan correctamente
    const tableRows = dbLogLines.map(line => {
        const wrappedLine = line.replace(/(.{100})/g, '$1<br>');
        return `<tr><td style="width: 100%;">${wrappedLine}</td></tr>`;
    }).join('');

    const htmlContent = `
    <html>
        <head>
            <title>Log File</title>
            <style>
                body { font-family: Arial, sans-serif; }
                table { width: 100%; border-collapse: collapse; }
                th, td { border: 1px solid black; padding: 8px; text-align: left; word-wrap: break-word; }
            </style>
        </head>
        <body>
            <h1>logs de la base de datos:</h1>
            <table>
                <thead>
                    <tr>
                        <th>Línea</th>
                    </tr>
                </thead>
                <tbody>
                    ${tableRows}
                </tbody>
            </table>
        </body>
    </html>
    `;

    // Iniciar Puppeteer y generar el PDF
    const browser = await puppeteer.launch();
    const page = await browser.newPage();

    try {
        await page.setContent(htmlContent, { waitUntil: 'networkidle0' });
        await page.emulateMediaType('screen');
        await page.pdf({
            path: 'reportes/log-output.pdf',
            format: 'A4',
            printBackground: true,
            timeout: 60000
        });

        console.log('PDF generado correctamente.');
    } catch (error) {
        console.error('Error al generar el PDF:', error);
    } finally {
        await browser.close();
    }
}










// con pg_stat_statements

// async function getSystemLogs() {
//     const pool = new Pool({
//         user: 'postgres',
//         host: 'localhost',
//         database: 'bdcolegioweb',
//         password: 'jostin345gta',
//         port: 5432,
//     });

//     try {
//         console.log("Conectando a la base de datos...");
//         const client = await pool.connect();
//         console.log("Conexión exitosa.");

//         // Consulta para obtener todas las consultas ejecutadas desde pg_stat_statements
//         console.log("Ejecutando consulta para obtener logs de pg_stat_statements...");
//         const statementsResult = await client.query(`
//             SELECT
//                 userid,
//                 dbid,
//                 query,
//                 calls,
//                 total_exec_time,
//                 rows
//             FROM pg_stat_statements
//             WHERE dbid = (SELECT oid FROM pg_database WHERE datname = 'bdcolegioweb');
//         `);

//         const statementLogs = statementsResult.rows;

//         console.log(`Total de logs obtenidos de pg_stat_statements: ${statementLogs.length}`);

//         if (statementLogs.length === 0) {
//             console.log('No se encontraron logs para la base de datos especificada.');
//             client.release();
//             await pool.end();
//             return;
//         }

//         // Generación del HTML para el PDF
//         console.log("Generando HTML para el PDF...");
//         let html = `
//             <html>
//                 <head>
//                     <style>
//                         table { width: 100%; border-collapse: collapse; }
//                         th, td { border: 1px solid black; padding: 8px; text-align: left; }
//                         th { background-color: #f2f2f2; }
//                     </style>
//                 </head>
//                 <body>
//                     <h1>Consultas de la Base de Datos</h1>
//                     <table>
//                         <thead>
//                             <tr>
//                                 <th>Usuario</th>
//                                 <th>Consulta</th>
//                                 <th>Fecha</th>
//                             </tr>
//                         </thead>
//                         <tbody>
//         `;

//         for (const log of statementLogs) {
//             const userResult = await client.query(`SELECT usename FROM pg_user WHERE usesysid = $1`, [log.userid]);
//             const user = userResult.rows[0]?.usename || 'Desconocido';

//             html += `
//                 <tr>
//                     <td>${user}</td>
//                     <td>${log.query}</td>
//                     <td>${new Date()}</td>
//                 </tr>
//             `;
//         }

//         html += `
//                         </tbody>
//                     </table>
//                 </body>
//             </html>
//         `;

//         console.log("HTML generado:");
//         console.log(html); // Imprimir el HTML generado

//         console.log("Creando PDF...");

//         const browser = await puppeteer.launch();
//         const page = await browser.newPage();
//         await page.setContent(html);
//         const reportesDir = path.join(__dirname, 'reportes');
//         if (!fs.existsSync(reportesDir)) {
//             fs.mkdirSync(reportesDir);
//         }
//         const filePath = path.join(reportesDir, 'DatabaseActivityLogs.pdf');
//         await page.pdf({ path: filePath, format: 'A4' });
//         await browser.close();

//         console.log('PDF generado exitosamente:', filePath);

//         client.release();
//         await pool.end();

//     } catch (error) {
//         console.error("Error al obtener los logs de la base de datos:", error);
//         await pool.end();
//     }
// }









async function main() {
        const client = await connectToDatabase();
        console.log('\nMenú:');
        console.log('0. Listar entidades'); //si
        console.log('1. Crear usuario'); // si
        console.log('2. Modificar usuario'); // si
        console.log('3. Eliminar usuario'); // si
        console.log('4. Crear rol'); //si
        console.log('5. Asignar rol a usuario'); //si
        console.log('6. Consultar usuarios'); // si d
        console.log('7. Consultar roles');// si
        console.log('8. Listar atributos por entidad');
        console.log('9. Respaldar base de datos');
        console.log('10. Restaurar base de datos');
        console.log('11. Agregar entidad con atributos'); // insert
        console.log('12. Generar Reporte en PDF');
        console.log('13. Actualizar entidad '); // update
        console.log('14. Eliminar entidad'); // delete
        console.log('15. Insertar datos en una tabla') // insert
        console.log('16. Escoga una opcion para generar su procedimiento almacenado');
        console.log('17. Dispadores');
        console.log('18. Logs de auditoría');
        console.log('19. Salir');

    let choice = 0;
    while (choice !== 18) {
        choice = parseInt(await prompt('Seleccione una opción: '));
        switch (choice) {
            case 0:
                await consultarTablas(client);
                await main();
                break;
            case 1:
                const nombreUsuario = await prompt('Ingrese el nombre del nuevo usuario: ');
                const clave = await prompt('Ingrese la clave del nuevo usuario: ');
                await crearUsuario(client, nombreUsuario, clave);
                await main();
                break;
            case 2:
                const nombre_user_exist = await prompt('Ingrese nombre del usuario a modificar: ');
                const nuevo_nombre = await prompt('Ingrese el nuevo nombre del usuario: ');
                const claveMod = await prompt('Ingrese la nueva clave del usuario: ');
                await modificarUsuario(client, nombre_user_exist, nuevo_nombre, claveMod);
                await main();
                break;
            case 3:
                const nombre_Usuario = await prompt('Ingrese el nombre del usuario a eliminar: ');
                await eliminarUsuario(client, nombre_Usuario);
                await main();
                break;
            case 4:
                const nombrerol = await prompt('Ingrese el nuevo rol: ');
                const contraseña = await prompt('Ingrese la contraseña del nuevo rol: ');
                await crearRol(client, nombrerol, contraseña);
                await main();
                break;
            case 5:
                const nombreUsuarioAsignar = await prompt('Ingrese el nombre del usuario: ');
                const nombreRolAsignar = await prompt('Ingrese el nombre del rol: ');
                await asignarRolAUsuario(client, nombreUsuarioAsignar, nombreRolAsignar);
                await main();
                break;
            case 6:
                await consultarUsuariosMetadata (client);
                await main();
                break;
            case 7:
                await consultarRoles(client);
                await main();
                break;
            case 8:
                const nombreEntidad = await prompt('Ingrese el nombre de la entidad: ');
                await mostrarAtributosPorEntidad(client, nombreEntidad);
                await main();
                break;
            case 9:
                await respaldarBaseDeDatos(client);
                await main();
                break;
            case 10:
                await restaurarBaseDeDatos(client);  
                await main();  
                break;
            case 11:
                const entidadNombre = await prompt('Ingrese el nombre de la entidad: ');
                const atributos = await prompt('Ingrese los atributos de la entidad separados por una coma: ');
                await agregarEntidadConAtributos(entidadNombre, atributos);
                await main();
                break;
            case 12:
                const entidadReporte = await prompt('Ingrese el nombre de la entidad para generar el reporte: ');
                await generarReporte(client, entidadReporte);
                await main();
                break;
            case 13:
                const nombreEntidadActualizar = await prompt('Ingrese el nombre de la entidad a actualizar: ');
                const nombreColumnaActualizar = await prompt('Ingrese el nombre de la columna a actualizar: ');
                const nuevoValor = await prompt('Ingrese el nuevo valor: ');
                const condicion = await prompt('Ingrese la condición (e.g., id = 1): ');
                await actualizarEntidad(client, nombreEntidadActualizar, nombreColumnaActualizar, nuevoValor, condicion);
                await main();
                break;
            case 14:
                await consultarTablas(client);
                const nombreEntidadEliminar = await prompt('Ingrese el nombre de la entidad a eliminar: ');
                await eliminarEntidad(client, nombreEntidadEliminar);
                await main();
                break;
            case 15:
                const tablaNombre = await prompt('Ingrese el nombre de la tabla: ');
                const columnas = await prompt('Ingrese las columnas separadas por coma: ');
                const valores = await prompt('Ingrese los valores separados por coma: ');
                await insertarDatos(client, tablaNombre, columnas.split(','), valores.split(','));
                await main();
                break;

            case 16:
                const operation = (await prompt('Ingrese la operación (select, insert, update, delete): ')).trim().toLowerCase();
                const table = (await prompt('Ingrese el nombre de la tabla: ')).trim();
                const data = {};
            
                if (operation === 'insert') {
                    // Obtener las columnas de la tabla
                    const { rows } = await client.query(`SELECT column_name FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '${table}';`);
                    const columns = rows.map(row => row.column_name);
                
                    console.log(`Las columnas de la tabla ${table} son: ${columns.join(', ')}`);
                
                    const values = (await prompt(`Ingrese los valores para ${columns.join(', ')} separados por coma: `)).split(',');
                    columns.forEach((column, index) => {
                        data[column] = values[index].trim();
                    });
                
                    await createStoredProc(operation, table);
                    await pool.query(`CALL insert_${table}($1::jsonb)`, [JSON.stringify(data)]);
                } else if (operation === 'update') {
                    // Obtener las columnas de la tabla
                    const { rows } = await client.query(`SELECT column_name FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '${table}';`);
                    const columns = rows.map(row => row.column_name);
                
                    console.log(`Las columnas de la tabla ${table} son: ${columns.join(', ')}`);
                
                    // Solicitar al usuario que seleccione las columnas que desea actualizar
                    const columnsToUpdate = (await prompt(`Ingrese las columnas que desea actualizar, separadas por coma: `)).split(',');
                
                    // Solicitar al usuario que ingrese los nuevos valores para las columnas seleccionadas
                    const values = [];
                    for (let column of columnsToUpdate) {
                        const value = await prompt(`Ingrese el nuevo valor para ${column.trim()}: `);
                        values.push(value.trim());
                    }
                
                    // Solicitar al usuario que ingrese el id del registro a actualizar
                    const id = parseInt((await prompt('Ingrese el ID del registro que desea actualizar: ')).trim(), 10);
                
                    const data = {}; // Aquí se almacenarán los datos para la actualización
                    columnsToUpdate.forEach((column, index) => {
                        data[column.trim()] = values[index];
                    });
                
                    // Crear el procedimiento almacenado para la operación de actualización
                    await createStoredProc(operation, table, data, columnsToUpdate, values);
                
                    // Ejecutar la operación de actualización
                    await pool.query(`CALL update_${table}($1, $2::jsonb)`, [id, JSON.stringify(data)]);
                }
                 else if (operation === 'delete') {
                    const id = parseInt((await prompt('Ingrese el id para eliminar: ')).trim(), 10);
                    await createStoredProc(operation, table);
                    await pool.query(`CALL delete_${table}($1)`, [id]);
                } else if (operation === 'select') {
                    await createStoredProc(operation, table);
                    try {
                        const result = await pool.query(`SELECT * FROM select_${table}()`);
                        console.log('Datos obtenidos:');
                        console.log(result.rows);
                    } catch (e) {
                        console.error('Error al ejecutar la función:', e);
                    }
                } 
            case 17:
                await generateTriggers(client);
                break;
            case 18:
                // await getAuditLogs(client);
                await getSystemLogs(client);
                // await testPdfGeneration();
                break;          
            case 19:
                console.log('Saliendo...');
                break;
            default:
                console.log('Opción no válida');
                break;
        }
    }

    client.release();
    process.exit();
}









// async function prompt(question) {
//     const readline = require('readline').createInterface({
//         input: process.stdin,
//         output: process.stdout
//     });
//     return new Promise(resolve => {
//         readline.question(question, answer => {
//             readline.close();
//             resolve(answer);
//         });
//     });
// }
main();

module.exports = {
    connectToDatabase,

};

// 
//logs

// async function getAuditLogs() {
//     let connection;
//     try {
//         connection = await oracledb.getConnection();

//         // Solicitar al usuario que ingrese el período de tiempo deseado
//         rl.question('Ingrese el período de tiempo (5_minutos, 15_minutos, ultima_hora, ultimas_3_horas, hoy, personalizado): ', async (tiempo) => {
//             let filtroTiempo;
//             switch (tiempo) {
//                 case '5_minutos':
//                     filtroTiempo = `AND a.timestamp >= SYSDATE - (5 / (24 * 60))`; // 5 minutos en fracción de días
//                     break;
//                 case '15_minutos':
//                     filtroTiempo = `AND a.timestamp >= SYSDATE - (15 / (24 * 60))`; // 15 minutos en fracción de días
//                     break;
//                 case 'ultima_hora':
//                     filtroTiempo = `AND a.timestamp >= SYSDATE - (1 / 24)`; // 1 hora en fracción de días
//                     break;
//                 case 'ultimas_3_horas':
//                     filtroTiempo = `AND a.timestamp >= SYSDATE - (3 / 24)`; // 3 horas en fracción de días
//                     break;
//                 case 'hoy':
//                     filtroTiempo = `AND TRUNC(a.timestamp) = TRUNC(SYSDATE)`; // Desde el inicio del día actual
//                     break;
//                 case 'personalizado':
//                     // Solicitar al usuario que ingrese las fechas de inicio y fin personalizadas
//                     rl.question('Ingrese la fecha de inicio (formato: YYYY-MM-DD HH24:MI:SS): ', async (fechaInicio) => {
//                         rl.question('Ingrese la fecha de fin (formato: YYYY-MM-DD HH24:MI:SS): ', async (fechaFin) => {
//                             // Aplicar filtro de tiempo personalizado
//                             filtroTiempo = `AND a.timestamp BETWEEN TO_DATE('${fechaInicio}', 'YYYY-MM-DD HH24:MI:SS') AND TO_DATE('${fechaFin}', 'YYYY-MM-DD HH24:MI:SS')`;
                            
//                             // Ejecutar la consulta con el filtro de tiempo personalizado
//                             const result = await connection.execute(
//                                 `SELECT 
//                                     TO_CHAR(a.timestamp, 'DD/MM/YYYY HH24:MI:SS') AS fecha_hora,
//                                     u.username AS id_usuario,
//                                     s.machine AS direccion_ip,
//                                     a.action_name AS tipo_accion,
//                                     a.obj_name AS objeto_base_datos,
//                                     a.sql_text AS datos_modificados
//                                 FROM 
//                                     DBA_AUDIT_TRAIL a
//                                 JOIN 
//                                     DBA_USERS u ON a.username = u.username
//                                 JOIN 
//                                     SYS.V_$SESSION s ON a.sessionid = s.audsid
//                                 WHERE 
//                                     1=1 ${filtroTiempo}`
//                             );

//                             // Procesar los resultados
//                             console.log("Logs de auditoría:");

//                             // Formatear los resultados para Oracle SQL Developer
//                             let formattedLogs = result.rows.map(row => {
//                                 return `Timestamp: ${row[0]}, Usuario: ${row[1]}, Terminal: ${row[2]}, Acción: ${row[3]}, Objeto: ${row[4]}, SQL: ${row[5]}`;
//                             }).join('\n');

//                             // Imprimir los registros formateados
//                             console.log(formattedLogs);

//                             // Cerrar la conexión y el lector de consola
//                             await connection.close();
//                             rl.close();
//                         });
//                     });
//                     return; // Salir de la función getAuditLogs() para evitar que se cierre la conexión antes de obtener los datos
//                 default:
//                     console.error("Tiempo no válido especificado");
//                     rl.close();
//                     return; // Salir de la función getAuditLogs() si el tiempo no es válido
//             }

//             // Ejecutar la consulta con el filtro de tiempo seleccionado
//             const result = await connection.execute(
//                 `SELECT 
//                     TO_CHAR(a.timestamp, 'DD/MM/YYYY HH24:MI:SS') AS fecha_hora,
//                     u.username AS id_usuario,
//                     s.machine AS direccion_ip,
//                     a.action_name AS tipo_accion,
//                     a.obj_name AS objeto_base_datos,
//                     a.sql_text AS datos_modificados
//                 FROM 
//                     DBA_AUDIT_TRAIL a
//                 JOIN 
//                     DBA_USERS u ON a.username = u.username
//                 JOIN 
//                     SYS.V_$SESSION s ON a.sessionid = s.audsid
//                 WHERE 
//                     1=1 ${filtroTiempo}`
//             );

//             // Procesar los resultados
//             console.log("Logs de auditoría:");

//             // Formatear los resultados para Oracle SQL Developer
//             let formattedLogs = result.rows.map(row => {
//                 return `Timestamp: ${row[0]}, Usuario: ${row[1]}, Terminal: ${row[2]}, Acción: ${row[3]}, Objeto: ${row[4]}, SQL: ${row[5]}`;
//             }).join('\n');

//             // Imprimir los registros formateados
//             console.log(formattedLogs);

//             generatePDF(formattedLogs); 
//             // Cerrar la conexión y el lector de consola
//             await connection.close();
//             rl.close();
//         });
//     } catch (error) {
//         console.error("Error al obtener los logs de auditoría:", error);
//         rl.close();
//     }
// }



// function generatePDF(logs) {
//     const doc = new PDFDocument();
//     const filePath = path.join(__dirname, 'reportes', 'audit_logs.pdf');
//     const stream = fs.createWriteStream(filePath);

//     doc.pipe(stream);

//     // Agregar una cabecera
//     doc.font('Helvetica-Bold').fontSize(12).text('Reporte.', { align: 'left' });
//     doc.moveDown();

//     // Separar eventos y extraer información
//     const events = logs.split('\n');
//     events.forEach(event => {
//         const eventData = event.split(', ');
//         eventData.forEach(data => {
//             doc.text(data, { align: 'left' });
//         });
//         doc.moveDown();
//     });

//     doc.end();
//     console.log('Se ha generado el archivo PDF en la carpeta "reportes".');
// }


// const entities = [
//     'MENU',
//     'SUBMENU',
//     'ROL',
//     'PERMISOS',
//     'USUARIO',
//     'ALUMNO',
//     'DOCENTE',
//     'APODERADO',
//     'PERIODO',
//     'GRADO_SECCION',
//     'CURSO',
//     'NIVEL',
//     'NIVEL_DETALLE',
//     'NIVEL_DETALLE_CURSO',
//     'HORARIO',
//     'DOCENTE_NIVELDETALLE_CURSO',
//     'CURRICULA',
//     'CALIFICACION',
//     'MATRICULA'
// ];


// // Función para generar los disparadores
// function generateTriggers() {
//     let sql = '';

//     entities.forEach(entity => {
//         sql += `
//             CREATE OR REPLACE TRIGGER trg_audit_${entity}_before_delete
//             BEFORE DELETE ON ${entity}
//             FOR EACH ROW
//             DECLARE
//                 v_usuario VARCHAR2(50);
//                 v_json CLOB;
//             BEGIN
//                 SELECT USER INTO v_usuario FROM DUAL;
//                 v_json := '{' ||
//                           ${getColumnJsonString(entity, ':OLD')} ||
//                           '}';
//                 INSERT INTO auditoria (accion, tabla_afectada, usuario, fecha, antes)
//                 VALUES ('DELETE', '${entity}', v_usuario, SYSDATE, v_json);
//             END;
//             /

//             CREATE OR REPLACE TRIGGER trg_audit_${entity}_before_insert
//             BEFORE INSERT ON ${entity}
//             FOR EACH ROW
//             DECLARE
//                 v_usuario VARCHAR2(50);
//                 v_json CLOB;
//             BEGIN
//                 SELECT USER INTO v_usuario FROM DUAL;
//                 v_json := '{' ||
//                           ${getColumnJsonString(entity, ':NEW')} ||
//                           '}';
//                 INSERT INTO auditoria (accion, tabla_afectada, usuario, fecha, despues)
//                 VALUES ('INSERT', '${entity}', v_usuario, SYSDATE, v_json);
//             END;
//             /

//             CREATE OR REPLACE TRIGGER trg_audit_${entity}_before_update
//             BEFORE UPDATE ON ${entity}
//             FOR EACH ROW
//             DECLARE
//                 v_usuario VARCHAR2(50);
//                 v_old_json CLOB;
//                 v_new_json CLOB;
//             BEGIN
//                 SELECT USER INTO v_usuario FROM DUAL;
//                 v_old_json := '{' ||
//                               ${getColumnJsonString(entity, ':OLD')} ||
//                               '}';
//                 v_new_json := '{' ||
//                               ${getColumnJsonString(entity, ':NEW')} ||
//                               '}';
//                 INSERT INTO auditoria (accion, tabla_afectada, usuario, fecha, antes, despues)
//                 VALUES ('UPDATE', '${entity}', v_usuario, SYSDATE, v_old_json, v_new_json);
//             END;
//             /
//         `;
//     });

//     try {
//         // Crear la carpeta 'Procedimientos' si no existe
//         const folderPath = path.join(__dirname, 'Procedimientos');
//         if (!fs.existsSync(folderPath)) {
//             fs.mkdirSync(folderPath);
//         }

//         // Escribir el script en un archivo SQL en la carpeta 'Procedimientos'
//         fs.writeFileSync(path.join(folderPath, 'triggers.sql'), sql);
//         console.log('Archivo triggers.sql generado exitosamente en la carpeta Procedimientos.');
//     } catch (error) {
//         console.error('Error:', error);
//     }
// }

// // Función auxiliar para generar el JSON para cada columna de la entidad
// function getColumnJsonString(entity, prefix) {
//     // Aquí se debería definir el mapeo de columnas por cada entidad
//     // Por simplicidad, se asume que todas las entidades tienen las mismas columnas.
//     // Se deberá ajustar según las columnas reales de cada entidad.
//     const columns = [
//         'ValorCodigo',
//         'Codigo',
//         'DocumentoIdentidad',
//         'Nombres',
//         'Apellidos',
//         'FechaNacimiento',
//         'Sexo',
//         'GradoEstudio',
//         'Ciudad',
//         'Direccion',
//         'Email',
//         'NumeroTelefono'
//     ];

//     return columns.map(column => 
//         `'${column}":"' || ${prefix}.${column} || '",'`
//     ).join('');
// }
