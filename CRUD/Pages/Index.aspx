<%@ Page Title="Inicio" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="CRUD.Index" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h1 class="text-center my-4">Listado de Registros</h1>

    <div class="text-center mb-4">
        <asp:Button ID="BtnCreate" runat="server" Text="Crear Registro"
                    CssClass="btn btn-success" OnClick="BtnCreate_Click" />
    </div>

    <asp:Label ID="lblMensaje" runat="server" CssClass="d-block mb-3" EnableViewState="false" />

    <div class="table-responsive">
        <asp:GridView ID="gvusuarios" runat="server" AutoGenerateColumns="false"
                      CssClass="table table-borderless table-hover align-middle"
                      GridLines="None" EmptyDataText="No hay registros para mostrar.">
            <Columns>
                <asp:TemplateField HeaderText="Opciones del Administrador">
                    <ItemTemplate>
                        <asp:Button ID="btnRead" runat="server" Text="Read"
                                    CssClass="btn form-control-sm btn-info"
                                    CommandName="Leer"
                                    CommandArgument='<%# Eval("idUsuario") %>'
                                    OnClick="BtnRead_Click" />
                        <asp:Button ID="btnUpdate" runat="server" Text="Update"
                                    CssClass="btn form-control-sm btn-warning"
                                    CommandName="Actualizar"
                                    CommandArgument='<%# Eval("idUsuario") %>'
                                    OnClick="BtnUpdate_Click" />
                        <asp:Button ID="btnDelete" runat="server" Text="Delete"
                                    CssClass="btn form-control-sm btn-danger"
                                    CommandName="Eliminar"
                                    CommandArgument='<%# Eval("idUsuario") %>'
                                    OnClientClick="return confirm('¿Seguro que deseas eliminar este registro?');"
                                    OnClick="BtnDelete_Click" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="idUsuario" HeaderText="idUsuario" />
                <asp:BoundField DataField="Nombre" HeaderText="Nombre" />
                <asp:BoundField DataField="Edad" HeaderText="Edad" />
                <asp:BoundField DataField="Correo" HeaderText="Correo" />
                <asp:BoundField DataField="FechaNacimiento" HeaderText="Fecha de Nacimiento" DataFormatString="{0:dd/MM/yyyy}" />
                <asp:BoundField DataField="FechaDeInsercion" HeaderText="Fecha de Insercion" DataFormatString="{0:dd/MM/yyyy hh:mm tt}" />
            </Columns>
        </asp:GridView>
    </div>

</asp:Content>
