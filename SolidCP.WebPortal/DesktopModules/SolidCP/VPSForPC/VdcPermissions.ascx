﻿<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="VdcPermissions.ascx.cs" Inherits="SolidCP.Portal.VPSForPC.VdcPermissions" %>
<%@ Register Src="../UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="scp" %>
<%@ Register Src="UserControls/Menu.ascx" TagName="Menu" TagPrefix="scp" %>
<%@ Register Src="UserControls/Breadcrumb.ascx" TagName="Breadcrumb" TagPrefix="scp" %>
<%@ Register Src="../UserControls/CollapsiblePanel.ascx" TagName="CollapsiblePanel" TagPrefix="scp" %>
<%@ Register Src="../UserControls/EnableAsyncTasksSupport.ascx" TagName="EnableAsyncTasksSupport" TagPrefix="scp" %>

<scp:EnableAsyncTasksSupport id="asyncTasks" runat="server"/>

<div id="VpsContainer">
    <div class="Module">

	    <div class="Header">
		    <scp:Breadcrumb id="breadcrumb" runat="server" />
	    </div>
    	
	    <div class="Left">
		    <scp:Menu id="menu" runat="server" SelectedItem="vdc_permissions" />
	    </div>
    	
	    <div class="Content">
		    <div class="Center">
			    <div class="Title">
				    <asp:Image ID="imgIcon" SkinID="Server48" runat="server" />
				    <asp:Localize ID="locTitle" runat="server" meta:resourcekey="locTitle" Text="User Permissions"></asp:Localize>
			    </div>
			    <div class="FormBody">
    			
			        <scp:SimpleMessageBox id="messageBox" runat="server" />
    			
			        <scp:CollapsiblePanel id="secVdcPermissions" runat="server"
                        TargetControlID="VdcPermissionsPanel" meta:resourcekey="secVdcPermissions" Text="Virtual Data Center Permissions">
                    </scp:CollapsiblePanel>
                    <asp:Panel ID="VdcPermissionsPanel" runat="server" Height="0" style="overflow:hidden;">
                    
			            <asp:GridView ID="gvVdcPermissions" runat="server" AutoGenerateColumns="False"
				            EmptyDataText="gvVdcPermissions" CssSelectorClass="NormalGridView">
				            <Columns>
					            <asp:BoundField HeaderText="columnUsername" DataField="Username" />
					            <asp:TemplateField HeaderText="columnCreateVps" ItemStyle-HorizontalAlign="Center">
					                <ItemTemplate>
					                    <asp:CheckBox ID="chkCreateVps" runat="server" />
					                </ItemTemplate>
					            </asp:TemplateField>
					            <asp:TemplateField HeaderText="columnExternalNetwork" ItemStyle-HorizontalAlign="Center">
					                <ItemTemplate>
					                    <asp:CheckBox ID="chkExternalNetwork" runat="server" />
					                </ItemTemplate>
					            </asp:TemplateField>
					            <asp:TemplateField HeaderText="columnPrivateNetwork" ItemStyle-HorizontalAlign="Center">
					                <ItemTemplate>
					                    <asp:CheckBox ID="chkPrivateNetwork" runat="server" />
					                </ItemTemplate>
					            </asp:TemplateField>
					            <asp:TemplateField HeaderText="columnManagePermissions" ItemStyle-HorizontalAlign="Center">
					                <ItemTemplate>
					                    <asp:CheckBox ID="chkManagePermissions" runat="server" />
					                </ItemTemplate>
					            </asp:TemplateField>
				            </Columns>
			            </asp:GridView>
			            <br />
                        <asp:Button ID="btnUpdateVdcPermissions" runat="server" meta:resourcekey="btnUpdateVdcPermissions"
                                CssClass="Button1" Text="Update" CausesValidation="false" 
                            onclick="btnUpdateVdcPermissions_Click" />
                        
                        <br />
                        <br />
                    </asp:Panel>
                    
                    
			        <scp:CollapsiblePanel id="secVpsPermissions" runat="server"
                        TargetControlID="VpsPermissionsPanel" meta:resourcekey="secVpsPermissions" Text="Virtual Private Server Permissions">
                    </scp:CollapsiblePanel>
                    <asp:Panel ID="VpsPermissionsPanel" runat="server" Height="0" style="overflow:hidden;">
                    
			            <asp:GridView ID="gvVpsPermissions" runat="server" AutoGenerateColumns="False"
				            EmptyDataText="gvVpsPermissions" CssSelectorClass="NormalGridView">
				            <Columns>
					            <asp:BoundField HeaderText="columnUsername" DataField="Username" />
					            <asp:TemplateField HeaderText="columnChangeState" ItemStyle-HorizontalAlign="Center">
					                <ItemTemplate>
					                    <asp:CheckBox ID="chkChangeState" runat="server" />
					                </ItemTemplate>
					            </asp:TemplateField>
					            <asp:TemplateField HeaderText="columnChangeConfig" ItemStyle-HorizontalAlign="Center">
					                <ItemTemplate>
					                    <asp:CheckBox ID="chkChangeConfig" runat="server" />
					                </ItemTemplate>
					            </asp:TemplateField>
					            <asp:TemplateField HeaderText="columnManageSnapshots" ItemStyle-HorizontalAlign="Center">
					                <ItemTemplate>
					                    <asp:CheckBox ID="chkManageSnapshots" runat="server" />
					                </ItemTemplate>
					            </asp:TemplateField>
					            <asp:TemplateField HeaderText="columnDeleteVps" ItemStyle-HorizontalAlign="Center">
					                <ItemTemplate>
					                    <asp:CheckBox ID="chkDeleteVps" runat="server" />
					                </ItemTemplate>
					            </asp:TemplateField>
					            <asp:TemplateField HeaderText="columnReinstallVps" ItemStyle-HorizontalAlign="Center">
					                <ItemTemplate>
					                    <asp:CheckBox ID="chkReinstallVps" runat="server" />
					                </ItemTemplate>
					            </asp:TemplateField>
				            </Columns>
			            </asp:GridView>
			            <br />
                        <asp:Button ID="btnUpdateVpsPermissions" runat="server" meta:resourcekey="btnUpdateVdcPermissions"
                                CssClass="Button1" Text="Update" CausesValidation="false" 
                            onclick="btnUpdateVpsPermissions_Click" />
                        <br />
                        
                    </asp:Panel>

			    </div>
		    </div>
		    <div class="Right">
			    <asp:Localize ID="FormComments" runat="server" meta:resourcekey="FormComments"></asp:Localize>
		    </div>
	    </div>
    	
    </div>
</div>