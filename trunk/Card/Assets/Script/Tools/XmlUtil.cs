using UnityEngine;
using System.Collections;
using System.IO;
using System.Xml.Serialization;
using System;
using System.Xml;
using System.Text;

public class XmlUtil
{
	// obj->xml
	public static void SaveXml(string key, object obj)
	{
		string path = SystemPath.LocalUserCacheSavePath + "LocalCache/" + key + ".xml";
		SaveXml(path, obj, obj.GetType());
	}
	
	// obj->xml
	private static void SaveXml(string path, object obj, System.Type type)
	{
		if (File.Exists(path))
		{
			File.Delete(path);
		}
		else
		{
			FileTools.ExistPathDirectory(path);
		}
		FileStream  myWriter = new FileStream(path, FileMode.CreateNew, FileAccess.Write);
		
		XmlTextWriter writer = new XmlTextWriter(myWriter, Encoding.GetEncoding("utf-8"));
		writer.Formatting = Formatting.Indented;
		try
		{
			// 生成xml序列化对象，序列化并写本地
			XmlSerializer mySerializer  = new XmlSerializer(type);
			mySerializer.Serialize(writer, obj);
			Log.Info("save file " + path + " success");
		}
		catch (Exception e)
		{
			Log.Info("save log " + e.ToString());
		}
		finally
		{
			myWriter.Close();
		}
	}
	
	// xml->obj
	public static object LoadFromXml(string key, System.Type type)
	{
		string path = SystemPath.LocalUserCacheSavePath + "LocalCache/" + key + ".xml";
		object obj = null;
		if (!System.IO.File.Exists(path))
		{
			Log.Info(path + " file not exist");
		}
		else
		{
			StreamReader myReader = new StreamReader(path);
			XmlSerializer mySerializer = new XmlSerializer(type);
			
			try
			{
				// 读取文件流数据，并反序列化
				obj = mySerializer.Deserialize(myReader);
				Log.Info("read file " + key + " success");
			}
			catch (Exception e)
			{
				Log.Info("load log" + e.StackTrace);
			}
			finally
			{
				myReader.Close();
			}
		}
		
		return obj;
	}
}

