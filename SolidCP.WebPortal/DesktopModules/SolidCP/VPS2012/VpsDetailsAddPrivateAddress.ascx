﻿<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="VpsDetailsAddPrivateAddress.ascx.cs" Inherits="SolidCP.Portal.VPS2012.VpsDetailsAddPrivateAddress" %>
<%@ Register Src="../UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="scp" %>
<%@ Register Src="UserControls/ServerTabs.ascx" TagName="ServerTabs" TagPrefix="scp" %>
<%@ Register Src="UserControls/Menu.ascx" TagName="Menu" TagPrefix="scp" %>
<%@ Register Src="UserControls/Breadcrumb.ascx" TagName="Breadcrumb" TagPrefix="scp" %>
<%@ Register Src="UserControls/FormTitle.ascx" TagName="FormTitle" TagPrefix="scp" %>
<%@ Register Src="../UserControls/EnableAsyncTasksSupport.ascx" TagName="EnableAsyncTasksSupport" TagPrefix="scp" %>

<scp:EnableAsyncTasksSupport id="asyncTasks" runat="server"/>

	    <div class="Content">
		    <div class="Center">
			    <div class="FormBody">
			        <scp:ServerTabs id="tabs" runat="server" SelectedTab="vps_network" />
			        	
                    <scp:SimpleMessageBox id="messageBox" runat="server" />
                    
                    <asp:ValidationSummary ID="validatorsSummary" runat="server" 
                        ValidationGroup="AddAddress" ShowMessageBox="True" ShowSummary="False" />
                    
		            <p class="SubTitle">
		                <asp:Localize ID="locSubTitle" runat="server" meta:resourcekey="locSubTitle"
		                    Text="Add Private IP Addresses" />
		            </p>
                    
                    <table id="tablePrivateNetwork" runat="server" cellspacing="5" style="width: 100%;">
                        <tr>
                            <td>
                                <asp:RadioButton ID="radioPrivateRandom" runat="server" AutoPostBack="true"
                                    meta:resourcekey="radioPrivateRandom" Text="Randomly select next available IP addresses to the addresses format" 
                                    Checked="True" GroupName="PrivateAddress" />
                            </td>
                        </tr>
                        <tr id="PrivateAddressesNumberRow" runat="server">
                            <td style="padding-left: 30px;">
                                <asp:Localize ID="locPrivateAddresses" runat="server"
                                        meta:resourcekey="locPrivateAddresses" Text="Number of IP addresses:"></asp:Localize>

                                <asp:TextBox ID="txtPrivateAddressesNumber" runat="server" CssClass="NormalTextBox" Width="50" Text="1"></asp:TextBox>
                                
                                <asp:RequiredFieldValidator ID="PrivateAddressesValidator" runat="server" Text="*" Display="Dynamic"
                                        ControlToValidate="txtPrivateAddressesNumber" meta:resourcekey="PrivateAddressesValidator" SetFocusOnError="true"
                                        ValidationGroup="AddAddress">*</asp:RequiredFieldValidator>
                                        
                                <asp:Literal ID="litMaxPrivateAddresses" runat="server"></asp:Literal>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:RadioButton ID="radioPrivateSelected" runat="server" AutoPostBack="true"
                                    meta:resourcekey="radioPrivateSelected" Text="Assign specified IP addresses" 
                                    GroupName="PrivateAddress" />
                            </td>
                        </tr>
                        <tr id="PrivateAddressesListRow" runat="server">
                            <td style="padding-left: 30px;">
                                <asp:TextBox ID="txtPrivateAddressesList" runat="server" TextMode="MultiLine"
                                    CssClass="NormalTextBox" Width="170" Rows="5"></asp:TextBox>
                                <br />
                                <asp:Localize ID="locOnePerLine" runat="server"
                                        meta:resourcekey="locOnePerLine" Text="* Type one IP address per line"></asp:Localize>
                            </td>
                        </tr>
                    </table>
                    
                    <p>
                        <asp:Button ID="btnAdd" runat="server" meta:resourcekey="btnAdd"
                            ValidationGroup="AddAddress" Text="Add" CssClass="Button1" 
                            onclick="btnAdd_Click" />
                        <asp:Button ID="btnCancel" runat="server" meta:resourcekey="btnCancel"
                            CausesValidation="false" Text="Cancel" CssClass="Button1" 
                            onclick="btnCancel_Click" />
                    </p>

				    
			    </div>
		    </div>
	    </div>
