using UnityEngine;
using System.Collections;
using System.IO;
using System.Xml.Serialization;
using System.Runtime.Serialization.Formatters.Binary;
using System;
using System.Text;

/// <summary>
/// 文件管理工具
/// </summary>
public class FileTools
{
    /// <summary>
	/// 验证路径目录是否存在,不存在就创建目录
    /// </summary>
    public static void ExistPathDirectory(string path)
    {
        string directory = Path.GetDirectoryName(path);
        if (!Directory.Exists(directory))
        {
            Directory.CreateDirectory(directory);
        }
	}

    /// <summary>
	/// 读取文件
    /// </summary>
    public static string ReadFile(string path, string defaultContent = "")
    {
        if (!File.Exists(path))
        {
            Debug.Log("读取文件失败，不存在的文件路径: " + path);
            return defaultContent;
        }
        
        FileStream myStream = new FileStream(path, FileMode.Open);
        StreamReader reader = new StreamReader(myStream);
        string content = defaultContent;
        try
        {
            content = reader.ReadToEnd();
        }
		catch (IOException e)
        {
            Debug.Log(e.StackTrace);
        }
		finally
        {
            reader.Close();
            myStream.Close();
        }
        
        return content;
    }
    
    /// <summary>
	/// 写文件
    /// </summary>
    public static void WriteFile(string path, string content)
    {
        if (File.Exists(path))
        {
            File.Delete(path);
        }
        
        FileStream myStream = new FileStream(path, FileMode.OpenOrCreate);
        StreamWriter writer = new StreamWriter(myStream, Encoding.GetEncoding("utf-8"));
        
        try
        {
            writer.Write(content);
        }
		catch (IOException e)
        {
            Debug.Log(e.StackTrace);
        }
		finally
        {
            writer.Close();
            myStream.Close();
        }
    }
    
    /// <summary>
	/// 从本地固定目录读取
    /// </summary>
    public static string ReadTxtFromLocal(string fileName)
    {
        string path = SystemPath.LocalUserCacheSavePath + fileName + ".txt";
        return ReadFile(path);
    }
    
    /// <summary>
	/// 写本地固定目录
    /// </summary>
    public static void WriteTxtToLocal(string fileName, string content)
    {
        string path = SystemPath.LocalUserCacheSavePath + fileName + ".txt";
        WriteFile(path, content);
    }
    
    /// <summary>
	/// 删除文件
    /// </summary>
    public static void DeleteFile(string path)
    {
        if (! File.Exists(path))
        {
            Debug.Log("删除失败，不存在的文件路径: " + path);
            return;
        }
        
        File.Delete(path);
    }
    
    public static void WriteTxtByAppendToLocal(string fileName, string content)
    {
        string path = SystemPath.LocalUserCacheSavePath + fileName + ".txt";
        WriteFileByAppend(path, content);
    }
    
    /// <summary>
	/// 追加的方式写文件
    /// </summary>
    public static void WriteFileByAppend(string path, string content)
    {
        FileStream myStream = new FileStream(path, FileMode.Append);
        StreamWriter writer = new StreamWriter(myStream, Encoding.GetEncoding("utf-8"));
        
        try
        {
            writer.WriteLine(content);
        }
		catch (IOException e)
        {
            Debug.Log(e.StackTrace);
        }
		finally
        {
            writer.Close();
            myStream.Close();
        }
    }
    
    /// <summary>
	/// 获取文件修改时间
    /// </summary>
    public static string GetFileModifyTime(string filePath)
    {
        filePath = filePath.Replace("file://", "").Replace("jar:","");
        if (! File.Exists(filePath))
        {
            Log.Info(filePath + " not exist");
            return "";
        }
        
        FileInfo info = new FileInfo(filePath);
        
        DateTime writeTime = info.LastWriteTime;
        
        return writeTime.ToString("MM/dd/yyyy HH:mm:ss");
    }
}

