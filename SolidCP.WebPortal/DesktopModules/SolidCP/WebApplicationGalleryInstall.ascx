﻿<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="WebApplicationGalleryInstall.ascx.cs" Inherits="SolidCP.Portal.WebApplicationGalleryInstall" %>
<%@ Register Src="UserControls/PasswordControl.ascx" TagName="PasswordControl" TagPrefix="uc3" %>
<%@ Register Src="UserControls/UsernameControl.ascx" TagName="UsernameControl" TagPrefix="uc2" %>
<%@ Register TagPrefix="scp" TagName="CollapsiblePanel" Src="UserControls/CollapsiblePanel.ascx" %>
<%@ Register Src="UserControls/EnableAsyncTasksSupport.ascx" TagName="EnableAsyncTasksSupport" TagPrefix="scp" %>
<%@ Register src="WebApplicationGalleryHeader.ascx" tagname="WebApplicationGalleryHeader" tagprefix="uc1" %>
<%@ Register Src="UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="uc1" %>
    
<scp:EnableAsyncTasksSupport id="asyncTasks" runat="server"/>
<div class="FormBody">

    <uc1:SimpleMessageBox ID="messageBox" runat="server" />
     		
    <uc1:WebApplicationGalleryHeader ID="appHeader" runat="server" />
    
    <asp:CheckBox ID="chIgnoreDependencies" runat="server"  
        Text="Ignore dependency fail and install selected product anyway."  Visible="false" AutoPostBack="True" 
        oncheckedchanged="chIgnoreDependencies_CheckedChanged" />
        

</div>
<div class="FormFooter">
    <asp:Button ID="btnInstall" runat="server" meta:resourcekey="btnInstall" Text="Install" CssClass="Button1" OnClick="btnInstall_Click" OnClientClick="ShowProgressDialog('Installing application...');"/>
    <asp:Button ID="btnCancel" runat="server" meta:resourcekey="btnCancel" Text="Cancel" CssClass="Button1" CausesValidation="false" OnClick="btnCancel_Click" />
</div>