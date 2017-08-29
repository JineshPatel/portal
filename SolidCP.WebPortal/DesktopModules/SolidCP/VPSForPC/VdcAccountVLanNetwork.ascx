<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="VdcAccountVLanNetwork.ascx.cs"
    Inherits="SolidCP.Portal.VPSForPC.VdcAccountVLanNetwork" %>
<%@ Register Src="UserControls/Menu.ascx" TagName="Menu" TagPrefix="scp" %>
<%@ Register Src="UserControls/Breadcrumb.ascx" TagName="Breadcrumb" TagPrefix="scp" %>
<div id="VpsContainer">
    <div class="Module">
        <div class="Header">
            <scp:Breadcrumb id="breadcrumb" runat="server" />
        </div>
        <div class="Left">
            <scp:Menu id="menu" runat="server" SelectedItem="vdc_account_vlan_network" />
        </div>
        <div class="Content">
            <div class="Center">
                <div class="Title">
                    <asp:Image ID="Image1" SkinID="VLanNetwork" runat="server" />
                    <asp:Localize ID="locTitle" runat="server" meta:resourcekey="locTitle" Text="Available VLans"></asp:Localize>
                </div>
                <div class="FormBody">
                    <asp:Button ID="btnAddVlan" runat="server" meta:resourcekey="btnAddVlan" Text="Add"
                        CssClass="Button1" OnClick="btnAddVlan_Click" />
                    <br />
                    <asp:GridView ID="gvVlans" runat="server" AutoGenerateColumns="false" CssSelectorClass="NormalGridView"
                        EmptyDataText="User has no VLANs" OnRowCommand="gvVlans_RowCommand">
                        <Columns>
                            <asp:BoundField DataField="VLanID" HeaderText="VLan" />
                            <asp:BoundField DataField="Comment" HeaderText="Comment" ItemStyle-Wrap="true" />
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <asp:ImageButton ID="cmdDelete" runat="server" Text="Delete" SkinID="VpsDelete" CommandName="DeleteItem"
                                        CommandArgument='<%# Eval("VLanID") %>' meta:resourcekey="cmdDelete" OnClientClick="return confirm('Remove this item?');" />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
            <div class="Right">
                <asp:Localize ID="FormComments" runat="server" meta:resourcekey="FormComments"></asp:Localize>
            </div>
        </div>
    </div>
</div>
