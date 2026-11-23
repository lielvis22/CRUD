using System;
using System.Configuration;
using System.Data;
using System.Globalization;
using MySql.Data.MySqlClient;

namespace CRUD
{
    public partial class Crud : System.Web.UI.Page
    {
        // Conexión leída desde el Web.config (nombre "conexion")
        readonly MySqlConnection con = new MySqlConnection(
            ConfigurationManager.ConnectionStrings["conexion"].ConnectionString);

        // Valores que llegan por la URL: Crud.aspx?id=3&op=U
        string sID = "";
        string sOpc = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["id"] != null)
                sID = Request.QueryString["id"];

            if (Request.QueryString["op"] != null)
                sOpc = Request.QueryString["op"].ToUpper();

            if (!Page.IsPostBack)
            {
                // Los botones se activan según la acción que llega por la URL
                switch (sOpc)
                {
                    case "C":   // Crear
                        lblTitulo.Text = "Ingresar nuevo usuario";
                        BtnCreate.Visible = true;
                        break;

                    case "R":   // Leer (solo consulta)
                        lblTitulo.Text = "Consulta de usuario";
                        CargarDatos();
                        BloquearCampos();
                        break;

                    case "U":   // Actualizar
                        lblTitulo.Text = "Modificar usuario";
                        CargarDatos();
                        BtnUpdate.Visible = true;
                        break;

                    default:
                        Response.Redirect("~/Pages/Index.aspx");
                        break;
                }
            }
        }

        // Trae un usuario con sp_read y llena los campos
        void CargarDatos()
        {
            int id;
            if (!int.TryParse(sID, out id))
            {
                Response.Redirect("~/Pages/Index.aspx");
                return;
            }

            try
            {
                con.Open();
                using (MySqlDataAdapter da = new MySqlDataAdapter("sp_read", con))
                {
                    da.SelectCommand.CommandType = CommandType.StoredProcedure;
                    da.SelectCommand.Parameters.Add("_idUsuario", MySqlDbType.Int32).Value = id;
                    DataSet ds = new DataSet();
                    da.Fill(ds);

                    if (ds.Tables[0].Rows.Count == 0)
                    {
                        MostrarMensaje("No se encontros el usuario con id " + id + ".", "warning");
                        return;
                    }

                    DataRow fila = ds.Tables[0].Rows[0];
                    txtNombre.Text = fila["Nombre"].ToString();
                    txtEdad.Text = fila["Edad"].ToString();
                    txtCorreo.Text = fila["Correo"].ToString();
                    txtFecha.Text = Convert.ToDateTime(fila["FechaNacimiento"]).ToString("yyyy-MM-dd");
                }
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error al cargar el usuario: " + ex.Message, "danger");
            }
            finally
            {
                con.Close();
            }
        }

        // CREATE con insert_user
        protected void BtnCreate_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;
            try
            {
                using (MySqlCommand cmd = new MySqlCommand("insert_user", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("_nombre", MySqlDbType.VarChar).Value = txtNombre.Text.Trim();
                    cmd.Parameters.Add("_correo", MySqlDbType.VarChar).Value = txtCorreo.Text.Trim();
                    cmd.Parameters.Add("_edad", MySqlDbType.Int32).Value = Convert.ToInt32(txtEdad.Text);
                    cmd.Parameters.Add("_fechanacimiento", MySqlDbType.Date).Value = LeerFecha();
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
                Response.Redirect("~/Pages/Index.aspx", false);
            }
            catch (MySqlException ex) when (ex.Number == 1062)
            {
                MostrarMensaje("Ese correo ya esta registrado.", "warning");
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error al guardar: " + ex.Message, "danger");
            }
            finally
            {
                con.Close();
            }
        }

        // UPDATE con sp_update
        protected void BtnUpdate_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;
            try
            {
                using (MySqlCommand cmd = new MySqlCommand("sp_update", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("_idUsuario", MySqlDbType.Int32).Value = Convert.ToInt32(sID);
                    cmd.Parameters.Add("_nombre", MySqlDbType.VarChar).Value = txtNombre.Text.Trim();
                    cmd.Parameters.Add("_correo", MySqlDbType.VarChar).Value = txtCorreo.Text.Trim();
                    cmd.Parameters.Add("_edad", MySqlDbType.Int32).Value = Convert.ToInt32(txtEdad.Text);
                    cmd.Parameters.Add("_fechanacimiento", MySqlDbType.Date).Value = LeerFecha();
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
                Response.Redirect("~/Pages/Index.aspx", false);
            }
            catch (MySqlException ex) when (ex.Number == 1062)
            {
                MostrarMensaje("Ese correo ya esta registrado por otro usuario.", "warning");
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error al actualizar: " + ex.Message, "danger");
            }
            finally
            {
                con.Close();
            }
        }

        protected void BtnVolver_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Pages/Index.aspx");
        }

        // Convierte el texto del input date (AAAA-MM-DD) a DateTime
        DateTime LeerFecha()
        {
            return DateTime.ParseExact(txtFecha.Text, "yyyy-MM-dd", CultureInfo.InvariantCulture);
        }

        void BloquearCampos()
        {
            txtNombre.ReadOnly = true;
            txtEdad.ReadOnly = true;
            txtCorreo.ReadOnly = true;
            txtFecha.ReadOnly = true;
        }

        void MostrarMensaje(string texto, string tipo)
        {
            lblMensaje.Text = texto;
            lblMensaje.CssClass = "d-block alert alert-" + tipo;
        }
    }
}
