<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ExchangePublicFolders.ascx.cs" Inherits="SolidCP.Portal.ExchangeServer.ExchangePublicFolders" %>
<%@ Register Src="../UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="scp" %>
<%@ Register Src="../UserControls/QuotaViewer.ascx" TagName="QuotaViewer" TagPrefix="scp" %>
<%@ Register Src="../UserControls/EnableAsyncTasksSupport.ascx" TagName="EnableAsyncTasksSupport" TagPrefix="scp" %>

<scp:EnableAsyncTasksSupport id="asyncTasks" runat="server"/>

<div id="ExchangeContainer">
	<div class="Module">
		<div class="Left">
		</div>
		<div class="Content">
			<div class="Center">
				<div class="Title">
					<asp:Image ID="Image1" SkinID="ExchangePublicFolder48" runat="server" />
					<asp:Localize ID="locTitle" runat="server" meta:resourcekey="locTitle" Text="Public Folders"></asp:Localize>
				</div>
				
				<div class="FormBody">
				    <scp:SimpleMessageBox id="messageBox" runat="server" />
				    
                    <div class="FormButtonsBarClean">
                        <asp:Button ID="btnCreatePublicFolder" runat="server" meta:resourcekey="btnCreatePublicFolder"
                        Text="Create New Public Folder" CssClass="Button1" OnClick="btnCreatePublicFolder_Click" />
                    </div>
                    <br />
                    
				    <asp:TreeView ID="FoldersTree" runat="server">
				    </asp:TreeView>
				    <br />
				    <div style="text-align: left">
				        <asp:Button ID="btnDeleteFolders" runat="server" meta:resourcekey="btnDeleteFolders"
                            Text="Delete Selected Folders" CssClass="Button1" OnClick="btnDeleteFolders_Click" />
                    </div>
                    
                    <br />
				    <br />
				    <asp:Localize ID="locQuota" runat="server" meta:resourcekey="locQuota" Text="Total Public Folders Created:"></asp:Localize>
				    &nbsp;&nbsp;&nbsp;
				    <scp:QuotaViewer ID="foldersQuota" runat="server" QuotaTypeId="2" />
				    
				    
				</div>
			</div>
		</div>
	</div>
</div>