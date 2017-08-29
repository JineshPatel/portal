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
using System.IO;
using System.Data;
using System.Collections;
using System.Xml;
using System.Web;
using System.Reflection;
using System.Text;
using System.Globalization;
using System.Text.RegularExpressions;

namespace Common.Utils
{
	public class Utils
	{
        private static string logFile = Path.Combine(HttpContext.Current.Server.MapPath("~"), "log.txt");
        private static bool debugLog = File.Exists(Path.Combine(HttpContext.Current.Server.MapPath("~"), "dbg.txt")) ? true : false;

        public static bool IsEmpty(string str)
		{
			return (str == null || str.Trim() == "");
		}

		public static bool IsNotEmpty(string str)
		{
			return !IsEmpty(str);
		}

		public static int ParseInt(string val, int defaultValue)
		{
			int result = defaultValue;
			try { result = Int32.Parse(val); }
			catch { /* do nothing */ }
			return result;
		}

		public static decimal ParseDecimal(string val, decimal defaultValue)
		{
			decimal result = defaultValue;
			try { result = Decimal.Parse(val); }
			catch { /* do nothing */ }
			return result;
		}

		public static string[] ParseDelimitedString(string str, params char[] delimiter)
		{
			string[] parts = str.Split(delimiter);
			ArrayList list = new ArrayList();
			foreach (string part in parts)
				if (part.Trim() != "" && !list.Contains(part.Trim()))
					list.Add(part);
			return (string[])list.ToArray(typeof(string));
		}

		public static string ReplaceStringVariable(string str, string variable, string value)
		{
			if (IsEmpty(str) || IsEmpty(value))
				return str;

			Regex re = new Regex("\\[" + variable + "\\]+", RegexOptions.IgnoreCase);
			return re.Replace(str, value);
		}

		public static string BuildIdentityXmlFromArray(int[] ids, string rootName, string childName)
		{
			XmlDocument doc = new XmlDocument();
			XmlElement nodeRoot = doc.CreateElement(rootName);
			foreach (int id in ids)
			{
				XmlElement nodeChild = doc.CreateElement(childName);
				nodeChild.SetAttribute("id", id.ToString());
				nodeRoot.AppendChild(nodeChild);
			}

			return nodeRoot.OuterXml;
		}

        public static void WriteLog(string text)
        {
            if (Utils.debugLog && !String.IsNullOrEmpty(text))
            {
                using (StreamWriter file = new StreamWriter(Utils.logFile, true))
                {
                    file.WriteLine(text);
                }
            }
        }
        public static string DumpObject(object obj, int recursion, ArrayList exclProps = null, ArrayList exclTypes = null)
        {
            StringBuilder result = new StringBuilder();

            exclProps = (exclProps != null) ? exclProps : new ArrayList();
            exclTypes = (exclTypes != null) ? exclTypes : new ArrayList();

            // Protect the method against endless recursion
            if (recursion < 5)
            {
                // Determine object type
                Type t = obj.GetType();

                // Get array with properties for this object
                PropertyInfo[] properties = t.GetProperties();

                foreach (PropertyInfo property in properties)
                {
                    if (exclProps.Contains(property.Name)) continue;

                    try
                    {
                        // Get the property value
                        object value = property.GetValue(obj, null);

                        if (exclTypes.Contains(value.GetType().ToString())) continue;

                        // Create indenting string to put in front of properties of a deeper level
                        // We'll need this when we display the property name and value
                        string indent = String.Empty;
                        string spaces = "|   ";
                        string trail = "|...";

                        if (recursion > 0)
                        {
                            indent = new StringBuilder(trail).Insert(0, spaces, recursion - 1).ToString();
                        }

                        if (value != null)
                        {
                            // If the value is a string, add quotation marks
                            string displayValue = value.ToString();
                            if (value is string) displayValue = String.Concat('"', displayValue, '"');

                            // Add property name and value to return string
                            result.AppendFormat("{0}{1} = {2}\n", indent, property.Name, displayValue);

                            try
                            {
                                if (!(value is ICollection))
                                {
                                    // Call var_dump() again to list child properties
                                    // This throws an exception if the current property value
                                    // is of an unsupported type (eg. it has no properties)
                                    if (!(value is string))
                                    {
                                        result.Append(DumpObject(value, recursion + 1, exclProps, exclTypes));
                                    }
                                }
                                else
                                {
                                    // 2009-07-29: added support for collections
                                    // The value is a collection (eg. it's an arraylist or generic list)
                                    // so loop through its elements and dump their properties
                                    int elementCount = 0;
                                    foreach (object element in ((ICollection)value))
                                    {
                                        string elementName = String.Format("{0}[{1}]", property.Name, elementCount);
                                        indent = new StringBuilder(trail).Insert(0, spaces, recursion).ToString();

                                        // Display the collection element name and type
                                        result.AppendFormat("{0}{1} = {2}\n", indent, elementName, element.ToString());

                                        // Display the child properties
                                        result.Append(DumpObject(element, recursion + 2, exclProps, exclTypes));
                                        elementCount++;
                                    }

                                    result.Append(DumpObject(value, recursion + 1, exclProps, exclTypes));
                                }
                            }
                            catch { }
                        }
                        else
                        {
                            // Add empty (null) property to return string
                            result.AppendFormat("{0}{1} = {2}\n", indent, property.Name, "null");
                        }
                    }
                    catch
                    {
                        // Some properties will throw an exception on property.GetValue()
                        // I don't know exactly why this happens, so for now i will ignore them...
                    }
                }
            }

            return result.ToString();
        }
    }
}
