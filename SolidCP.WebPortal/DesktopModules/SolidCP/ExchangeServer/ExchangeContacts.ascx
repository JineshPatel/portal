<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ExchangeContacts.ascx.cs" Inherits="SolidCP.Portal.ExchangeServer.ExchangeContacts" %>
<%@ Register Src="../UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="scp" %>
<%@ Register Src="../UserControls/QuotaViewer.ascx" TagName="QuotaViewer" TagPrefix="scp" %>
<%@ Register Src="../UserControls/EnableAsyncTasksSupport.ascx" TagName="EnableAsyncTasksSupport" TagPrefix="scp" %>

<scp:EnableAsyncTasksSupport id="asyncTasks" runat="server"/>

<div id="ExchangeContainer">
	<div class="Module">
		<div class="Left">
		</div>
		<div class="Content">
			<div class="Center">
				<div class="Title">
					<asp:Image ID="Image1" SkinID="ExchangeContact48" runat="server" />
					<asp:Localize ID="locTitle" runat="server" meta:resourcekey="locTitle" Text="Contact"></asp:Localize>
				</div>
				
				<div class="FormBody">
				    <scp:SimpleMessageBox id="messageBox" runat="server" />
                    <div class="FormButtonsBarClean">
                        <div class="FormButtonsBarCleanLeft">
                            <asp:Button ID="btnCreateContact" runat="server" meta:resourcekey="btnCreateContact"
                            Text="Create New Contact" CssClass="Button1" OnClick="btnCreateContact_Click" />
                        </div>
                        <div class="FormButtonsBarCleanRight">
                            <asp:Panel ID="SearchPanel" runat="server" DefaultButton="cmdSearch">
                            <asp:Localize ID="locSearch" runat="server" meta:resourcekey="locSearch" Visible="false"></asp:Localize>
                                <asp:DropDownList ID="ddlPageSize" runat="server" AutoPostBack="True"    
                                       onselectedindexchanged="ddlPageSize_SelectedIndexChanged">   
                                       <asp:ListItem>10</asp:ListItem>   
                                       <asp:ListItem Selected="True">20</asp:ListItem>   
                                       <asp:ListItem>50</asp:ListItem>   
                                       <asp:ListItem>100</asp:ListItem>   
                                </asp:DropDownList> 

                                <asp:DropDownList ID="ddlSearchColumn" runat="server" CssClass="NormalTextBox">
                                    <asp:ListItem Value="DisplayName" meta:resourcekey="ddlSearchColumnDisplayName">DisplayName</asp:ListItem>
                                    <asp:ListItem Value="PrimaryEmailAddress" meta:resourcekey="ddlSearchColumnEmail">Email</asp:ListItem>
                                </asp:DropDownList><asp:TextBox ID="txtSearchValue" runat="server" CssClass="NormalTextBox" Width="100"></asp:TextBox><asp:ImageButton ID="cmdSearch" Runat="server" meta:resourcekey="cmdSearch" SkinID="SearchButton"
		                            CausesValidation="false"/>
                            </asp:Panel>
                        </div>
                    </div>

				    <asp:GridView ID="gvContacts" runat="server" AutoGenerateColumns="False" EnableViewState="true"
					    Width="100%" EmptyDataText="gvContacts" CssSelectorClass="NormalGridView"
					    OnRowCommand="gvContacts_RowCommand" AllowPaging="True" AllowSorting="True"
					    DataSourceID="odsAccountsPaged" PageSize="20">
					    <Columns>
						    <asp:TemplateField HeaderText="gvContactsDisplayName" SortExpression="DisplayName">
							    <ItemStyle Width="50%"></ItemStyle>
							    <ItemTemplate>
								    <asp:hyperlink id="lnk1" runat="server"
									    NavigateUrl='<%# GetContactEditUrl(Eval("AccountId").ToString()) %>'>
									    <%# Eval("DisplayName") %>
								    </asp:hyperlink>
							    </ItemTemplate>
						    </asp:TemplateField>
						    <asp:BoundField HeaderText="gvContactsEmail" DataField="PrimaryEmailAddress" SortExpression="PrimaryEmailAddress" ItemStyle-Width="50%" />
						    <asp:TemplateField>
							    <ItemTemplate>
								    <asp:ImageButton ID="cmdDelete" runat="server" Text="Delete" SkinID="ExchangeDelete"
									    CommandName="DeleteItem" CommandArgument='<%# Eval("AccountId") %>'
									    meta:resourcekey="cmdDelete" OnClientClick="return confirm('Remove this item?');"></asp:ImageButton>
							    </ItemTemplate>
						    </asp:TemplateField>
					    </Columns>
				    </asp:GridView>
					<asp:ObjectDataSource ID="odsAccountsPaged" runat="server" EnablePaging="True"
							SelectCountMethod="GetExchangeAccountsPagedCount"
							SelectMethod="GetExchangeAccountsPaged"
							SortParameterName="sortColumn"
							TypeName="SolidCP.Portal.ExchangeHelper"
							OnSelected="odsAccountsPaged_Selected">
						<SelectParameters>
							<asp:QueryStringParameter Name="itemId" QueryStringField="ItemID" DefaultValue="0" />
							<asp:Parameter Name="accountTypes" DefaultValue="2" />
							<asp:ControlParameter Name="filterColumn" ControlID="ddlSearchColumn" PropertyName="SelectedValue" />
							<asp:ControlParameter Name="filterValue" ControlID="txtSearchValue" PropertyName="Text" />
						</SelectParameters>
					</asp:ObjectDataSource>
				    <br />
				    <asp:Localize ID="locQuota" runat="server" meta:resourcekey="locQuota" Text="Total Contacts Created:"></asp:Localize>
				    &nbsp;&nbsp;&nbsp;
				    <scp:QuotaViewer ID="contactsQuota" runat="server" QuotaTypeId="2" />
				    
				    
				</div>
			</div>
		</div>
	</div>
</div>