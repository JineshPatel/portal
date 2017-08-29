using System;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

namespace SolidCP.Server.Utils
{
   public class DNSCMDWrapper
    {
        private string dnsCmd = @"C:\Windows\System32\dnscmd.exe";
        private string curHost = null;
        private List<string> recTypes = new List<string> { "A", "CNAME", "MX", "NS", "SOA", "TXT", "AAAA", "SRV" };
        private List<string> srvRecProtocols = new List<string> { "_tcp", "_udp", "_tls" };

        /// <summary>
        /// Class constructor.
        /// </summary>
        /// <param name="host">The DNS server host (use "." for the local server).</param>
        public DNSCMDWrapper(string host)
        {
            this.curHost = host;
        }

        /// <summary>
        /// A wrapper method for dnscmd.exe /EnumZones command.
        /// </summary>
        /// <returns>Returns all the names of all PRIMARY zones.</param>
        public string[] EnumZones()
        {
            string[] zonesRaw = this.Run(this.dnsCmd, this.curHost + " /EnumZones /Primary");

            List<string> zones = new List<string>();
            foreach (string zone in zonesRaw)
            {
                if (zone.IndexOf("Primary") != -1)
                {
                    zones.Add(Regex.Split(zone.Trim(), @"\s+")[0]);
                }
            }

            return zones.ToArray();
        }

        /// <summary>
        /// A wrapper method for dnscmd.exe /EnumRecords command.
        /// </summary>
        /// <param name="zoneName">The DNS zone name.</param>
        /// <param name="type">What type of records to enumerate.</param>
        /// <param name="srvRecProto">Additional param that specifies protocol type for SRV records.</param>
        /// <returns>Returns the records as an list of hash tables.</param>
        public List<Hashtable> EnumRecords(string zoneName, string type, string srvRecProtocol = null)
        {
            string nodeName = "@"; // <-- Zone's root node.

            // Validate record type.
            if (!this.recTypes.Contains(type))
            {
                throw new Exception(String.Format("Invalid resource record type - '{0}'", type));
            }
            if (srvRecProtocol == "_domainkey")
            {
                nodeName = "_domainkey";
            }

            // Check if we have to query SRV records for a speciffic protocol.
            if (type == "SRV")
            {
                if (!String.IsNullOrEmpty(srvRecProtocol))
                {
                    if (!this.srvRecProtocols.Contains(srvRecProtocol))
                    {
                        throw new Exception(String.Format("Invalid SRV record protocol type - '{0}'", srvRecProtocol));
                    }

                    nodeName = srvRecProtocol;
                }
            }

            string[] recordsRaw;
            try
            {
                recordsRaw = this.Run(this.dnsCmd, String.Format("{0} /EnumRecords {1} {2} /Type {3}", this.curHost, zoneName, nodeName, type));
            }
            catch
            {
                // Catch dnscmd.exe errors caused by no SRV records for a given protocol.
                // Example: dnscmd.exe . /EnumRecords test.com _tcp /Type SRV will return
                // error instead of empty list if there is not such records.
                if (String.IsNullOrEmpty(srvRecProtocol))
                {
                    // This is NOT SRV record error, rethrow the exception.
                    throw;
                }

                recordsRaw = new string[4];
            }

            List<Hashtable> records = new List<Hashtable>();
            if (recordsRaw.Length == 4)
            {
                if (Log.DebugLog)
                {
                    string rType = String.IsNullOrEmpty(srvRecProtocol) ? type : type + srvRecProtocol;

                    Log.WriteLog(String.Format("No {0} records found.", rType));
                }

                // dnscmd.exe did not return any records of the specified type, return an empty list.
                return records;
            }

            // Convert each raw text results to hash table.
            string[] split, splitTxt;
            string temp, txtData = "", recName, currentName = "";
            foreach (string recRaw in recordsRaw)
            {
                if (recRaw.Contains(" " + type))
                { // <-- Filter only the payload lines.
                    if (Log.DebugLog) Log.WriteLog("recRaw:" + recRaw);

                    if (type == "TXT")
                    {
                        splitTxt = Regex.Split(recRaw, String.Format(@"\s{0}\t\t", type));
                        temp = splitTxt[0];
                        txtData = splitTxt[1];

                        if (Log.DebugLog) Log.WriteLog("txtData:" + txtData);
                    }
                    else
                    {
                        temp = Regex.Replace(recRaw, String.Format(@"\s{0}\t", type), " ");
                    }

                    split = temp.Split(' ');

                    if ((Regex.Match(split[0], @"^\t\t$")).Success)
                    {
                        // Two tab symbols at the start of the line mean "Current name is the same as the name of the previous record".
                        recName = currentName;
                    }
                    else
                    {
                        currentName = split[0];
                        recName = currentName;
                    }

                    if (recName == "@")
                    {
                        // Record is in zone's root, no need for record name.
                        recName = "";
                    }

                    if (!String.IsNullOrEmpty(srvRecProtocol))
                    {
                        // Append protocol to recName for SRV records.
                        recName += String.IsNullOrEmpty(recName) ? srvRecProtocol : ("." + srvRecProtocol);
                    }

                    Hashtable record = new Hashtable();
                    record.Add("Name", recName);
                    switch (type)
                    {
                        case "A":
                        case "AAAA":
                        case "CNAME":
                            record.Add("Data", split[2]);
                            break;
                        case "MX":
                            record.Add("MailExchange", split[3]);
                            record.Add("Preference", split[2]);
                            break;
                        case "NS":
                            record.Add("NSHost", split[2]);
                            break;
                        case "SOA":
                            record.Add("PrimaryServer", split[2]);
                            record.Add("ResponsibleParty", split[3]);
                            record.Add("SerialNumber", split[4]);
                            record.Add("RefreshInterval", split[5]);
                            record.Add("RetryDelay", split[6]);
                            record.Add("ExpireLimit", split[7]);
                            record.Add("MinimumTTL", split[8]);
                            break;
                        case "TXT":
                            record.Add("Data", txtData);
                            break;
                        case "SRV":
                            record.Add("Priority", split[2]);
                            record.Add("Weight", split[3]);
                            record.Add("Port", split[4]);
                            record.Add("Data", split[5]);
                            break;
                    }

                    records.Add(record);
                }
            }

            return records;
        }

        /// <summary>
        /// A wrapper method for dnscmd.exe /ZoneAdd command.
        /// </summary>
        /// <param name="zoneName">The DNS zone name.</param>
        /// <param name="zoneType">The DNS zone type.</param>
        /// <param name="masterServers">Array with IP addresses of the master servers (only for secondary zones).</param>
        /// <param name="integrated">Whether to add the zone to the Active Directory.</param>
        public void ZoneAdd(string zoneName, string zoneType, string[] masterServers, bool integrated)
        {
            string args = String.Format("{0} /ZoneAdd {1} ", this.curHost, zoneName);

            if (zoneType.Equals("primary", StringComparison.OrdinalIgnoreCase))
            {
                args += (integrated) ? "/DsPrimary" : "/Primary";
            }
            else if (zoneType.Equals("secondary", StringComparison.OrdinalIgnoreCase))
            {
                foreach (string ip in masterServers)
                {
                    if (String.IsNullOrEmpty(this.IsValidIP(ip)))
                    {
                        throw new Exception(String.Format("Invalid master server IP address!\r\nZone name: {0}\r\nIP address: {1}", zoneName, ip));
                    }
                }

                args += "/Secondary " + String.Join(" ", masterServers);
            }

            args += " /file " + zoneName + ".dns";

            if (Log.DebugLog) Log.WriteLog(args);

            this.Run(this.dnsCmd, args);
        }

        /// <summary>
        /// A wrapper method for dnscmd.exe /ZoneResetSecondaries command.
        /// </summary>
        /// <param name="zoneName">The DNS zone name.</param>
        /// <param name="trasnfers">The zone transfers setting.</param>
        /// <param name="ipList">Array with IP addresses of the secondary servers (only for "list" setting).</param>
        public void ZoneResetSecondaries(string zoneName, string transfers, string[] ipList)
        {
            string args = String.Format("{0} /ZoneResetSecondaries {1} ", this.curHost, zoneName);

            switch (transfers)
            {
                case "off":
                    args += "/NoXfr /NoNotify";
                    break;
                case "all":
                    args += "/NonSecure /Notify";
                    break;
                case "list":
                    foreach (string ip in ipList)
                    {
                        if (String.IsNullOrEmpty(this.IsValidIP(ip)))
                        {
                            throw new Exception(String.Format("Invalid secondary server IP address!\r\nZone name: {0}\r\nIP address: {1}", zoneName, ip));
                        }
                    }

                    string ips = String.Join(" ", ipList);
                    args += String.Format("/SecureList {0} /NotifyList {1}", ips, ips);
                    break;
            }

            if (Log.DebugLog) Log.WriteLog(args);

            this.Run(this.dnsCmd, args);
        }

        /// <summary>
        /// A wrapper method for dnscmd.exe /ZoneReload command.
        /// </summary>
        /// <param name="zoneName">The DNS zone name.</param>
        public void ZoneReload(string zoneName)
        {
            string args = String.Format("{0} /ZoneReload {1}", this.curHost, zoneName);

            if (Log.DebugLog) Log.WriteLog(args);

            this.Run(this.dnsCmd, args);
        }

        /// <summary>
        /// A wrapper method for dnscmd.exe /ZoneDelete command.
        /// </summary>
        /// <param name="zoneName">The DNS zone name.</param>
        /// <param name="deleteFromAD">Whether to delete the DNS zone from Active Directory.</param>
        public void ZoneDelete(string zoneName, bool deleteFromAD)
        {
            string args = String.Format("{0} /ZoneDelete {1} ", this.curHost, zoneName);

            if (deleteFromAD)
            {
                args += "/DsDel /f";
            }
            else
            {
                args += "/f";
            }

            if (Log.DebugLog) Log.WriteLog(args);

            this.Run(this.dnsCmd, args);
        }

        /// <summary>
        /// A wrapper method for dnscmd.exe /RecordAdd command.
        /// </summary>
        /// <param name="zoneName">The DNS zone name.</param>
        /// <param name="nodeName">The node name.</param>
        /// <param name="ttl">The minimum TTL (Time To Live)</param>
        /// <param name="type">Record type, see <see cref="recTypes" /> for supported record types.</param>
        /// <param name="data">The record data.</param>
        public void RecordAdd(string zoneName, string nodeName, int ttl, string type, string data)
        {
            // Command format and examples:
            // dnscmd.exe <ServerName> /RecordAdd <Zone>   <NodeName> [/Aging] [/OpenAcl] [/CreatePTR] [<Ttl>] <RRType> <RRData>
            // dnscmd.exe .            /RecordAdd test.com @                                           86400   MX       10 mail.server.com
            // dnscmd.exe .            /RecordAdd test.com @                                           86400   A        10.10.10.1
            // dnscmd.exe .            /RecordAdd test.com *                                           86400   A        10.10.10.1
            // dnscmd.exe .            /RecordAdd test.com *                                           86400   AAAA     1:2:3:4:5:6:7:8
            // dnscmd.exe .            /RecordAdd test.com imap                                        86400   CNAME    us2.imap.mailhostbox.com
            // dnscmd.exe .            /RecordAdd test.com @                                           86400   TXT      "v=spf1 a mx -all"
            // dnscmd.exe .            /RecordAdd test.com _ftp._tcp                                   86400   SRV      10 50 9998 example.com
            // dnscmd.exe .            /RecordAdd test.com _finger._udp                                86400   SRV      10 30 7878 example.com

            string ip;

            if (!this.recTypes.Contains(type))
            {
                throw new Exception(String.Format("Invalid record type - '{0}'", type));
            }

            string args = String.Format("{0} /RecordAdd {1} {2} {3} {4} ",
                this.curHost,
                zoneName,
                this.CorrectNodeName(nodeName, zoneName),
                ttl,
                type
            );

            switch (type)
            {
                case "A":
                    ip = this.IsValidIP(data);
                    if (ip != "ipv4")
                    {
                        throw new Exception(String.Format("Record data must be a valid IPv4 address!\r\nZone name: {0}\r\nRecord name: {1}r\nRecord type: {2}\r\nRecord data: {3}", zoneName, nodeName, type, data));
                    }
                    break;
                case "AAAA":
                    ip = this.IsValidIP(data);
                    if (ip != "ipv6")
                    {
                        throw new Exception(String.Format("Record data must be a valid IPv6 address!\r\nZone name: {0}\r\nRecord name: {1}r\nRecord type: {2}\r\nRecord data: {3}", zoneName, nodeName, type, data));
                    }
                    break;
                case "MX":
                    // The format of MX record's data is "<Preference> <HostName>" eg. "10 mail.server.com".
                    if (!(Regex.Match(data, @"^\d{1,5}\s[A-Za-z0-9-.]+$")).Success)
                    {
                        throw new Exception(String.Format("Invalid record data!\r\nZone name: {0}r\nRecord name: {1}\r\nRecord type: {2}\r\nRecord data: {3}", zoneName, nodeName, type, data));
                    }
                    break;
                case "SRV":
                    // The format of SRV record's data is "<Priority> <Weight> <Port> <HostName>" eg. "0 20 9998 durvoto.gorata.com".
                    if (!(Regex.Match(data, @"^\d{1,5}\s\d{1,5}\s\d{1,5}\s[A-Za-z0-9-.]+$")).Success)
                    {
                        throw new Exception(String.Format("Invalid record data!\r\nZone name: {0}r\nRecord name: {1}\r\nRecord type: {2}\r\nRecord data: {3}", zoneName, nodeName, type, data));
                    }
                    break;
                case "TXT":
                    char[] q = { '\'', '"' };
                    data = String.Format(@"""{0}""", data.Trim(q));
                    break;
            }

            args += data;

            if (Log.DebugLog) Log.WriteLog(args);

            this.Run(this.dnsCmd, args);
        }

        /// <summary>
        /// A wrapper method for dnscmd.exe /RecordDelete command.
        /// </summary>
        /// <param name="zoneName">The DNS zone name.</param>
        /// <param name="nodeName">The node name.</param>
        /// <param name="type">The resource record type.</param>
        /// <param name="data">The record data.</param>
        public void RecordDelete(string zoneName, string nodeName, string type, string data)
        {
            // Command format and examples:
            // dnscmd.exe <ServerName> /RecordDelete <Zone>   <NodeName> <RRType> <RRData>                 [/f]
            // dnscmd.exe .            /RecordDelete test.com @          MX       10 mail.server.com       /f
            // dnscmd.exe .            /RecordDelete test.com @          A        10.10.10.1               /f
            // dnscmd.exe .            /RecordDelete test.com *          A        10.10.10.1               /f
            // dnscmd.exe .            /RecordDelete test.com imap       CNAME    us2.imap.mailhostbox.com /f
            // dnscmd.exe .            /RecordDelete test.com @          TXT      "v=spf1 a mx -all"       /f

            if (!this.recTypes.Contains(type))
            {
                throw new Exception(String.Format("Invalid record type provided - '{0}'", type));
            }

            if (type == "TXT")
            {
                char[] q = { '\'', '"' };
                data = String.Format(@"""{0}""", data.Trim(q));
            }

            string args = String.Format("{0} /RecordDelete {1} {2} {3} {4} /f",
                this.curHost,
                zoneName,
                this.CorrectNodeName(nodeName, zoneName),
                type,
                data
            );

            if (Log.DebugLog) Log.WriteLog(args);

            this.Run(this.dnsCmd, args);
        }

        /// <summary>
        /// Runs dnscmd.exe or other command line tool with the given arguments and returns the output as an array of string.
        /// </summary>
        /// <param name="cmd">Command to run (only the command name if it's a system command, or full path to the exe).</param>
        /// <param name="args">Command arguments.</param>
        /// <returns>Command output.</returns>
        private string[] Run(string cmd, string args)
        {
            List<string> cmdOut = new List<string>();

            ProcessStartInfo processInfo = new ProcessStartInfo();
            processInfo.FileName = cmd;
            processInfo.Arguments = args;
            processInfo.UseShellExecute = false;
            processInfo.RedirectStandardOutput = true;

            using (Process process = Process.Start(processInfo))
            {
                StreamReader sr = process.StandardOutput;
                string line;
                while ((line = sr.ReadLine()) != null)
                {
                    cmdOut.Add(line);
                }
            }

            // If we are running dnscmd.exe and the command failed, throw an exception with the error message.
            string err;
            if (cmd.IndexOf("dnscmd.exe") != -1 && (err = cmdOut.Find(line => line.Contains("Command failed:"))) != null)
            {
                throw new Exception(String.Format("'dnscmd.exe {0}' failed - {1}", args, err.Split(':')[1].Trim()));
            }

            return cmdOut.ToArray();
        }

        /// <summary>
        /// Formats the given string according to dnscmd.exe node name format.
        /// </summary>
        /// <param name="nodeName">The node name to correct.</param>
        /// <param name="zoneName">The DNS zone name.</param>
        /// <returns>Corrected node name.</returns>
        private string CorrectNodeName(string nodeName, string zoneName)
        {
            if (String.IsNullOrEmpty(nodeName)
                || nodeName.Equals(zoneName, StringComparison.OrdinalIgnoreCase)
                || nodeName.Equals((zoneName + "."), StringComparison.OrdinalIgnoreCase)
            )
            {
                return "@"; // <-- Zone's root.
            }
            else if (nodeName.IndexOf(zoneName) > 0)
            {
                return nodeName.Substring(0, (nodeName.Length - zoneName.Length - 1)); // <-- Only hostname e.g. "mail" from "mail.example.com"
            }
            else
            {
                return nodeName;
            }
        }

        /// <summary>
        /// Checks if a given string is valid IP address.
        /// </summary>
        /// <param name="addr">The IP address string to check.</param>
        /// <returns>Empty string on failure and IP address type on success.</returns>
        private string IsValidIP(string addr)
        {
            System.Net.IPAddress ip;
            string addrType;

            if (String.IsNullOrEmpty(addr) || !System.Net.IPAddress.TryParse(addr, out ip))
            {
                return "";
            }

            switch (ip.AddressFamily)
            {
                case System.Net.Sockets.AddressFamily.InterNetwork:
                    addrType = "ipv4";
                    break;
                case System.Net.Sockets.AddressFamily.InterNetworkV6:
                    addrType = "ipv6";
                    break;
                default:
                    addrType = "";
                    break;
            }

            return addrType;
        }

    }
}
