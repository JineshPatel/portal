<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="RDSEditCollection.ascx.cs" Inherits="SolidCP.Portal.RDS.RDSEditCollection" %>
<%@ Register Src="../UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="scp" %>
<%@ Register Src="../UserControls/EnableAsyncTasksSupport.ascx" TagName="EnableAsyncTasksSupport" TagPrefix="scp" %>
<%@ Register Src="UserControls/RDSCollectionServers.ascx" TagName="CollectionServers" TagPrefix="scp"%>
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
					<asp:Image ID="imgAddRDSServer" SkinID="AddRDSServer48" runat="server" />
					<asp:Localize ID="locTitle" runat="server" meta:resourcekey="locTitle" Text="Add Server To Organization"></asp:Localize>
                    -
					<asp:Literal ID="litCollectionName" runat="server" Text="" />
				</div>
				<div class="FormBody">	
                    <div class="widget">
    <div class="widget-header clearfix">			    
                    <scp:CollectionTabs id="tabs" runat="server" SelectedTab="rds_edit_collection" />
        </div>
    <div class="widget-content tab-content">
                    <scp:SimpleMessageBox id="messageBox" runat="server" />
                    
                    <scp:CollapsiblePanel id="secRdsServers" runat="server"
                        TargetControlID="panelRdsServers" meta:resourcekey="secRdsServers" Text="">
                    </scp:CollapsiblePanel>		
                    
                    <asp:Panel runat="server" ID="panelRdsServers">                                                
                        <div style="padding: 10px;">
                            <scp:CollectionServers id="servers" runat="server" />
                        </div>                             
                    </asp:Panel>
                    <div class="FormFooterClean">
                        <scp:ItemButtonPanel id="buttonPanel" runat="server" ValidationGroup="SaveRDSCollection" 
                            OnSaveClick="btnSave_Click" OnSaveExitClick="btnSaveExit_Click" />
			        </div>                    
				</div>
                        </div></div>
			</div>
		</div>
	</div>
</div>