using System;
using System.Configuration;
using System.Data;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

namespace CRUD
{
    public partial class Index : System.Web.UI.Page
    {
        // Conexión leída desde el Web.config (nombre "conexion")
        readonly MySqlConnection con = new MySqlConnection(
            ConfigurationManager.ConnectionStrings["conexion"].ConnectionString);

        protected void Page_Load(object sender, EventArgs e)
        {
            // Solo se carga la tabla la primera vez que se abre la página
            if (!Page.IsPostBack)
            {
                cargarTabla();
            }
        }

        // Llena el GridView con el procedimiento sp_load
        void cargarTabla()
        {
            try
            {
                using (MySqlCommand cmd = new MySqlCommand("sp_load", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    con.Open();
                    using (MySqlDataAdapter da = new MySqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        gvusuarios.DataSource = dt;
                        gvusuarios.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error al cargar los datos: " + ex.Message, "danger");
            }
            finally
            {
                con.Close();
            }
        }

        protected void BtnCreate_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Pages/Crud.aspx?op=C");
        }

        protected void BtnRead_Click(object sender, EventArgs e)
        {
            string id = ((Button)sender).CommandArgument;
            Response.Redirect("~/Pages/Crud.aspx?id=" + id + "&op=R");
        }

        protected void BtnUpdate_Click(object sender, EventArgs e)
        {
            string id = ((Button)sender).CommandArgument;
            Response.Redirect("~/Pages/Crud.aspx?id=" + id + "&op=U");
        }

        // Borrado lógico con sp_delete (Anulado = 0 y FechaEliminacion = NOW())
        protected void BtnDelete_Click(object sender, EventArgs e)
        {
            int id = Convert.ToInt32(((Button)sender).CommandArgument);
            try
            {
                using (MySqlCommand cmd = new MySqlCommand("sp_delete", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("_idUsuario", MySqlDbType.Int32).Value = id;
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
                MostrarMensaje("Registro eliminado correctamente.", "success");
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error al eliminar: " + ex.Message, "danger");
            }
            finally
            {
                con.Close();
            }
            cargarTabla();
        }

        void MostrarMensaje(string texto, string tipo)
        {
            lblMensaje.Text = texto;
            lblMensaje.CssClass = "d-block alert alert-" + tipo;
        }
    }
}
