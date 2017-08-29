<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="RDSEditCollectionUsers.ascx.cs" Inherits="SolidCP.Portal.RDS.RDSEditCollectionUsers" %>
<%@ Register Src="../UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="scp" %>
<%@ Register Src="../UserControls/EnableAsyncTasksSupport.ascx" TagName="EnableAsyncTasksSupport" TagPrefix="scp" %>
<%@ Register Src="../UserControls/QuotaViewer.ascx" TagName="QuotaViewer" TagPrefix="scp" %>
<%@ Register Src="UserControls/RDSCollectionUsers.ascx" TagName="CollectionUsers" TagPrefix="scp"%>
<%@ Register Src="UserControls/RDSCollectionTabs.ascx" TagName="CollectionTabs" TagPrefix="scp" %>
<%@ Register TagPrefix="scp" TagName="CollapsiblePanel" Src="../UserControls/CollapsiblePanel.ascx" %>
<%@ Register Src="../UserControls/ItemButtonPanel.ascx" TagName="ItemButtonPanel" TagPrefix="scp" %>
<script type="text/javascript" src="/JavaScript/jquery.min.js?v=1.4.4"></script>

<scp:EnableAsyncTasksSupport id="asyncTasks" runat="server"/>

        <div id="ExchangeContainer">
            <div class="Module">
                <div class="Left">
                </div>
                <div class="Content">
                    <div class="Center">
                        <div class="Title">
                            <asp:Image ID="imgEditRDSCollection" SkinID="EnterpriseStorageSpace48" runat="server" />
                            <asp:Localize ID="locTitle" runat="server" meta:resourcekey="locTitle" Text="Edit RDS Collection"></asp:Localize>
                            -
                            <asp:Literal ID="litCollectionName" runat="server" Text="" />
                        </div>
                        <div class="FormContentRDS">
                            <asp:UpdatePanel runat="server" ID="messageUpdatePanel">
                                <ContentTemplate>
                                    <scp:SimpleMessageBox id="messageBox" runat="server" />
                                </ContentTemplate>                                
                            </asp:UpdatePanel>
                            <div class="widget">
    <div class="widget-header clearfix">
                            <scp:CollectionTabs id="tabs" runat="server" SelectedTab="rds_collection_edit_users" />         
                            </div>
    <div class="widget-content tab-content">           					
                            <scp:CollapsiblePanel id="secRdsUsers" runat="server"
                                TargetControlID="panelRdsUsers" meta:resourcekey="secRdsUsers" Text="">
                            </scp:CollapsiblePanel>		
                            <asp:Panel runat="server" ID="panelRdsUsers">                                                
                                <div style="padding: 10px;">
                                    <scp:CollectionUsers id="users" runat="server" />
                                </div>                            
                            </asp:Panel>
                            <div>
                                <asp:Localize ID="locQuota" runat="server" meta:resourcekey="locQuota" Text="Users Created:"></asp:Localize>
                                &nbsp;&nbsp;&nbsp;
                                <scp:QuotaViewer ID="usersQuota" runat="server" QuotaTypeId="2" DisplayGauge="true" />
                            </div>
                            <div class="FormFooterClean">
                                <scp:ItemButtonPanel id="buttonPanel" runat="server" ValidationGroup="SaveRDSCollection" 
                                    OnSaveClick="btnSave_Click" OnSaveExitClick="btnSaveExit_Click" />
                            </div>
                        </div>
                    </div>
                    </div></div>
                </div>
            </div>
        </div>