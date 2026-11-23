using System;

namespace CRUD
{
    // Al abrir la raíz del sitio, envía al listado
    public partial class _Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Response.Redirect("~/Pages/Index.aspx");
        }
    }
}
