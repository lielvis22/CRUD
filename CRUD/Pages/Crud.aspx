<%@ Page Title="Registro" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Crud.aspx.cs" Inherits="CRUD.Crud" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card shadow-sm">
                <div class="card-body">

                    <h2 class="card-title text-center mb-4">
                        <asp:Label ID="lblTitulo" runat="server" Text="Registro" />
                    </h2>

                    <asp:Label ID="lblMensaje" runat="server" CssClass="d-block mb-3" EnableViewState="false" />

                    <div class="mb-3">
                        <label class="form-label" for="<%= txtNombre.ClientID %>">Nombre</label>
                        <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" MaxLength="150" />
                        <asp:RequiredFieldValidator ID="rfvNombre" runat="server" ControlToValidate="txtNombre"
                            ErrorMessage="El nombre es obligatorio." CssClass="text-danger small" Display="Dynamic" />
                    </div>

                    <div class="mb-3">
                        <label class="form-label" for="<%= txtEdad.ClientID %>">Edad</label>
                        <asp:TextBox ID="txtEdad" runat="server" CssClass="form-control" TextMode="Number" />
                        <asp:RequiredFieldValidator ID="rfvEdad" runat="server" ControlToValidate="txtEdad"
                            ErrorMessage="La edad es obligatoria." CssClass="text-danger small" Display="Dynamic" />
                        <asp:RangeValidator ID="rvEdad" runat="server" ControlToValidate="txtEdad"
                            Type="Integer" MinimumValue="0" MaximumValue="120"
                            ErrorMessage="La edad debe estar entre 0 y 120." CssClass="text-danger small" Display="Dynamic" />
                    </div>

                    <div class="mb-3">
                        <label class="form-label" for="<%= txtCorreo.ClientID %>">Correo</label>
                        <asp:TextBox ID="txtCorreo" runat="server" CssClass="form-control" TextMode="Email" MaxLength="150" />
                        <asp:RequiredFieldValidator ID="rfvCorreo" runat="server" ControlToValidate="txtCorreo"
                            ErrorMessage="El correo es obligatorio." CssClass="text-danger small" Display="Dynamic" />
                    </div>

                    <div class="mb-4">
                        <label class="form-label" for="<%= txtFecha.ClientID %>">Fecha de nacimiento</label>
                        <asp:TextBox ID="txtFecha" runat="server" CssClass="form-control" TextMode="Date" />
                        <asp:RequiredFieldValidator ID="rfvFecha" runat="server" ControlToValidate="txtFecha"
                            ErrorMessage="La fecha es obligatoria." CssClass="text-danger small" Display="Dynamic" />
                    </div>

                    <div class="d-flex gap-2 justify-content-center">
                        <asp:Button ID="BtnCreate" runat="server" Text="Guardar" CssClass="btn btn-success" OnClick="BtnCreate_Click" Visible="false" />
                        <asp:Button ID="BtnUpdate" runat="server" Text="Actualizar" CssClass="btn btn-warning" OnClick="BtnUpdate_Click" Visible="false" />
                        <asp:Button ID="BtnVolver" runat="server" Text="Volver" CssClass="btn btn-secondary" OnClick="BtnVolver_Click" CausesValidation="false" />
                    </div>

                </div>
            </div>
        </div>
    </div>

</asp:Content>
