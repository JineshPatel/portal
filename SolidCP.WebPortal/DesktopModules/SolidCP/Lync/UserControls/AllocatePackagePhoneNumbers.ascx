﻿<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AllocatePackagePhoneNumbers.ascx.cs" Inherits="SolidCP.Portal.UserControls.AllocatePackagePhoneNumbers" %>
<%@ Register Src="../../UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="scp" %>


<scp:SimpleMessageBox id="messageBox" runat="server" />

<asp:ValidationSummary ID="validatorsSummary" runat="server" 
    ValidationGroup="AddAddress" ShowMessageBox="True" ShowSummary="False" />
 
<ul id="ErrorMessagesList" runat="server" visible="false">
    <li id="EmptyAddressesMessage" runat="server">
        <asp:Localize ID="locNotEnoughAddresses" runat="server" Text="Not enough..." meta:resourcekey="locNotEnoughAddresses"></asp:Localize>
    </li>
    <li id="QuotaReachedMessage" runat="server">
        <asp:Localize ID="locQuotaReached" runat="server" Text="Quota reached..." meta:resourcekey="locQuotaReached"></asp:Localize>
    </li>
</ul>

 <asp:UpdatePanel runat="server" ID="AddressesTable" UpdateMode="Conditional">
     <ContentTemplate>
        <table cellspacing="5" style="width: 100%;">
            <tr>
                <td>
                    <asp:RadioButton ID="radioExternalRandom" runat="server" AutoPostBack="true"
                        meta:resourcekey="radioExternalRandom" Text="Randomly select phone Numbers from the pool" 
                        Checked="True" GroupName="ExternalAddress" 
                        oncheckedchanged="radioExternalRandom_CheckedChanged" />
                </td>
            </tr>
            <tr id="AddressesNumberRow" runat="server">
                <td style="padding-left: 30px;">
                    <asp:Localize ID="locExternalAddresses" runat="server"
                            meta:resourcekey="locExternalAddresses" Text="Number of Phone Numbers:"></asp:Localize>

                    <asp:TextBox ID="txtExternalAddressesNumber" runat="server" CssClass="NormalTextBox" Width="50"></asp:TextBox>
                    
                    <asp:RequiredFieldValidator ID="ExternalAddressesValidator" runat="server" Text="*" Display="Dynamic"
                            ControlToValidate="txtExternalAddressesNumber" meta:resourcekey="ExternalAddressesValidator" SetFocusOnError="true"
                            ValidationGroup="AddAddress">*</asp:RequiredFieldValidator>
                            
                    <asp:Literal ID="litMaxAddresses" runat="server"></asp:Literal>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:RadioButton ID="radioExternalSelected" runat="server" AutoPostBack="true"
                        meta:resourcekey="radioExternalSelected" Text="Select PHone Number from the list" 
                        GroupName="ExternalAddress" 
                        oncheckedchanged="radioExternalSelected_CheckedChanged" />
                </td>
            </tr>
            <tr id="AddressesListRow" runat="server">
                <td style="padding-left: 30px;">
                    <asp:ListBox ID="listExternalAddresses" SelectionMode="Multiple" runat="server" Rows="8"
                        CssClass="NormalTextBox" Width="220" style="height:100px;" ></asp:ListBox>
                    <br />
                    <asp:Localize ID="locHoldCtrl" runat="server" 
                            meta:resourcekey="locHoldCtrl" Text="* Hold CTRL key to select multiple phone numbers" ></asp:Localize>
                </td>
            </tr>
        </table>
    </ContentTemplate>
</asp:UpdatePanel>
<p>
    <asp:Button ID="btnAdd" runat="server" meta:resourcekey="btnAdd"
        ValidationGroup="AddAddress" Text="Add" CssClass="Button1" 
        onclick="btnAdd_Click" />
    <asp:Button ID="btnCancel" runat="server" meta:resourcekey="btnCancel"
        CausesValidation="false" Text="Cancel" CssClass="Button1" 
        onclick="btnCancel_Click" />
</p>