<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="MSSQL_EditDatabase.ascx.cs" Inherits="SolidCP.Portal.ProviderControls.MSSQL_EditDatabase" %>
<%@ Register TagPrefix="scp" TagName="CollapsiblePanel" Src="../UserControls/CollapsiblePanel.ascx" %>

<scp:CollapsiblePanel id="secDataFiles" runat="server" IsCollapsed="true"
    TargetControlID="FilesPanel" meta:resourcekey="secDataFiles" Text="Database Files">
</scp:CollapsiblePanel>
<asp:Panel ID="FilesPanel" runat="server" Height="0" style="overflow:hidden;">
    <table id="tblFiles" runat="server" width="100%" cellpadding="3">
        <tr>
            <td style="width: 150px;" class="Medium">
                <asp:Label ID="lblDataFile" runat="server" meta:resourcekey="lblDataFile" Text="Data File"></asp:Label>
            </td>
            <td class="Medium">
                <asp:Label ID="lblLogFile" runat="server" meta:resourcekey="lblLogFile" Text="Log File"></asp:Label>
            </td>
        </tr>
        <tr>
            <td valign="top">
                <table cellspacing="0" cellpadding="3">
	                <tr>
		                <td class="SubHead" nowrap><asp:Label ID="lblDataSize" runat="server" meta:resourcekey="lblSize" Text="Size, KB:"></asp:Label></td>
		                <td class="Normal"><asp:Literal id="litDataSize" Runat="server" Text="0"></asp:Literal></td>
	                </tr>
	                <tr>
		                <td class="SubHead" nowrap><asp:Label ID="lblDataLogicalName" runat="server" meta:resourcekey="lblLogicalName" Text="Logical Name:"></asp:Label></td>
		                <td class="Normal"><asp:Literal id="litDataName" Runat="server"></asp:Literal></td>
	                </tr>
                </table>
            </td>
            <td valign="top">
                <table cellSpacing="0" cellPadding="3">
	                <tr>
		                <td class="SubHead" nowrap><asp:Label ID="lblLogSize" runat="server" meta:resourcekey="lblSize" Text="Size, KB:"></asp:Label></td>
		                <td class="Normal"><asp:Literal id="litLogSize" Runat="server" Text="0"></asp:Literal></td>
	                </tr>
	                <tr>
		                <td class="SubHead" nowrap><asp:Label ID="lblLogLogicalName" runat="server" meta:resourcekey="lblLogicalName" Text="Logical Name:"></asp:Label></td>
		                <td class="Normal"><asp:Literal id="litLogName" Runat="server"></asp:Literal></td>
	                </tr>
                </table>
            </td>
        </tr>
    </table> 
</asp:Panel>
<scp:CollapsiblePanel id="secMainTools" runat="server" IsCollapsed="true"
    TargetControlID="MainToolsPanel" meta:resourcekey="secMainTools" Text="Maintenance Tools">
</scp:CollapsiblePanel>
<asp:Panel ID="MainToolsPanel" runat="server" Height="0" style="overflow:hidden;">
    <table cellpadding="10">
        <tr>
            <td>
                <asp:Button ID="btnBackup" runat="server" meta:resourcekey="btnBackup" CausesValidation="false" 
                    Text="Backup" CssClass="Button1" OnClick="btnBackup_Click" />&nbsp;&nbsp;
                <asp:Button ID="btnRestore" runat="server" meta:resourcekey="btnRestore" CausesValidation="false" 
                    Text="Restore" CssClass="Button1" OnClick="btnRestore_Click" />
            </td>
        </tr>
    </table>
</asp:Panel>

<scp:CollapsiblePanel id="secHousekeepingTools" runat="server" IsCollapsed="true"
    TargetControlID="HousekeepingToolsPanel" meta:resourcekey="secHousekeepingTools" Text="Housekeeping Tools">
</scp:CollapsiblePanel>
<asp:Panel ID="HousekeepingToolsPanel" runat="server" Height="0" style="overflow:hidden;">
    <table cellpadding="10">
        <tr>
            <td>
                <asp:Button ID="btnTruncate" runat="server" meta:resourcekey="btnTruncate" CausesValidation="false" 
                    Text="Truncate Files" CssClass="Button3" OnClick="btnTruncate_Click" />
            </td>
        </tr>
    </table>
</asp:Panel>