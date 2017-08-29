// Copyright (c) 2016, SolidCP
// SolidCP is distributed under the Creative Commons Share-alike license
// 
// SolidCP is a fork of WebsitePanel:
// Copyright (c) 2015, Outercurve Foundation.
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//
// - Redistributions of source code must  retain  the  above copyright notice, this
//   list of conditions and the following disclaimer.
//
// - Redistributions in binary form  must  reproduce the  above  copyright  notice,
//   this list of conditions  and  the  following  disclaimer in  the documentation
//   and/or other materials provided with the distribution.
//
// - Neither  the  name  of  the  Outercurve Foundation  nor   the   names  of  its
//   contributors may be used to endorse or  promote  products  derived  from  this
//   software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,  BUT  NOT  LIMITED TO, THE IMPLIED
// WARRANTIES  OF  MERCHANTABILITY   AND  FITNESS  FOR  A  PARTICULAR  PURPOSE  ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
// ANY DIRECT, INDIRECT, INCIDENTAL,  SPECIAL,  EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO,  PROCUREMENT  OF  SUBSTITUTE  GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)  HOWEVER  CAUSED AND ON
// ANY  THEORY  OF  LIABILITY,  WHETHER  IN  CONTRACT,  STRICT  LIABILITY,  OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE)  ARISING  IN  ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using SolidCP.EnterpriseServer.Base.Common;
using SCP = SolidCP.EnterpriseServer;
using System.Text.RegularExpressions;

namespace SolidCP.Portal
{
	public partial class SystemSettings : SolidCPModuleBase
	{
		public const string SMTP_SERVER = "SmtpServer";
		public const string SMTP_PORT = "SmtpPort";
		public const string SMTP_USERNAME = "SmtpUsername";
		public const string SMTP_PASSWORD = "SmtpPassword";
		public const string SMTP_ENABLE_SSL = "SmtpEnableSsl";
		public const string BACKUPS_PATH = "BackupsPath";
        public const string FILE_MANAGER_EDITABLE_EXTENSIONS = "EditableExtensions";
        public const string RDS_MAIN_CONTROLLER = "RdsMainController";
        public const string WEBDAV_PORTAL_URL = "WebdavPortalUrl";
        public const string WEBDAV_PASSWORD_RESET_ENABLED = "WebdavPasswordResetEnabled";

        /*
        public const string FEED_ENABLE_MICROSOFT = "FeedEnableMicrosoft";
        public const string FEED_ENABLE_HELICON = "FeedEnableHelicon";
        */

		protected void Page_Load(object sender, EventArgs e)
		{
			if (!IsPostBack)
			{
				try
				{
					LoadSettings();
				}
				catch (Exception ex)
				{
					ShowErrorMessage("SYSTEM_SETTINGS_LOAD", ex);
				}
			}
		}

		private void LoadSettings()
		{
			// SMTP
			SCP.SystemSettings settings = ES.Services.System.GetSystemSettings(
				SCP.SystemSettings.SMTP_SETTINGS);

			if (settings != null)
			{
				txtSmtpServer.Text = settings[SMTP_SERVER];
				txtSmtpPort.Text = settings[SMTP_PORT];
				txtSmtpUser.Text = settings[SMTP_USERNAME];
				chkEnableSsl.Checked = Utils.ParseBool(settings[SMTP_ENABLE_SSL], false);
			}

			// BACKUP
			settings = ES.Services.System.GetSystemSettings(
				SCP.SystemSettings.BACKUP_SETTINGS);

			if (settings != null)
			{
				txtBackupsPath.Text = settings["BackupsPath"];
			}

            
            // WPI
            settings = ES.Services.System.GetSystemSettings(SCP.SystemSettings.WPI_SETTINGS);

            /*
            if (settings != null)
            {
                wpiMicrosoftFeed.Checked = Utils.ParseBool(settings[FEED_ENABLE_MICROSOFT],true);
                wpiHeliconTechFeed.Checked = Utils.ParseBool(settings[FEED_ENABLE_HELICON],true);
            }
            else
            {
                wpiMicrosoftFeed.Checked = true;
                wpiHeliconTechFeed.Checked = true;
            }
            */

            if (null != settings)
            {
                wpiEditFeedsList.Value = settings[SCP.SystemSettings.FEED_ULS_KEY];

                string mainFeedUrl = settings[SCP.SystemSettings.WPI_MAIN_FEED_KEY];
                if (string.IsNullOrEmpty(mainFeedUrl))
                {
                    mainFeedUrl = WebPlatformInstaller.MAIN_FEED_URL;
                }
                txtMainFeedUrl.Text = mainFeedUrl;
            }
     
            // FILE MANAGER
            settings = ES.Services.System.GetSystemSettings(SCP.SystemSettings.FILEMANAGER_SETTINGS);

            if (settings != null && !String.IsNullOrEmpty(settings[FILE_MANAGER_EDITABLE_EXTENSIONS]))
            {
                txtFileManagerEditableExtensions.Text = settings[FILE_MANAGER_EDITABLE_EXTENSIONS].Replace(",", System.Environment.NewLine);
            }
            else
            {
                // Original SolidCP Extensions
                txtFileManagerEditableExtensions.Text = FileManager.ALLOWED_EDIT_EXTENSIONS.Replace(",", System.Environment.NewLine);
            }

            // RDS
            var services = ES.Services.RDS.GetRdsServices();

            foreach(var service in services)
            {
                ddlRdsController.Items.Add(new ListItem(service.ServiceName, service.ServiceId.ToString()));
            }

            settings = ES.Services.System.GetSystemSettings(SCP.SystemSettings.RDS_SETTINGS);

            if (settings != null && !string.IsNullOrEmpty(settings[RDS_MAIN_CONTROLLER]))
            {
                ddlRdsController.SelectedValue = settings[RDS_MAIN_CONTROLLER];
            }
            else if (ddlRdsController.Items.Count > 0)
            {
                ddlRdsController.SelectedValue = ddlRdsController.Items[0].Value;
            }

            // Webdav portal
            settings = ES.Services.System.GetSystemSettings(SCP.SystemSettings.WEBDAV_PORTAL_SETTINGS);

            if (settings != null)
            {
                chkEnablePasswordReset.Checked = Utils.ParseBool(settings[SCP.SystemSettings.WEBDAV_PASSWORD_RESET_ENABLED_KEY], false);
                txtWebdavPortalUrl.Text = settings[WEBDAV_PORTAL_URL];
                txtPasswordResetLinkLifeSpan.Text = settings[SCP.SystemSettings.WEBDAV_PASSWORD_RESET_LINK_LIFE_SPAN];

                chkEnableOwa.Checked = Utils.ParseBool(settings[SCP.SystemSettings.WEBDAV_OWA_ENABLED_KEY], false);
                txtOwaUrl.Text = settings[SCP.SystemSettings.WEBDAV_OWA_URL];
            }

            // Twilio portal
            settings = ES.Services.System.GetSystemSettings(SCP.SystemSettings.TWILIO_SETTINGS);

            if (settings != null)
            {
                txtAccountSid.Text = settings.GetValueOrDefault(SCP.SystemSettings.TWILIO_ACCOUNTSID_KEY, string.Empty);
                txtAuthToken.Text = settings.GetValueOrDefault(SCP.SystemSettings.TWILIO_AUTHTOKEN_KEY, string.Empty);
                txtPhoneFrom.Text = settings.GetValueOrDefault(SCP.SystemSettings.TWILIO_PHONEFROM_KEY, string.Empty);
            }

            // Access IP Settings
            settings = ES.Services.System.GetSystemSettings(SCP.SystemSettings.ACCESS_IP_SETTINGS);

            if (settings != null)
            {
                txtIPAddress.Text = settings.GetValueOrDefault(SCP.SystemSettings.ACCESS_IPs, string.Empty); 
            }

        }

		private void SaveSettings()
		{
			try
			{
				SCP.SystemSettings settings = new SCP.SystemSettings();

				// SMTP
				settings[SMTP_SERVER] = txtSmtpServer.Text.Trim();
				settings[SMTP_PORT] = txtSmtpPort.Text.Trim();
				settings[SMTP_USERNAME] = txtSmtpUser.Text.Trim();
				settings[SMTP_PASSWORD] = txtSmtpPassword.Text;
				settings[SMTP_ENABLE_SSL] = chkEnableSsl.Checked.ToString();

				// SMTP
				int result = ES.Services.System.SetSystemSettings(
					SCP.SystemSettings.SMTP_SETTINGS, settings);

				if (result < 0)
				{
					ShowResultMessage(result);
					return;
				}

				// BACKUP
				settings = new SCP.SystemSettings();
				settings[BACKUPS_PATH] = txtBackupsPath.Text.Trim();

				result = ES.Services.System.SetSystemSettings(
					SCP.SystemSettings.BACKUP_SETTINGS, settings);

				if (result < 0)
				{
					ShowResultMessage(result);
					return;
				}



                // WPI
                /*
                settings[FEED_ENABLE_MICROSOFT] = wpiMicrosoftFeed.Checked.ToString();
                settings[FEED_ENABLE_HELICON] = wpiHeliconTechFeed.Checked.ToString();
                */

                settings[SCP.SystemSettings.FEED_ULS_KEY] = wpiEditFeedsList.Value;
			    string mainFeedUrl = txtMainFeedUrl.Text;
                if (string.IsNullOrEmpty(mainFeedUrl))
                {
                    mainFeedUrl = WebPlatformInstaller.MAIN_FEED_URL;
                }
			    settings[SCP.SystemSettings.WPI_MAIN_FEED_KEY] = mainFeedUrl;


                result = ES.Services.System.SetSystemSettings(SCP.SystemSettings.WPI_SETTINGS, settings);

                if (result < 0)
                {
                    ShowResultMessage(result);
                    return;
                }

                // FILE MANAGER
                settings = new SCP.SystemSettings();
                settings[FILE_MANAGER_EDITABLE_EXTENSIONS] = Regex.Replace(txtFileManagerEditableExtensions.Text, @"[\r\n]+", ",");


                result = ES.Services.System.SetSystemSettings(
                    SCP.SystemSettings.FILEMANAGER_SETTINGS, settings);

                if (result < 0)
                {
                    ShowResultMessage(result);
                    return;
                }

                settings = new SCP.SystemSettings();
                settings[RDS_MAIN_CONTROLLER] = ddlRdsController.SelectedValue;
                result = ES.Services.System.SetSystemSettings(SCP.SystemSettings.RDS_SETTINGS, settings);

                settings = new SCP.SystemSettings();
                settings[WEBDAV_PORTAL_URL] = txtWebdavPortalUrl.Text;
                settings[SCP.SystemSettings.WEBDAV_PASSWORD_RESET_ENABLED_KEY] = chkEnablePasswordReset.Checked.ToString();
                settings[SCP.SystemSettings.WEBDAV_PASSWORD_RESET_LINK_LIFE_SPAN] = txtPasswordResetLinkLifeSpan.Text;

                settings[SCP.SystemSettings.WEBDAV_OWA_ENABLED_KEY] = chkEnableOwa.Checked.ToString();
                settings[SCP.SystemSettings.WEBDAV_OWA_URL] = txtOwaUrl.Text;

                result = ES.Services.System.SetSystemSettings(SCP.SystemSettings.WEBDAV_PORTAL_SETTINGS, settings);

                if (result < 0)
                {
                    ShowResultMessage(result);
                    return;
                }

                // Twilio portal
                settings = new SCP.SystemSettings();
                settings[SCP.SystemSettings.TWILIO_ACCOUNTSID_KEY] = txtAccountSid.Text;
                settings[SCP.SystemSettings.TWILIO_AUTHTOKEN_KEY] = txtAuthToken.Text;
                settings[SCP.SystemSettings.TWILIO_PHONEFROM_KEY] = txtPhoneFrom.Text;
                result = ES.Services.System.SetSystemSettings(SCP.SystemSettings.TWILIO_SETTINGS, settings);

                if (result < 0)
                {
                    ShowResultMessage(result);
                    return;
                }

                //AccessIPs
                settings = new SCP.SystemSettings();
                settings[SCP.SystemSettings.ACCESS_IPs] = txtIPAddress.Text;
                 
                result = ES.Services.System.SetSystemSettings(SCP.SystemSettings.ACCESS_IP_SETTINGS, settings);

                if (result < 0)
                {
                    ShowResultMessage(result);
                    return;
                }
            }
			catch (Exception ex)
			{
				ShowErrorMessage("SYSTEM_SETTINGS_SAVE", ex);
				return;
			}

			ShowSuccessMessage("SYSTEM_SETTINGS_SAVE");
		}

		protected void btnSaveSettings_Click(object sender, EventArgs e)
		{
			SaveSettings();
		}
	}
}
