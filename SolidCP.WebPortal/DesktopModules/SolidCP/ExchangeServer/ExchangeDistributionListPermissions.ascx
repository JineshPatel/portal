<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ExchangeDistributionListPermissions.ascx.cs" Inherits="SolidCP.Portal.ExchangeServer.ExchangeDistributionListPermissions" %>
<%@ Register Src="../UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="scp" %>
<%@ Register Src="UserControls/DistributionListTabs.ascx" TagName="DistributionListTabs" TagPrefix="scp" %>
<%@ Register TagPrefix="scp" TagName="CollapsiblePanel" Src="../UserControls/CollapsiblePanel.ascx" %>
<%@ Register Src="UserControls/AcceptedSenders.ascx" TagName="AcceptedSenders" TagPrefix="scp" %>
<%@ Register Src="UserControls/RejectedSenders.ascx" TagName="RejectedSenders" TagPrefix="scp" %>
<%@ Register Src="../UserControls/EnableAsyncTasksSupport.ascx" TagName="EnableAsyncTasksSupport" TagPrefix="scp" %>

<%@ Register src="UserControls/AccountsList.ascx" tagname="AccountsList" TagPrefix="scp" %>

<scp:EnableAsyncTasksSupport id="asyncTasks" runat="server"/>

<div id="ExchangeContainer">
	<div class="Module">
		<div class="Left">
		</div>
		<div class="Content">
			<div class="Center">
				<div class="Title">
					<asp:Image ID="Image1" SkinID="ExchangeList48" runat="server" />
					<asp:Localize ID="locTitle" runat="server" meta:resourcekey="locTitle" Text="Edit Distribution List"></asp:Localize>
					-
					<asp:Literal ID="litDisplayName" runat="server" Text="John Smith" />
                </div>
				<div class="FormBody widget">
                    <div class="widget-header clearfix">
                    <scp:DistributionListTabs id="tabs" runat="server" SelectedTab="dlist_permissions" />	
                    </div>
                    <div class="widget-content tab-content">
					<scp:SimpleMessageBox id="messageBox" runat="server" />
					
					<scp:CollapsiblePanel id="secSendOnBehalf" runat="server"
                        TargetControlID="SendOnBehalf" meta:resourcekey="secSendOnBehalf" >
                    </scp:CollapsiblePanel>
                    <asp:Panel ID="SendOnBehalf" runat="server" Height="0" style="overflow:hidden;">
					    <asp:Label runat="server" ID="lblGrandPermissions" meta:resourcekey="lblGrandPermissions" /><br /><br />
					    <scp:AccountsList id="sendBehalfList" runat="server" MailboxesEnabled="true" EnableMailboxOnly = "true" ></scp:AccountsList>
					</asp:Panel>
					
					
					<scp:CollapsiblePanel id="secSendAs" runat="server"
                        TargetControlID="SendAs" meta:resourcekey="secSendAs" >
                    </scp:CollapsiblePanel>
                    <asp:Panel ID="SendAs" runat="server" Height="0" style="overflow:hidden;">
					    <asp:Label runat="server" ID="Label1" meta:resourcekey="lblGrandPermissions" /><br /><br />
					    <scp:AccountsList id="sendAsList" runat="server"
					MailboxesEnabled="true" EnableMailboxOnly = "true" ></scp:AccountsList>
					</asp:Panel>
					
				    <div class="FormFooterClean">
					    <asp:Button id="btnSave" runat="server" Text="Save Changes" CssClass="Button1" 
                            meta:resourcekey="btnSave" ValidationGroup="EditMailbox" 
                            onclick="btnSave_Click"></asp:Button>
				        
				    </div>
				</div>
			</div>
                </div>
		</div>
	</div>
</div>