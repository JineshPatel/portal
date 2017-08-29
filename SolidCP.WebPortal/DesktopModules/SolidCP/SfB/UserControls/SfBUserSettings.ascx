<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SfBUserSettings.ascx.cs" Inherits="SolidCP.Portal.SfB.UserControls.SfBUserSettings" %>
<%@ Register Src="../../ExchangeServer/UserControls/EmailAddress.ascx" TagName="EmailAddress" TagPrefix="scp" %>
<asp:DropDownList ID="ddlSipAddresses" runat="server" CssClass="NormalTextBox"></asp:DropDownList>
<scp:EmailAddress id="email" runat="server" ValidationGroup="CreateMailbox"></scp:EmailAddress>

