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
using System.Management;
using System.Collections.Generic;
using System.Text;
using Microsoft.Win32;

using SolidCP.Server.Utils;
using SolidCP.Providers.Utils;
using System.Collections;

namespace SolidCP.Providers.DNS
{
    public class MsDNS : HostingServiceProviderBase, IDnsServer
    {
        #region Properties
        protected int ExpireLimit
        {
            get { return ProviderSettings.GetInt("ExpireLimit"); }
        }

        protected int MinimumTTL
        {
            get { return ProviderSettings.GetInt("MinimumTTL"); }
        }

        protected int RefreshInterval
        {
            get { return ProviderSettings.GetInt("RefreshInterval"); }
        }

        protected int RetryDelay
        {
            get { return ProviderSettings.GetInt("RetryDelay"); }
        }

        protected bool AdMode
        {
            get { return ProviderSettings.GetBool("AdMode"); }
        }
        #endregion

        private DNSCMDWrapper dnsCmd = null;
        private bool bulkRecords;

        public MsDNS()
        {
            if (IsDNSInstalled())
            {
                // creare WMI helper
                dnsCmd = new DNSCMDWrapper(".");
            }
        }


        #region Zones
        /// <summary>
        /// Supports managed resources disposal
        /// </summary>
        /// <returns></returns>
        public virtual string[] GetZones()
        {
            return dnsCmd.EnumZones();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="zoneName"></param>
        /// <returns></returns>
        /// <remarks>Supports managed resources disposal</remarks>
        public virtual bool ZoneExists(string zoneName)
        {
            using (RegistryKey root = Registry.LocalMachine)
            {
                using (RegistryKey rk = root.OpenSubKey("Software\\Microsoft\\Windows NT\\CurrentVersion\\DNS Server\\Zones\\" + zoneName))
                {
                    return (rk != null);
                }
            }
        }

        /// <summary>
        /// Supports managed resources disposal
        /// </summary>
        /// <param name="zoneName"></param>
        /// <returns></returns>

        public virtual DnsRecord[] GetZoneRecords(string zoneName)
        {
            List<Hashtable> rrsA = this.dnsCmd.EnumRecords(zoneName, "A");
            List<Hashtable> rrsAAAA = this.dnsCmd.EnumRecords(zoneName, "AAAA");
            List<Hashtable> rrsCNAME = this.dnsCmd.EnumRecords(zoneName, "CNAME");
            List<Hashtable> rrsMX = this.dnsCmd.EnumRecords(zoneName, "MX");
            List<Hashtable> rrsNS = this.dnsCmd.EnumRecords(zoneName, "NS");
            List<Hashtable> rrsTXT = this.dnsCmd.EnumRecords(zoneName, "TXT");
            List<Hashtable> rrsTXT_domainkey = this.dnsCmd.EnumRecords(zoneName, "TXT", "_domainkey");
            List<Hashtable> rrsSRV = this.dnsCmd.EnumRecords(zoneName, "SRV");
            List<Hashtable> rrsSRV_tcp = this.dnsCmd.EnumRecords(zoneName, "SRV", "_tcp");
            List<Hashtable> rrsSRV_udp = this.dnsCmd.EnumRecords(zoneName, "SRV", "_udp");
            List<Hashtable> rrsSRV_tls = this.dnsCmd.EnumRecords(zoneName, "SRV", "_tls");


            List<DnsRecord> records = new List<DnsRecord>();
            DnsRecord record = new DnsRecord();

            foreach (Hashtable rr in rrsA)
            {
                record = new DnsRecord();
                record.RecordType = DnsRecordType.A;
                record.RecordName = (string)rr["Name"];
                record.RecordData = (string)rr["Data"];
                records.Add(record);
            }

            foreach (Hashtable rr in rrsAAAA)
            {
                record = new DnsRecord();
                record.RecordType = DnsRecordType.AAAA;
                record.RecordName = (string)rr["Name"];
                record.RecordData = (string)rr["Data"];
                records.Add(record);
            }

            foreach (Hashtable rr in rrsCNAME)
            {
                record = new DnsRecord();
                record.RecordType = DnsRecordType.CNAME;
                record.RecordName = (string)rr["Name"];
                record.RecordData = RemoveTrailingDot((string)rr["Data"]);
                records.Add(record);
            }

            foreach (Hashtable rr in rrsMX)
            {
                record = new DnsRecord();
                record.RecordType = DnsRecordType.MX;
                record.RecordName = (string)rr["Name"];
                record.RecordData = RemoveTrailingDot((string)rr["MailExchange"]);
                record.MxPriority = Convert.ToInt32((string)rr["Preference"]);
                records.Add(record);
            }

            foreach (Hashtable rr in rrsNS)
            {
                record = new DnsRecord();
                record.RecordType = DnsRecordType.NS;
                record.RecordName = (string)rr["Name"];
                record.RecordData = RemoveTrailingDot((string)rr["NSHost"]);
                records.Add(record);
            }

            foreach (Hashtable rr in rrsTXT)
            {
                record = new DnsRecord();
                record.RecordType = DnsRecordType.TXT;
                record.RecordName = (string)rr["Name"];
                record.RecordData = (string)rr["Data"];
                records.Add(record);
            }
            foreach (Hashtable rr in rrsTXT_domainkey)
            {
                record = new DnsRecord();
                record.RecordType = DnsRecordType.TXT;
                record.RecordName = (string)rr["Name"];
                record.RecordData = (string)rr["Data"];
                records.Add(record);
            }

            foreach (Hashtable rr in rrsSRV)
            {
                record = new DnsRecord();
                record.RecordType = DnsRecordType.SRV;
                record.RecordName = (string)rr["Name"];
                record.SrvPriority = Convert.ToInt32(rr["Priority"]);
                record.SrvWeight = Convert.ToInt32(rr["Weight"]);
                record.SrvPort = Convert.ToInt32(rr["Port"]);
                record.RecordData = RemoveTrailingDot((string)rr["Data"]);
                records.Add(record);
            }

            foreach (Hashtable rr in rrsSRV_tcp)
            {
                record = new DnsRecord();
                record.RecordType = DnsRecordType.SRV;
                record.RecordName = (string)rr["Name"];
                record.SrvPriority = Convert.ToInt32(rr["Priority"]);
                record.SrvWeight = Convert.ToInt32(rr["Weight"]);
                record.SrvPort = Convert.ToInt32(rr["Port"]);
                record.RecordData = RemoveTrailingDot((string)rr["Data"]);
                records.Add(record);
            }

            foreach (Hashtable rr in rrsSRV_udp)
            {
                record = new DnsRecord();
                record.RecordType = DnsRecordType.SRV;
                record.RecordName = (string)rr["Name"];
                record.SrvPriority = Convert.ToInt32(rr["Priority"]);
                record.SrvWeight = Convert.ToInt32(rr["Weight"]);
                record.SrvPort = Convert.ToInt32(rr["Port"]);
                record.RecordData = RemoveTrailingDot((string)rr["Data"]);
                records.Add(record);
            }

            foreach (Hashtable rr in rrsSRV_tls)
            {
                record = new DnsRecord();
                record.RecordType = DnsRecordType.SRV;
                record.RecordName = (string)rr["Name"];
                record.SrvPriority = Convert.ToInt32(rr["Priority"]);
                record.SrvWeight = Convert.ToInt32(rr["Weight"]);
                record.SrvPort = Convert.ToInt32(rr["Port"]);
                record.RecordData = RemoveTrailingDot((string)rr["Data"]);
                records.Add(record);
            }


            return records.ToArray();
        }


        private string RemoveTrailingDot(string str)
        {
            return (str.EndsWith(".")) ? str.Substring(0, str.Length - 1) : str;
        }

        private string CorrectHost(string zoneName, string host)
        {
            if (host.ToLower() == zoneName.ToLower())
                return "";
            else
                return host.Substring(0, (host.Length - zoneName.Length - 1));
        }

        //private ManagementObject GetZone(string zoneName)
        //{
        //    ManagementObject objZone = null;

        //    try
        //    {

        //        objZone = dnsCmd.GetObject(String.Format(
        //            "MicrosoftDNS_Zone.ContainerName='{0}',DnsServerName='{1}',Name='{2}'",
        //            zoneName, System.Net.Dns.GetHostEntry("LocalHost").HostName, zoneName));
        //        objZone.Get();

        //        /*
        //        objZone = wmi.GetWmiObject("MicrosoftDNS_Zone", "ContainerName = '{0}' AND DnsServerName = '{1}' AND Name = '{2}'",
        //            new object[] { zoneName, System.Net.Dns.GetHostEntry("LocalHost").HostName, zoneName });
        //         */
        //    }
        //    catch (Exception ex)
        //    {
        //        objZone = null;
        //        Log.WriteError("Could not get DNS Zone", ex);
        //    }

        //    return objZone;
        //}

        /// <summary>
        /// 
        /// </summary>
        /// <param name="zoneName"></param>
        /// <param name="secondaryServers"></param>
        /// <remarks>Supports managed resources disposal</remarks>
        public virtual void AddPrimaryZone(string zoneName, string[] secondaryServers)
        {
            if (ZoneExists(zoneName))
            {
                return;
            }

            // Create the zone.
            this.dnsCmd.ZoneAdd(zoneName, "primary", null, AdMode);

            // Update zone transfers settings.
            if (secondaryServers == null || secondaryServers.Length == 0)
            {
                // Transfers are not allowed.
                this.dnsCmd.ZoneResetSecondaries(zoneName, "off", null);
            }
            else if (secondaryServers.Length == 1 && secondaryServers[0] == "*")
            {
                // Transfers are allowed from all servers.
                this.dnsCmd.ZoneResetSecondaries(zoneName, "all", null);
            }
            else
            {
                // Transfers are allowed only from specified servers.
                this.dnsCmd.ZoneResetSecondaries(zoneName, "list", secondaryServers);
            }
        }

        /// <summary>
        /// Supports managed resources disposal
        /// </summary>
        /// <param name="zoneName"></param>
        /// <param name="masterServers"></param>
        public virtual void AddSecondaryZone(string zoneName, string[] masterServers)
        {
            if (ZoneExists(zoneName))
            {
                return;
            }

            // Create the zone.
            this.dnsCmd.ZoneAdd(zoneName, "secondary", masterServers, AdMode);

            // Reload the zone.
            this.dnsCmd.ZoneReload(zoneName);
        }

        /// <summary>
        /// Supports managed resources disposal
        /// </summary>
        /// <param name="zoneName"></param>

        public virtual void DeleteZone(string zoneName)
        {
            if (!ZoneExists(zoneName))
            {
                return;
            }

            this.dnsCmd.ZoneDelete(zoneName, AdMode);
        }


        public virtual void AddZoneRecord(string zoneName, DnsRecord record)
        {
            try
            {
                switch (record.RecordType)
                {
                    case DnsRecordType.A:
                        this.dnsCmd.RecordAdd(zoneName, record.RecordName, MinimumTTL, "A", record.RecordData);
                        break;
                    case DnsRecordType.AAAA:
                        this.dnsCmd.RecordAdd(zoneName, record.RecordName, MinimumTTL, "AAAA", record.RecordData);
                        break;
                    case DnsRecordType.CNAME:
                        this.dnsCmd.RecordAdd(zoneName, record.RecordName, MinimumTTL, "CNAME", record.RecordData);
                        break;
                    case DnsRecordType.MX:
                        this.dnsCmd.RecordAdd(zoneName, record.RecordName, MinimumTTL, "MX", String.Format("{0} {1}", record.MxPriority, record.RecordData));
                        break;
                    case DnsRecordType.NS:
                        this.dnsCmd.RecordAdd(zoneName, record.RecordName, MinimumTTL, "NS", record.RecordData);
                        break;
                    case DnsRecordType.TXT:
                        this.dnsCmd.RecordAdd(zoneName, record.RecordName, MinimumTTL, "TXT", record.RecordData);
                        break;
                    case DnsRecordType.SRV:
                        this.dnsCmd.RecordAdd(
                            zoneName,
                            record.RecordName,
                            MinimumTTL,
                            "SRV",
                            String.Format("{0} {1} {2} {3}", record.SrvPriority, record.SrvWeight, record.SrvPort, record.RecordData)
                        );
                        break;
                }

                if (this.bulkRecords)
                {
                    return;
                }

                UpdateSoaRecord(zoneName, null, null);
            }
            catch (Exception ex)
            {
                Log.WriteError(ex);
            }
        }

        public virtual void AddZoneRecords(string zoneName, DnsRecord[] records)
        {
            this.bulkRecords = true;

            foreach (DnsRecord record in records)
            {
                AddZoneRecord(zoneName, record);
            }

            UpdateSoaRecord(zoneName, null, null);
        }

        public virtual void DeleteZoneRecord(string zoneName, DnsRecord record)
        {
            switch (record.RecordType)
            {
                case DnsRecordType.A:
                    this.dnsCmd.RecordDelete(zoneName, record.RecordName, "A", record.RecordData);
                    break;
                case DnsRecordType.AAAA:
                    this.dnsCmd.RecordDelete(zoneName, record.RecordName, "AAAA", record.RecordData);
                    break;
                case DnsRecordType.CNAME:
                    this.dnsCmd.RecordDelete(zoneName, record.RecordName, "CNAME", record.RecordData);
                    break;
                case DnsRecordType.MX:
                    this.dnsCmd.RecordDelete(zoneName, record.RecordName, "MX", String.Format("{0} {1}", record.MxPriority, record.RecordData));
                    break;
                case DnsRecordType.NS:
                    this.dnsCmd.RecordDelete(zoneName, record.RecordName, "NS", record.RecordData);
                    break;
                case DnsRecordType.TXT:
                    this.dnsCmd.RecordDelete(zoneName, record.RecordName, "TXT", record.RecordData);
                    break;
                case DnsRecordType.SRV:
                    this.dnsCmd.RecordDelete(
                        zoneName,
                        record.RecordName,
                        "SRV",
                        String.Format("{0} {1} {2} {3}", record.SrvPriority, record.SrvWeight, record.SrvPort, record.RecordData)
                    );
                    break;
            }
        }

        public virtual void DeleteZoneRecords(string zoneName, DnsRecord[] records)
        {
            foreach (DnsRecord record in records)
                DeleteZoneRecord(zoneName, record);
        }

       
        #endregion

        #region SOA Record
        /// <summary>
        /// Updates the SOA record for a given DNS zone.
        /// </summary>
        /// <param name="zoneName"></param>
        /// <param name="host"></param>
        /// <param name="primaryNsServer"></param>
        /// <param name="primaryPerson"></param>
        public virtual void UpdateSoaRecord(string zoneName, string host, string primaryNsServer, string primaryPerson)
        {
            this.UpdateSoaRecord(zoneName, primaryNsServer, primaryPerson);
        }
        public virtual void UpdateSoaRecord(string zoneName, string primaryNsServer,
            string primaryPerson)
        {
            // Get the existing SOA record in order to read the serial number.
            List<Hashtable> recList = this.dnsCmd.EnumRecords(zoneName, "SOA");
            Hashtable soaRec = recList[0];

            // Update the serial number.
            string sn = soaRec["SerialNumber"].ToString();
            UInt32 serialNumber = UInt32.Parse(sn);
            string todayDate = DateTime.Now.ToString("yyyyMMdd");

            if (sn.Length < 10 || !sn.StartsWith(todayDate))
            {
                // Build a new serial number.
                sn = todayDate + "01";
                serialNumber = UInt32.Parse(sn);
            }
            else
            {
                // Increment the existing serial number.
                serialNumber += 1;
            }

            // Check if we have to change the primary server or the responsible person.
            string primSrv = (!String.IsNullOrEmpty(primaryNsServer)) ? primaryNsServer : this.RemoveTrailingDot(soaRec["PrimaryServer"].ToString());
            string primPer = (!String.IsNullOrEmpty(primaryPerson)) ? primaryPerson : this.RemoveTrailingDot(soaRec["ResponsibleParty"].ToString());

            // Update the record.
            string recData = String.Format("{0} {1} {2} {3} {4} {5} {6}",
                primSrv,
                primPer,
                serialNumber,
                RefreshInterval,
                RetryDelay,
                ExpireLimit,
                MinimumTTL
            );

            this.dnsCmd.RecordAdd(zoneName, "@", MinimumTTL, "SOA", recData);
        }

        /// <summary>
        /// Supports managed resources disposal
        /// </summary>
        /// <param name="zoneName"></param>
        private void DeleteSoaRecord(string zoneName)
        {
            //string query = String.Format("SELECT * FROM MicrosoftDNS_SOAType " +
            //    "WHERE OwnerName = '{0}'",
            //    zoneName);
            //using (ManagementObjectCollection objRRs = dnsCmd.ExecuteQuery(query))
            //{
            //    foreach (ManagementObject objRR in objRRs) using (objRR)
            //            objRR.Delete();
            //}
        }

        private string GetSoaRecordText(string host, string primaryNsServer,
            string primaryPerson)
        {
            return String.Format("{0} IN SOA {1} {2} 1 900 600 86400 3600", host,
                primaryNsServer, primaryPerson);
        }

        /// <summary>
        /// Supports managed resources disposal
        /// </summary>
        /// <param name="zoneName"></param>

        //private void UpdateSoaRecord(string zoneName)
        //{
        //    // get existing SOA record in order to read serial number

        //    try
        //    {

        //        //ManagementObject obj = GetWmiObject("MicrosoftDNS_Zone", "ContainerName = '{0}'", zoneName);
        //        //ManagementObject objSoa = GetRelatedWmiObject(obj, "MicrosoftDNS_SOAType");


        //        ManagementObject objSoa = wmi.GetWmiObject("MicrosoftDNS_SOAType", "ContainerName = '{0}'", RemoveTrailingDot(zoneName));

        //        if (objSoa != null)
        //        {
        //            if (objSoa.Properties["OwnerName"].Value.Equals(zoneName))
        //            {
        //                string primaryServer = (string)objSoa.Properties["PrimaryServer"].Value;
        //                string responsibleParty = (string)objSoa.Properties["ResponsibleParty"].Value;
        //                UInt32 serialNumber = (UInt32)objSoa.Properties["SerialNumber"].Value;

        //                // update record's serial number
        //                string sn = serialNumber.ToString();
        //                string todayDate = DateTime.Now.ToString("yyyyMMdd");
        //                if (sn.Length < 10 || !sn.StartsWith(todayDate))
        //                {
        //                    // build a new serial number
        //                    sn = todayDate + "01";
        //                    serialNumber = UInt32.Parse(sn);
        //                }
        //                else
        //                {
        //                    // just increment serial number
        //                    serialNumber += 1;
        //                }

        //                // update SOA record
        //                using (ManagementBaseObject methodParams = objSoa.GetMethodParameters("Modify"))
        //                {
        //                    methodParams["ResponsibleParty"] = responsibleParty;
        //                    methodParams["PrimaryServer"] = primaryServer;
        //                    methodParams["SerialNumber"] = serialNumber;

        //                    methodParams["ExpireLimit"] = ExpireLimit;
        //                    methodParams["MinimumTTL"] = MinimumTTL;
        //                    methodParams["TTL"] = MinimumTTL;
        //                    methodParams["RefreshInterval"] = RefreshInterval;
        //                    methodParams["RetryDelay"] = RetryDelay;

        //                    ManagementBaseObject outParams = objSoa.InvokeMethod("Modify", methodParams, null);
        //                }
        //                //
        //                objSoa.Dispose();
        //            }

        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        Log.WriteError(ex);
        //    }
        //}

        #endregion

        

        #region IHostingServiceProvier methods
        public override void DeleteServiceItems(ServiceProviderItem[] items)
        {
            foreach (ServiceProviderItem item in items)
            {
                if (item is DnsZone)
                {
                    try
                    {
                        // delete DNS zone
                        DeleteZone(item.Name);
                    }
                    catch (Exception ex)
                    {
                        Log.WriteError(String.Format("Error deleting '{0}' MS DNS zone", item.Name), ex);
                    }
                }
            }
        }

        /// <summary>
        /// Supports managed resources disposal
        /// </summary>
        /// <returns></returns>
        protected bool IsDNSInstalled()
        {
            using (RegistryKey root = Registry.LocalMachine)
            {
                using (RegistryKey key = root.OpenSubKey("SYSTEM\\CurrentControlSet\\Services\\DNS"))
                {
                    bool res = key != null;
                    if (key != null)
                        key.Close();

                    return res;
                }
            }
        }

        public override bool IsInstalled()
        {
            return IsDNSInstalled();
        }

        #endregion
    }
}
