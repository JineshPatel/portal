<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ExchangeCreatePublicFolder.ascx.cs" Inherits="SolidCP.Portal.ExchangeServer.ExchangeCreatePublicFolder" %>
<%@ Register Src="../UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="scp" %>
<%@ Register Src="UserControls/EmailAddress.ascx" TagName="EmailAddress" TagPrefix="scp" %>
<%@ Register Src="../UserControls/EnableAsyncTasksSupport.ascx" TagName="EnableAsyncTasksSupport" TagPrefix="scp" %>

<scp:EnableAsyncTasksSupport id="asyncTasks" runat="server"/>

<div id="ExchangeContainer">
	<div class="Module">
		<div class="Left">
		</div>
		<div class="Content">
			<div class="Center">
				<div class="Title">
					<asp:Image ID="Image1" SkinID="ExchangePublicFolderAdd48" runat="server" />
					<asp:Localize ID="locTitle" runat="server" meta:resourcekey="locTitle" Text="Create Public Folder"></asp:Localize>
				</div>
				<div class="FormBody">
				    <scp:SimpleMessageBox id="messageBox" runat="server" />
					<table>
						<tr>
							<td class="FormLabel150"><asp:Localize ID="locParentFolder" runat="server" meta:resourcekey="locParentFolder" Text="Parent Folder:"></asp:Localize></td>
							<td>
								<asp:DropDownList ID="ddlParentFolder" runat="server" CssClass="NormalTextBox">
								</asp:DropDownList>
							</td>
						</tr>
						<tr>
							<td class="FormLabel150"><asp:Localize ID="locName" runat="server" meta:resourcekey="locName" Text="Folder Name: *"></asp:Localize></td>
							<td>
								<asp:TextBox ID="txtName" runat="server" CssClass="HugeTextBox200"></asp:TextBox>
								<asp:RequiredFieldValidator ID="valDisplayName" runat="server" meta:resourcekey="valRequireName" ControlToValidate="txtName"
									ErrorMessage="Enter Folder Name" ValidationGroup="CreateFolder" Display="Dynamic" Text="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
							</td>
						</tr>
					</table>
						
					<table>
						<tr>
							<td colspan="2">
							    <br />
							    <asp:CheckBox ID="chkMailEnabledFolder" runat="server" meta:resourcekey="chkMailEnabledFolder" Text="Mail Enabled Public Folder" AutoPostBack="True" OnCheckedChanged="chkMailEnabledFolder_CheckedChanged" />
							</td>
						</tr>
						<tr id="EmailRow" runat="server">
							<td class="FormLabel150"><asp:Localize ID="locEmail" runat="server" meta:resourcekey="locEmail" Text="E-mail Address: *"></asp:Localize></td>
							<td>
                                <scp:EmailAddress id="email" runat="server" ValidationGroup="CreateFolder">
                                </scp:EmailAddress>
                            </td>
						</tr>
					</table>
					
				    <div class="FormFooterClean">
					    <asp:Button id="btnCreate" runat="server" Text="Create Public Folder" CssClass="Button1" meta:resourcekey="btnCreate" ValidationGroup="CreateFolder" OnClick="btnCreate_Click"></asp:Button>
					    <asp:ValidationSummary ID="ValidationSummary1" runat="server" ShowMessageBox="True" ShowSummary="False" ValidationGroup="CreateFolder" />
				    </div>
				</div>
			</div>
		</div>
	</div>
</div>