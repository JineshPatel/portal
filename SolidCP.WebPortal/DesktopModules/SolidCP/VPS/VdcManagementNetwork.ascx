﻿<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="VdcManagementNetwork.ascx.cs" Inherits="SolidCP.Portal.VPS.VdcManagementNetwork" %>
<%@ Register Src="UserControls/Menu.ascx" TagName="Menu" TagPrefix="scp" %>
<%@ Register Src="UserControls/Breadcrumb.ascx" TagName="Breadcrumb" TagPrefix="scp" %>
<%@ Register Src="../UserControls/PackageIPAddresses.ascx" TagName="PackageIPAddresses" TagPrefix="scp" %>


<div id="VpsContainer">
    <div class="Module">

	    <div class="Header">
		    <scp:Breadcrumb id="breadcrumb" runat="server" />
	    </div>
    	
	    <div class="Left">
		    <scp:Menu id="menu" runat="server" SelectedItem="vdc_management_network" />
	    </div>
    	
	    <div class="Content">
		    <div class="Center">
			    <div class="Title">
				    <asp:Image ID="imgIcon" SkinID="Network48" runat="server" />
				    <asp:Localize ID="locTitle" runat="server" meta:resourcekey="locTitle" Text="Management Network"></asp:Localize>
			    </div>
			    <div class="FormBody">

                    
                    <scp:PackageIPAddresses id="packageAddresses" runat="server"
                            Pool="VpsManagementNetwork"
                            EditItemControl="vps_general"
                            SpaceHomeControl="vdc_management_network"
                            AllocateAddressesControl=""
                            ManageAllowed="true" />
                            
			    </div>
		    </div>
	    </div>
    	
    </div>
</div>