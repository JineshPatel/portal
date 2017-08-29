<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddRDSServer.ascx.cs" Inherits="SolidCP.Portal.RDS.AddRDSServer" %>
<%@ Register Src="../UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="scp" %>
<%@ Register Src="../UserControls/EnableAsyncTasksSupport.ascx" TagName="EnableAsyncTasksSupport" TagPrefix="scp" %>
<script type="text/javascript" src="/JavaScript/jquery.min.js?v=1.4.4"></script>

<scp:EnableAsyncTasksSupport id="asyncTasks" runat="server"/>

<div id="ExchangeContainer">
	<div class="Module">
		<div class="Left">
		</div>
		<div class="Content">
			<div class="Center">
				<div class="Title">
					<asp:Image ID="imgAddRDSServer" SkinID="AddRDSServer48" runat="server" />
					<asp:Localize ID="locTitle" runat="server" meta:resourcekey="locTitle" Text="Add Server To Organization"></asp:Localize>
				</div>
				<div class="FormBody">
				    <scp:SimpleMessageBox id="messageBox" runat="server" />
                  
					<table>
					    <tr>
						    <td class="FormLabel150"><asp:Localize ID="locServer" runat="server" meta:resourcekey="locServer" Text="Server:"></asp:Localize></td>
						    <td>
							    <asp:DropDownList ID="ddlServers" runat="server" CssClass="NormalTextBox" Width="150px" style="vertical-align: middle;" />
						    </td>
					    </tr>
					</table> 
                      
				    <div class="FormFooterClean">
					    <asp:Button id="btnAdd" runat="server" Text="Add" CssClass="Button1" meta:resourcekey="btnAdd" ValidationGroup="AddRDSServer" OnClick="btnAdd_Click" OnClientClick="ShowProgressDialog('Adding server...');"></asp:Button>
					    <asp:ValidationSummary ID="valSummary" runat="server" ShowMessageBox="True" ShowSummary="False" ValidationGroup="AddRDSServer" />
				    </div>
				</div>
			</div>
		</div>
	</div>
</div>