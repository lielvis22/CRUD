# Laboratorio CRUD – ASP.NET Web Forms + Bootstrap + MySQL
 
📅 **Fecha de entrega:** 23 de noviembre de 2026 · **II Semestre 2026**
 
---
 
## 📋 Contenido y Propósito
 
Aplicación **web** desarrollada en **ASP.NET Web Forms (.NET Framework)** que implementa un **CRUD** completo (Crear, Leer, Actualizar y Eliminar) de usuarios, conectado a una base de datos **MySQL** mediante **procedimientos almacenados**.
 
El objetivo del laboratorio es aplicar:
 
- **Página Maestra (Site.Master):** una plantilla reutilizable con la barra de navegación (navbar de **Bootstrap**), los metadatos y el pie de página, para no repetir el diseño en cada página.
- **Controles de servidor de ASP.NET** (`<asp:TextBox>`, `<asp:Button>`, `<asp:GridView>`) con `runat="server"`, manipulados desde C#.
- **CRUD con procedimientos almacenados:** cada operación (crear, listar, consultar, modificar, eliminar) se hace con su propio procedimiento en MySQL.
- **Borrado lógico:** los registros no se eliminan físicamente; se marcan con `Anulado = 0` y se guarda la fecha de eliminación.
- **Consultas parametrizadas** (`Parameters.Add`) para evitar la inyección SQL.
---
 
## 🛠️ Tecnologías Utilizadas
 
| Tecnología | Versión |
|---|---|
| Lenguaje | C# |
| Framework | ASP.NET Web Forms (.NET Framework 4.7.2) |
| Diseño | HTML5, CSS3 y Bootstrap 5 |
| Base de datos | MySQL Server 8.0 |
| Conector | MySql.Data (NuGet) |
| IDE | Visual Studio 2026 |
| Control de versiones | Git / GitHub |
 
---
 
## 👤 Autor y Contexto
 
- **Nombre:** Elvis Li
- **Institución:** Universidad Tecnológica de Panamá (UTP) — Facultad de Ingeniería en Sistemas Computacionales, Campus Víctor Levi Sasso
- **Carrera / Grupo:** Lic. en Ing. de Sistemas y Computación · 1IL133
- **Asignatura:** Herramientas de la Programación Aplicada III (.NET) — Módulo II: Lenguajes multiplataformas, ASP.NET
- **Instructora:** Ing. Irina Fong
- **Fecha de entrega:** 23 de noviembre de 2026
---
 
## 🖥️ Capturas y Problemas Resueltos
 
> Guarda tus capturas en la carpeta `capturas/` y reemplaza las rutas de abajo.
 
### Problema #1 – CREATE (crear registro)
Formulario `Crud.aspx?op=C` que inserta un usuario nuevo con el procedimiento `insert_user`. Luego redirige al listado.
 
![Crear registro](capturas/crear.png)
 
### Problema #2 – READ (listar y consultar)
`Index.aspx` muestra el listado de usuarios activos en un `GridView` (`sp_load`). `Crud.aspx?op=R` consulta un usuario por su id con los campos bloqueados (`sp_read`).
 
![Listado](capturas/listado.png)
![Consultar](capturas/consultar.png)
 
### Problema #3 – UPDATE (modificar registro)
`Crud.aspx?op=U` carga los datos del usuario y, al guardar, los actualiza por su id con `sp_update`. La `FechaModificacion` se actualiza sola en MySQL.
 
![Modificar](capturas/modificar.png)
 
### Problema #4 – DELETE (eliminación lógica)
Desde el listado, el botón Eliminar llama a `sp_delete`, que marca el registro con `Anulado = 0` y guarda `FechaEliminacion`. El usuario deja de aparecer en el listado pero no se borra de la base.
 
![Eliminar](capturas/eliminar.png)
 
---
 
## 📁 Estructura de Directorios
 
```
CRUD/
├── CRUD.sln                       # Solución de Visual Studio
├── CRUD/
│   ├── Site.Master                # Página maestra (metadatos, navbar Bootstrap, footer)
│   ├── Default.aspx               # Redirige a Pages/Index.aspx
│   ├── Pages/
│   │   ├── Index.aspx             # Listado (GridView) + botones Read / Update / Delete
│   │   └── Crud.aspx              # Formulario Crear / Consultar / Modificar (según ?op=C|R|U)
│   └── Web.config                 # Cadena de conexión "conexion"
├── BaseDeDatos/
│   └── crudasp.sql                # Base de datos, tabla, procedimientos y datos de prueba
└── README.md
```
 
### ¿Cómo funciona cada operación?
 
| Acción | Dónde | Procedimiento |
|---|---|---|
| Listar activos | `Index.aspx` → `cargarTabla()` | `sp_load` |
| Crear | `Crud.aspx?op=C` → `BtnCreate_Click` | `insert_user` |
| Consultar | `Crud.aspx?id=N&op=R` → `CargarDatos()` | `sp_read` |
| Modificar | `Crud.aspx?id=N&op=U` → `BtnUpdate_Click` | `sp_read` + `sp_update` |
| Eliminar (lógico) | `Index.aspx` → `BtnDelete_Click` | `sp_delete` |
 
- `FechaDeInsercion` y `FechaModificacion` las llena MySQL solas (`CURRENT_TIMESTAMP`).
- `Anulado = 1` → activo · `Anulado = 0` → eliminado.
- El id viaja por la URL (`Request.QueryString`) y en cada botón del grid con `CommandArgument`.
---
 
## ▶️ Ejecución y Referencias
 
### Instrucciones de ejecución
 
1. **Clonar el repositorio**
```bash
git clone https://github.com/lielvis22/CRUD.git
```
2. **Base de datos:** abrir `BaseDeDatos/crudasp.sql` en MySQL Workbench y ejecutarlo completo. Crea la base `crudasp`, la tabla `usuarios` y los procedimientos `insert_user`, `sp_load`, `sp_read`, `sp_update`, `sp_delete`.
3. **Abrir el proyecto:** doble clic en `CRUD.sln`. Requiere las cargas de trabajo *Desarrollo de ASP.NET y web* + *Plantillas de proyecto y de elemento de .NET Framework* y **.NET Framework 4.7.2**.
4. **Instalar el conector MySQL:** Herramientas → Administrador de paquetes NuGet → Consola:
```
Install-Package MySql.Data
```
5. **Configurar la conexión:** en `Web.config`, cambiar `Pwd=tu_contraseña` por la contraseña de tu usuario root de MySQL. Usar `SslMode=Disabled`.
6. **Ejecutar:** Compilar → Recompilar solución, luego **F5**.
### Errores comunes
 
| Error | Causa / Solución |
|---|---|
| *No se encuentra MySqlConnection* | Falta instalar `MySql.Data` (paso 4). |
| *Access denied for user 'root'* | Contraseña incorrecta en `Web.config`. |
| *Unknown database 'crudasp'* | No se ejecutó el script SQL (paso 2). |
| *No se puede encontrar el valor 'None'* | Cambiar `SslMode=None` por `SslMode=Disabled`. |
 
### Referencias
 
- [Documentación de Bootstrap 5](https://getbootstrap.com/docs/5.3/getting-started/introduction/)
- [ASP.NET Web Forms – Microsoft Learn](https://learn.microsoft.com/aspnet/web-forms/)
- [Páginas maestras en ASP.NET](https://learn.microsoft.com/aspnet/web-forms/overview/older-versions-getting-started/master-pages/)
- Material de clase: *ASP.NET*, *Bibliotecas de Clases*, *CSS3 y HTML5*, *Diseño y Navegación*, *Metadatos* y *Bootstrap* — Ing. Irina Fong
 
