<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Login.ascx.cs" Inherits="SolidCP.Portal.Login" %>
<div class="form-group">
    <div class="row">
    <div class="col-sm-12">
        <div class="input-group">
							<span class="input-group-addon"><i class="fa fa-user"></i></span>
            <asp:TextBox id="txtUsername" runat="server" CssClass="form-control"></asp:TextBox>
        </div>
        <asp:RequiredFieldValidator id="usernameValidator" runat="server" CssClass="form-control" ErrorMessage="*" ControlToValidate="txtUsername"></asp:RequiredFieldValidator>
    </div>
    </div>
    <div class="row">
    <div class="col-sm-12">
		<div class="input-group">
							<span class="input-group-addon"><i class="fa fa-lock"></i></span>
                            <asp:TextBox id="txtPassword" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
	    </div>
        <asp:RequiredFieldValidator id="passwordValidator" runat="server" CssClass="NormalBold" ErrorMessage="*" ControlToValidate="txtPassword"></asp:RequiredFieldValidator>
    </div>
        </div>
    <div class="row">
					<div class="col-sm-12" style="padding-bottom:15px;">
                            <asp:CheckBox id="chkRemember" runat="server" meta:resourcekey="chkRemember" Text="Remember me on this computer"></asp:CheckBox>
					</div>
    </div>
    <div class="row">
					<div class="col-sm-7">
                        <asp:Button id="btnLogin" runat="server" meta:resourcekey="btnLogin" Text="Login" CssClass="btn btn-success btn-block" OnClick="btnLogin_Click" />
					</div>
					<div class="col-md-5 text-right">
						<asp:LinkButton id="cmdForgotPassword" runat="server"
					CausesValidation="False" OnClick="cmdForgotPassword_Click"
					meta:resourcekey="cmdForgotPassword" Text="Forgot your password">
				</asp:LinkButton>
					</div>
        </div>
    <div class="row" style="padding-top:65px;">
					<div class="col-sm-6">
                        <asp:Label ID="lblLanguage" runat="server" meta:resourcekey="lblLanguage" Text="Preferred Language:"></asp:Label>
                        <asp:DropDownList ID="ddlLanguage" runat="server" Width="100%" AutoPostBack="True" OnSelectedIndexChanged="ddlLanguage_SelectedIndexChanged"></asp:DropDownList>
					</div>
					<div class="col-md-6">
                        <asp:Label ID="lblTheme" runat="server" meta:resourcekey="lblTheme" Text="Theme:"></asp:Label>
						<asp:DropDownList ID="ddlTheme" runat="server" Width="100%" AutoPostBack="True" OnSelectedIndexChanged="ddlTheme_SelectedIndexChanged"></asp:DropDownList>
					</div>
        </div>
</div>