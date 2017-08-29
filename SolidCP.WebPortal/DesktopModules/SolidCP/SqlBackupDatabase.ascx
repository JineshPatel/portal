<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SqlBackupDatabase.ascx.cs" Inherits="SolidCP.Portal.SqlBackupDatabase" %>
<%@ Register Src="UserControls/FileLookup.ascx" TagName="FileLookup" TagPrefix="uc1" %>
<div class="FormBody">
    <table cellSpacing="0" cellPadding="5" width="100%">
	    <tr>
		    <td class="Huge" colspan="2"><asp:Literal id="litDatabaseName" runat="server"></asp:Literal></td>
	    </tr>
	    <tr>
		    <td><br/>
		    </td>
	    </tr>
	    <tr>
		    <td class="SubHead" vAlign="top"><asp:Label ID="lblBackupFileName" runat="server" meta:resourcekey="lblBackupFileName" Text="Backup File Name:"></asp:Label></td>
		    <td class="normal">
                <asp:TextBox ID="txtBackupName" runat="server" CssClass="NormalTextBox" Width="200"></asp:TextBox><asp:RequiredFieldValidator
                    ID="validatorUserName" runat="server" ControlToValidate="txtBackupName" CssClass="NormalBold"
                    Display="Dynamic" ErrorMessage="*"></asp:RequiredFieldValidator></td>
	    </tr>
	    <tr>
		    <td class="SubHead" vAlign="top"><asp:Label ID="lblBackupOptions" runat="server" meta:resourcekey="lblBackupOptions" Text="Backup Options:"></asp:Label></td>
		    <td class="normal"><asp:checkbox id="chkZipBackup" runat="server" meta:resourcekey="chkZipBackup" Checked="True" Text="ZIP Backup" AutoPostBack="True" OnCheckedChanged="chkZipBackup_CheckedChanged"></asp:checkbox><br/>
			    <br/>
			    </td>
	    </tr>
	    <tr>
		    <td class="SubHead" vAlign="top"><asp:Label ID="lblBackupDestination" runat="server" meta:resourcekey="lblBackupDestination" Text="Backup Destination:"></asp:Label></td>
		    <td class="normal">
			    <asp:radiobutton id="rbDownload" runat="server" meta:resourcekey="rbDownload" Checked="True" Text="Download via HTTP" GroupName="action"
				    AutoPostBack="True" OnCheckedChanged="rbDownload_CheckedChanged"></asp:radiobutton><br/>
			    <asp:radiobutton id="rbCopy" runat="server" meta:resourcekey="rbCopy" Text="Copy to Folder" GroupName="action"
				    AutoPostBack="True" OnCheckedChanged="rbDownload_CheckedChanged"></asp:radiobutton><br/>
                &nbsp;&nbsp;&nbsp;&nbsp;<uc1:FileLookup ID="fileLookup" runat="server" Width="300" />
			    </td>
	    </tr>
    </table>
</div>
<div class="FormFooter">
	<asp:Button ID="btnBackup" runat="server" meta:resourcekey="btnBackup" CssClass="Button1" Text="Backup" OnClick="btnBackup_Click" />
    <asp:Button ID="btnCancel" runat="server" meta:resourcekey="btnCancel" CssClass="Button1" CausesValidation="false" 
        Text="Cancel" OnClick="btnCancel_Click" />
</div>