<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SiteFooter.ascx.cs" Inherits="SolidCP.Portal.SkinControls.SiteFooter" %>
<%@ Register TagPrefix="scp" TagName="ProductVersion" Src="ProductVersion.ascx" %>
<table class="Container" cellpadding="0" cellspacing="0">
    <tr>
        <td class="Copyright">
			<asp:Localize ID="locPoweredBy" runat="server" meta:resourcekey="locPoweredBy" />
        </td>
        <td class="Version">
            <asp:Localize ID="locVersion" runat="server" meta:resourcekey="locVersion" /> <scp:ProductVersion id="scpVersion" runat="server" AssemblyName="SolidCP.Portal.Modules"/>
        </td>
    </tr>
</table>