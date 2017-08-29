﻿<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="VpsCheckPoints.ascx.cs" Inherits="SolidCP.Portal.VPSForPC.VpsCheckPoints" %>
<%@ Register Src="../UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="scp" %>
<%@ Register Src="UserControls/ServerTabs.ascx" TagName="ServerTabs" TagPrefix="scp" %>
<%@ Register Src="UserControls/FormTitle.ascx" TagName="FormTitle" TagPrefix="scp" %>
<%@ Register Src="UserControls/Menu.ascx" TagName="Menu" TagPrefix="scp" %>
<%@ Register Src="UserControls/Breadcrumb.ascx" TagName="Breadcrumb" TagPrefix="scp" %>

<div id="VpsContainer">
    <div class="Module">
	    <div class="Header">
		    <scp:Breadcrumb id="breadcrumb" runat="server" />
	    </div>
    	
	    <div class="Left">
		        <scp:Menu id="menu" runat="server" SelectedItem="" />
	    </div>
    	
	    <div class="Content">
		    <div class="Center">
			    <div class="Title">
				    <asp:Image ID="imgIcon" SkinID="Monitoring48" runat="server" />
                    <scp:FormTitle ID="locTitle" runat="server" meta:resourcekey="locTitle" Text="Snapshots" />
			    </div>
			    <div class="FormBody">
                    <scp:ServerTabs id="tabs" runat="server" SelectedTab="vps_checkpoints" />	
                    <scp:SimpleMessageBox id="messageBox" runat="server" />

                    <asp:TreeView runat="server" ID="treeCheckPoints"></asp:TreeView>
                <div class="FormButtonsBar" >
                            <asp:Button ID="btnCreateCheckPoint" runat="server" meta:resourcekey="btnCreate"
                                Text="Create Snapshot" CssClass="Button1" CausesValidation="False" 
                                onclick="btnCreateCheckPoint_Click" />
                            <asp:Button ID="btnRestoreCheckPoint" runat="server" meta:resourcekey="btnRestore"
                                Text="Restore Snapshot" CssClass="Button1" CausesValidation="False" 
                                onclick="btnRestoreCheckPoint_Click" />
                </div> 
            </div>
	        <div class="Right">
		        <asp:Localize ID="FormComments" runat="server" meta:resourcekey="FormComments"></asp:Localize>
	        </div>
        </div>    	
    </div>
</div>