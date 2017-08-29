<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SettingsPackageSummaryLetter.ascx.cs" Inherits="SolidCP.Portal.SettingsPackageSummaryLetter" %>
<%@ Register TagPrefix="scp" TagName="CollapsiblePanel" Src="UserControls/CollapsiblePanel.ascx" %>

<table>
	<tr>
		<td class="Normal" colspan="2" style="height: 22px">
			<asp:CheckBox ID="chkEnableLetter" runat="server" meta:resourcekey="chkEnableLetter" Text="Enable Space Summary Letter" /></td>
	</tr>
	<tr>
		<td class="SubHead" width="150" nowrap><asp:Label ID="lblFrom" runat="server" meta:resourcekey="lblFrom" Text="From:"></asp:Label></td>
		<td class="Normal" width="100%">
			<asp:TextBox ID="txtFrom" runat="server" Width="500px" CssClass="NormalTextBox"></asp:TextBox></td>
	</tr>
	<tr>
		<td class="SubHead"><asp:Label ID="lblCC" runat="server" meta:resourcekey="lblCC" Text="CC:"></asp:Label></td>
		<td class="Normal">
			<asp:TextBox ID="txtCC" runat="server" Width="500px" CssClass="NormalTextBox"></asp:TextBox></td>
	</tr>
	<tr>
		<td class="SubHead"><asp:Label ID="lblSubject" runat="server" meta:resourcekey="lblSubject" Text="Subject:"></asp:Label></td>
		<td class="Normal">
			<asp:TextBox ID="txtSubject" runat="server" Width="500px" CssClass="NormalTextBox"></asp:TextBox></td>
	</tr>
    <tr>
        <td class="SubHead"><asp:Label ID="lblPriority" runat="server" meta:resourcekey="lblPriority" Text="Priority"></asp:Label></td>
        <td class="Normal">
            <asp:DropDownList ID="ddlPriority" runat="server" CssClass="NormalTextBox" resourcekey="ddlPriority">
				<asp:ListItem Value="High">High</asp:ListItem>
				<asp:ListItem Value="Normal">Normal</asp:ListItem>
				<asp:ListItem Value="Low">Low</asp:ListItem>
            </asp:DropDownList>
        </td>
    </tr>
	<tr>
		<td class="SubHead" colspan="2"><br /><br /><asp:Label ID="lblHtmlBody" runat="server" meta:resourcekey="lblHtmlBody" Text="HTML Body:"></asp:Label></td>
	</tr>
	<tr>
		<td class="Normal" colspan="2">
			<asp:TextBox ID="txtHtmlBody" runat="server" Rows="15" TextMode="MultiLine" Width="100%" CssClass="NormalTextBox" Wrap="false"></asp:TextBox></td>
	</tr>
	<tr>
		<td class="SubHead" colspan="2"><br /><br /><asp:Label ID="lblTextBody" runat="server" meta:resourcekey="lblTextBody" Text="Text Body:"></asp:Label></td>
	</tr>
	<tr>
		<td class="Normal" colspan="2">
			<asp:TextBox ID="txtTextBody" runat="server" Rows="15" TextMode="MultiLine" Width="100%" CssClass="NormalTextBox" Wrap="false"></asp:TextBox></td>
	</tr>
</table>