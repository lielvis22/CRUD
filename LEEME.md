# Laboratorio CRUD: ASP.NET Web Forms + página maestra + Bootstrap + MySQL

## Contenido
```
CRUD.sln                      → abre esto en Visual Studio
CRUD/
  Site.Master                 → página maestra (metadatos, navbar Bootstrap, footer)
  Default.aspx                → redirige a Pages/Index.aspx
  Pages/Index.aspx            → listado (GridView gvusuarios) + botones Read / Update / Delete
  Pages/Crud.aspx             → formulario Crear / Consultar / Modificar (según ?op=C|R|U)
  Web.config                  → cadena de conexión "conexion"
BaseDeDatos/crudasp.sql       → base de datos, tabla usuarios, procedimientos y datos de prueba
```

## Pasos para correrlo

1. **Base de datos:** abre `BaseDeDatos/crudasp.sql` en MySQL Workbench (o phpMyAdmin → SQL) y ejecútalo completo.
   Crea la BD `crudasp`, la tabla `usuarios` y los procedimientos
   `insert_user`, `sp_load`, `sp_read`, `sp_update`, `sp_delete`.
2. **Abrir el proyecto:** doble clic en `CRUD.sln`. (Requiere las cargas de trabajo
   "Desarrollo de ASP.NET y web" + "Plantillas de proyecto y de elemento de .NET Framework" + .NET Framework 4.7.2.)
3. **Instalar MySQL:** Herramientas → Administrador de paquetes NuGet → Consola del Administrador de paquetes:
   ```
   Install-Package MySql.Data
   ```
4. **Contraseña:** en `Web.config` cambia `Pwd=tu_contraseña` por la de tu usuario root
   (si no tiene contraseña, deja `Pwd=;`).
5. **Ejecutar:** Compilar → Recompilar solución, y luego F5 (o clic derecho en `Pages/Index.aspx` → Ver en el explorador).

## Cómo funciona
| Acción | Dónde | Procedimiento |
|---|---|---|
| Listar activos | Index.aspx → `cargarTabla()` | `sp_load` |
| Crear | Crud.aspx?op=C → `BtnCreate_Click` | `insert_user` |
| Consultar | Crud.aspx?id=N&op=R → `CargarDatos()` (campos bloqueados) | `sp_read` |
| Modificar | Crud.aspx?id=N&op=U → `BtnUpdate_Click` | `sp_read` + `sp_update` |
| Eliminar (lógico) | Index.aspx → `BtnDelete_Click` | `sp_delete` (Anulado = 0, FechaEliminacion = NOW()) |

- `FechaDeInsercion` y `FechaModificacion` las llena MySQL solas (`CURRENT_TIMESTAMP`).
- `Anulado = 1` significa activo; `Anulado = 0` significa eliminado (igual que en las diapositivas).
- El id viaja por la URL (`Request.QueryString`) y en cada botón del grid con `CommandArgument='<%# Eval("idUsuario") %>'`.
- Todos los valores se envían con `Parameters.Add(...)`, lo que evita la inyección SQL.

## Errores comunes
- **"No se encuentra MySqlConnection / MySql.Data"** → falta el paso 3.
- **"Access denied for user 'root'"** → contraseña incorrecta en `Web.config`.
- **"Unknown database 'crudasp'"** → no se ejecutó el script SQL.
- **"Public Key Retrieval is not allowed"** → ya está resuelto con `AllowPublicKeyRetrieval=True` en la cadena.
