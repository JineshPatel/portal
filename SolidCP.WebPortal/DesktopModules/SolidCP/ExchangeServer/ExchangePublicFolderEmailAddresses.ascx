<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ExchangePublicFolderEmailAddresses.ascx.cs" Inherits="SolidCP.Portal.ExchangeServer.ExchangePublicFolderEmailAddresses" %>
<%@ Register Src="../UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="scp" %>
<%@ Register Src="UserControls/EmailAddress.ascx" TagName="EmailAddress" TagPrefix="scp" %>
<%@ Register Src="UserControls/PublicFolderTabs.ascx" TagName="PublicFolderTabs" TagPrefix="scp" %>
<%@ Register TagPrefix="scp" TagName="CollapsiblePanel" Src="../UserControls/CollapsiblePanel.ascx" %>

<script language="javascript">
    function SelectAllCheckboxes(box)
    {
		var state = box.checked;
        var elm = box.parentElement.parentElement.parentElement.parentElement.getElementsByTagName("INPUT");
        for(i = 0; i < elm.length; i++)
            if(elm[i].type == "checkbox" && elm[i].id != box.id && elm[i].checked != state && !elm[i].disabled)
		        elm[i].checked = state;
    }
</script>

<div id="ExchangeContainer">
	<div class="Module">
		<div class="Left">
		</div>
		<div class="Content">
			<div class="Center">
				<div class="Title">
					<asp:Image ID="Image1" SkinID="ExchangePublicFolder48" runat="server" />
					<asp:Localize ID="locTitle" runat="server" meta:resourcekey="locTitle" Text="Edit Public Folder"></asp:Localize>
					-
					<asp:Literal ID="litDisplayName" runat="server" Text="John Smith" />
                </div>
				<div class="FormBody widget">
                    <div class="widget-header clearfix">
                    <scp:PublicFolderTabs id="tabs" runat="server" SelectedTab="public_folder_addresses" />
                    </div>
                    <div class="widget-content tab-content">
                    <scp:SimpleMessageBox id="messageBox" runat="server" />
                    
					<fieldset>
					    <legend>
					        <asp:Label ID="lblAddEmail" runat="server" Text="Add New E-mail Address" meta:resourcekey="lblAddEmail" CssClass="NormalBold"></asp:Label>
					        &nbsp;
					    </legend>
					    <table cellpadding="7">
						    <tr>
							    <td class="FormLabel150"><asp:Localize ID="locAccount" runat="server" meta:resourcekey="locAccount" Text="E-mail Address: *"></asp:Localize></td>
							    <td>
									<scp:EmailAddress id="email" runat="server" ValidationGroup="AddEmail">
									</scp:EmailAddress>
                                </td>
						    </tr>
						    <tr>
						        <td></td>
						        <td>
						            <asp:Button id="btnAddEmail" runat="server" Text="Add E-mail Address" CssClass="Button1" meta:resourcekey="btnAddEmail" ValidationGroup="AddEmail" OnClick="btnAddEmail_Click"></asp:Button>
						        </td>
						    </tr>
					    </table>
					</fieldset>
					<br />
					<br />
					
					<scp:CollapsiblePanel id="secExistingAddresses" runat="server"
                        TargetControlID="ExistingAddresses" meta:resourcekey="secExistingAddresses" Text="Existing E-mail Addresses">
                    </scp:CollapsiblePanel>
                    <asp:Panel ID="ExistingAddresses" runat="server" Height="0" style="overflow:hidden;">
                        <br />
				        <asp:GridView ID="gvEmails" runat="server" AutoGenerateColumns="False"
					        Width="100%" EmptyDataText="gvEmails" CssSelectorClass="NormalGridView" DataKeyNames="EmailAddress">
					        <Columns>
					            <asp:TemplateField>
					                <HeaderTemplate>
					                    <asp:CheckBox ID="chkSelectAll" runat="server" onclick="javascript:SelectAllCheckboxes(this);" />
					                </HeaderTemplate>
					                <ItemTemplate>
					                    <asp:CheckBox ID="chkSelect" runat="server" Enabled='<%# !(bool)Eval("IsPrimary") %>' />
					                </ItemTemplate>
                                    <ItemStyle Width="10px" />
					            </asp:TemplateField>
						        <asp:TemplateField HeaderText="gvEmailAddress">
							        <ItemStyle Width="60%"></ItemStyle>
							        <ItemTemplate>
								        <%# Eval("EmailAddress") %>
							        </ItemTemplate>
						        </asp:TemplateField>
						        <asp:TemplateField HeaderText="gvPrimaryEmail">
							        <ItemTemplate>
							            <div style="text-align:center">
							                &nbsp;
								            <asp:Image ID="Image2" runat="server" SkinID="Checkbox16" Visible='<%# Eval("IsPrimary") %>' />
								        </div>
							        </ItemTemplate>
						        </asp:TemplateField>
					        </Columns>
				        </asp:GridView>
				        
				        <br />
				        <asp:Localize ID="locTotal" runat="server" meta:resourcekey="locTotal" Text="Total E-mail Addresses:"></asp:Localize>
				        <asp:Label ID="lblTotal" runat="server" CssClass="NormalBold">1</asp:Label>
				        
					    <br />
					    <br />
				        <asp:Button id="btnSetAsPrimary" runat="server" Text="Set As Primary" meta:resourcekey="btnSetAsPrimary"
							CssClass="Button1" CausesValidation="false" OnClick="btnSetAsPrimary_Click"></asp:Button>
				        <asp:Button id="btnDeleteAddresses" runat="server" Text="Delete Selected E-mails" meta:resourcekey="btnDeleteAddresses"
							CssClass="Button1" CausesValidation="false" OnClick="btnDeleteAddresses_Click"></asp:Button>

					</asp:Panel>					
					<br />
					<br />
                        </div>
				</div>
			</div>
		</div>
	</div>
</div>