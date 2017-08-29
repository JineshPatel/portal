<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AutoUpdateServers.ascx.cs" Inherits="SolidCP.Portal.AutoUpdateServers" %>
<%@ Register TagPrefix="scp" TagName="ProductVersion" Src="SkinControls/ProductVersion.ascx" %>
<%@ Import Namespace="SolidCP.Portal" %>

<asp:Label ID="lblSelectVersion" runat="server">Select version</asp:Label>
<asp:DropDownList ID="ddlSelectVersion" runat="server"></asp:DropDownList>

<asp:DataList ID="dlServers" Runat="server" CellSpacing="10" RepeatColumns="3" width="100%" RepeatDirection="Horizontal">
	<ItemStyle CssClass="BorderFillBox" VerticalAlign="Top"></ItemStyle>
	<ItemTemplate>
        <asp:CheckBox ID="chkServer" AutoPostBack="true" runat="server" Checked="true" Value='<%# Eval("ServerID") %>' /> 
        <%# PortalAntiXSS.EncodeOld((string)Eval("ServerName")) %>
    </ItemTemplate>
</asp:DataList>

<div class="FormButtonsBar">
    <asp:Label ID="lblUpdateMessage" runat="server" Text="This will update all servers to version:" /> <scp:ProductVersion id="scpVersion" runat="server" AssemblyName="SolidCP.Portal.Modules"/><br />
	<asp:Button ID="btnUpdateServers" runat="server" meta:resourcekey="btnUpdateServers" Text="Update Servers" CssClass="Button3" OnClick="btnUpdateServers_Click" />
</div>

<asp:Panel CssClass="FailedList" ID="failedList" runat="server" Visible="false">
    <table class="failed">
        <asp:Repeater runat="server" ID="lstFailed">
            <HeaderTemplate>
                <thead><tr><th>Server</th><th>Message</th></tr></thead>
            </HeaderTemplate>
            <ItemTemplate>
                <tr>
                    <td><%# getServerName(((KeyValuePair<int,string>)Container.DataItem).Key) %></td>
                    <td><%# ((KeyValuePair<int,string>)Container.DataItem).Value %></td>
                </tr>
            </ItemTemplate>
        </asp:Repeater>
    </table>
</asp:Panel>

<table id="tblEmptyList" runat="server" cellpadding="10" cellspacing="0" width="100%">
    <tr>
        <td class="Normal" align="center">
            <asp:Label ID="lblEmptyList" runat="server" meta:resourcekey="lblEmptyList" Text="Empty list..."></asp:Label>
        </td>
    </tr>
</table>