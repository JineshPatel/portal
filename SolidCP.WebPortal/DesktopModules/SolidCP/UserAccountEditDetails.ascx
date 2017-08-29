<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="UserAccountEditDetails.ascx.cs" Inherits="SolidCP.Portal.UserAccountEditDetails" %>
<%@ Register TagPrefix="dnc" TagName="UserContact" Src="UserControls/ContactDetails.ascx" %>
<%@ Register TagPrefix="scp" TagName="CollapsiblePanel" Src="UserControls/CollapsiblePanel.ascx" %>
<%@ Register Src="UserControls/EmailControl.ascx" TagName="EmailControl" TagPrefix="uc2" %>
<div class="FormBody">
<asp:BulletedList ID="blLog" runat="server" CssClass="ErrorText">
</asp:BulletedList>

	<table id="tblAccount" runat="server" cellSpacing="0" cellPadding="2">
		<tr>
			<td class="SubHead" style="width:200px;">
				<asp:Label ID="lblUsername2" runat="server" meta:resourcekey="lblUsername" Text="Username:"></asp:Label>
			</td>
			<td class="Huge">
				<asp:Literal ID="lblUsername" Runat="server"></asp:Literal>
			</td>
		</tr>
		<tr>
			<td class="SubHead">
				<asp:Label ID="lblFirstName" runat="server" meta:resourcekey="lblFirstName" Text="First Name:"></asp:Label>
			</td>
			<td class="NormalBold">
				<asp:TextBox id="txtFirstName" runat="server" CssClass="NormalTextBox"></asp:TextBox>
				<asp:RequiredFieldValidator id="firstNameValidator" runat="server" ErrorMessage="*" Display="Dynamic"
					ControlToValidate="txtFirstName"></asp:RequiredFieldValidator>
			</td>
		</tr>
		<tr>
			<td class="SubHead">
				<asp:Label ID="lblLastName" runat="server" meta:resourcekey="lblLastName" Text="Last Name:"></asp:Label>
			</td>
			<td class="NormalBold">
				<asp:TextBox id="txtLastName" runat="server" CssClass="NormalTextBox"></asp:TextBox>
                <asp:RequiredFieldValidator id="lastNameValidator" runat="server" ErrorMessage="*" Display="Dynamic"
					ControlToValidate="txtLastName"></asp:RequiredFieldValidator>
			</td>
		</tr>

		<tr>
			<td class="SubHead">
				<asp:Label ID="lblSubscriberNumber" runat="server" meta:resourcekey="lblSubscriberNumber" Text="Account Number:"></asp:Label>
			</td>
			<td class="NormalBold">
				<asp:TextBox id="txtSubscriberNumber" runat="server" CssClass="NormalTextBox" ></asp:TextBox>
			</td>
		</tr>
        
		<tr>
			<td class="SubHead">
				<asp:Label ID="lblEmail" runat="server" meta:resourcekey="lblEmail" Text="E-mail:"></asp:Label>
			</td>
			<td class="NormalBold">
                <uc2:EmailControl id="txtEmail" runat="server">
                </uc2:EmailControl>
			</td>
		</tr>
		<tr>
			<td class="SubHead">
				<asp:Label ID="lblSecondaryEmail" runat="server" meta:resourcekey="lblSecondaryEmail" Text="Secondary e-mail:"></asp:Label>
			</td>
			<td class="NormalBold">
                <uc2:EmailControl id="txtSecondaryEmail" runat="server" RequiredEnabled="false">
                </uc2:EmailControl>
            </td>
		</tr>
		<tr>
			<td class="SubHead">
				<asp:Label ID="lblMailFormat" runat="server" meta:resourcekey="lblMailFormat" Text="Mail Format:"></asp:Label>
			</td>
			<td class="NormalBold">
				<asp:DropDownList ID="ddlMailFormat" runat="server"
				    CssClass="NormalTextBox" resourcekey="ddlMailFormat">
				    <asp:ListItem Value="Text">PlainText</asp:ListItem>
				    <asp:ListItem Value="HTML">HTML</asp:ListItem>
				</asp:DropDownList>
			</td>
		</tr>
		<tr>
			<td class="normal">&nbsp;</td>
		</tr>
		<tr id="rowRole" runat="server">
			<td class="SubHead" vAlign="top">
			    <asp:Label ID="lblRole" runat="server" meta:resourcekey="lblRole" Text="Role:"></asp:Label>
			</td>
			<td class="NormalBold" vAlign="top">
				<asp:DropDownList id="role" runat="server" resourcekey="role" AutoPostBack="true" CssClass="NormalTextBox">
			        <asp:ListItem Value="User"></asp:ListItem>
			        <asp:ListItem Value="Reseller"></asp:ListItem>
				    <asp:ListItem Value="Administrator"></asp:ListItem>
				</asp:DropDownList>
			</td>
		</tr>
		<tr id="rowDemo" runat="server">
			<td class="SubHead">
                <asp:Label ID="lblDemoAccount" runat="server" meta:resourcekey="lblDemoAccount" Text="Demo Account:"></asp:Label>  
            </td>
			<td class="Normal">
				<asp:CheckBox id="chkDemo" runat="server" meta:resourcekey="chkDemo" Text="Yes"></asp:CheckBox>
			</td>
		</tr>

		<tr id="roleLoginStatus" runat="server">
			<td class="SubHead" valign="top">
			    <asp:Label ID="lblLoginStatus" runat="server" meta:resourcekey="lblLoginStatus" Text="Login Status:"></asp:Label>
			</td>
			<td class="NormalBold" valign="top">
				<asp:DropDownList id="loginStatus" runat="server" resourcekey="loginStatus"  CssClass="NormalTextBox">
			        <asp:ListItem Value="Enabled"></asp:ListItem>
			        <asp:ListItem Value="Disabled"></asp:ListItem>
				    <asp:ListItem Value="Locked Out"></asp:ListItem>
				</asp:DropDownList>
			</td>
		</tr>

	</table>
	<br/>

    <scp:CollapsiblePanel id="headContact" runat="server" IsCollapsed="true"
        TargetControlID="pnlContact" meta:resourcekey="secContact" Text="Contact">
    </scp:CollapsiblePanel>
	<asp:Panel ID="pnlContact" runat="server" Height="0" style="overflow:hidden;">
	    <dnc:usercontact id="contact" runat="server"></dnc:usercontact>
	</asp:Panel>

</div>
<div class="FormFooter">
    <asp:Button id="btnUpdate" CssClass="Button1" runat="server" Text="Update" meta:resourcekey="btnUpdate"
        OnClick="btnUpdate_Click"></asp:Button>
	<asp:Button id="btnCancel" CssClass="Button1" runat="server" meta:resourcekey="btnCancel" CausesValidation="False" Text="Cancel" OnClick="btnCancel_Click"></asp:Button>
</div>