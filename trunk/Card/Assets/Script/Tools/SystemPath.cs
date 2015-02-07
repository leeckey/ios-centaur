using UnityEngine;
using System.Collections;

public class SystemPath
{
    /// <summary>
	/// 本地静态存储的目录(可以在一开始进行一次缓存！）
    /// </summary>
    public static string LocalResPath
    {
        get
        {
            string dataRoot = "";
            switch (Application.platform)
            {
            case RuntimePlatform.Android:
                dataRoot = "jar:file://" + Application.dataPath + "!/assets/";
                break;
            case RuntimePlatform.IPhonePlayer:
                dataRoot = "file://" + Application.streamingAssetsPath + "/";
                break;
            case RuntimePlatform.WindowsPlayer:
            case RuntimePlatform.WindowsEditor:
            case RuntimePlatform.OSXEditor:
            case RuntimePlatform.OSXPlayer:
				dataRoot = "file://" + Application.dataPath + "/Temp/";
				break;
            }
            return dataRoot;
        }
    }


	/// <summary>
	/// 本地动态写入文件的目录
	/// </summary>
    public static string LocalUserCacheSavePath
    {
        get
        {
            string dataRoot = "";
            switch (Application.platform)
            {
            case RuntimePlatform.Android:
                dataRoot = Application.persistentDataPath + "//";
                break;
            case RuntimePlatform.IPhonePlayer:
                dataRoot = Application.persistentDataPath + "/assets/";
                break;
            case RuntimePlatform.WindowsPlayer:
            case RuntimePlatform.WindowsEditor:
            case RuntimePlatform.OSXEditor:
            case RuntimePlatform.OSXPlayer:
                dataRoot = Application.dataPath + "/Temp/";
                break;
            }
            return dataRoot;
        }
    }

    /// <summary>
	/// 本地动态写入文件的目录
    /// </summary>
    public static string LocalUserCacheReadPath
    {
        get
        {
            string dataRoot = "";
            switch (Application.platform)
            {
            case RuntimePlatform.Android:
                dataRoot = "file://" + Application.persistentDataPath + "//";
                break;
            case RuntimePlatform.IPhonePlayer:
                dataRoot = "file://" + Application.persistentDataPath + "//assets//";
                break;
            case RuntimePlatform.WindowsPlayer:
            case RuntimePlatform.WindowsEditor:
            case RuntimePlatform.OSXEditor:
            case RuntimePlatform.OSXPlayer:
				dataRoot = "file://" + Application.dataPath + "/Temp/";
				break;
            }
            return dataRoot;
        }
    }
}
