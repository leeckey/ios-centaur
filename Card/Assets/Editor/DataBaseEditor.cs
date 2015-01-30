using UnityEngine;
using UnityEditor;
using System.Collections;

public class DataBaseEditor
{
	/// <summary>
	/// 读取配置并保存
	/// </summary>
	[MenuItem("Tools/Create DataBase")]
	public static void Save()
	{
		DataManager dataBaseManager = ScriptableObject.CreateInstance<DataManager>();
		dataBaseManager.Load();
		
		AssetDatabase.CreateAsset(dataBaseManager , "Assets/Resources/" + DataManager.ASSET_PATH + ".asset");
	}
}
