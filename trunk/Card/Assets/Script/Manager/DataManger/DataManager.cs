using System;
using System.Reflection;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

[Serializable]
public class DataManager: ScriptableObject
{
	// 数据数组,由于不能序列化Dictionary,所有数据都是存为List保存
	[SerializeField]
	List<HeroInfo> heroInfoList;
	[SerializeField]
	List<SkillData> skillDataList;
	[SerializeField]
	List<BuffData> buffDataList;
	[SerializeField]
	List<CardTemplateData> cardDataList;

	// 反序列化以后再保存为Dictionary数据
	[NonSerialized]
	public Dictionary<int, HeroInfo> heroInfo;
	[NonSerialized]
	public Dictionary<int, SkillData> skillData;
	[NonSerialized]
	public Dictionary<int, BuffData> buffData;
	[NonSerialized]
	public Dictionary<int, CardTemplateData> cardData;

	// 资源文件路径
	public static string ASSET_PATH = "DataBase/DataManager"; 

	// 单例
	private static DataManager instance;

	/// <summary>
	/// 读取文件,创建实例
	/// </summary>
	public static DataManager GetInstance()
	{
		if (instance != null)
			return instance;
		
		instance = Resources.Load(ASSET_PATH, typeof(DataManager)) as DataManager;
		return instance;
	}


	/// <summary>
	/// 读取数据
	/// </summary>
	public void Init()
	{
		// 转换所有配置
		ChangeData<HeroInfo>(ref heroInfoList, ref heroInfo);
		ChangeData<SkillData>(ref skillDataList, ref skillData);
		ChangeData<BuffData>(ref buffDataList, ref buffData);
		ChangeData<CardTemplateData>(ref cardDataList, ref cardData);
		//Clear();
	}

	// 清理数据
	void Clear()
	{
		heroInfoList = null;
		skillDataList = null;
		buffDataList = null;
		cardDataList = null;

		GC.Collect();
	}

	// 列表转换为字典数据
	private void ChangeData<T>(ref List<T> list, ref Dictionary<int,T> dic) where T : IDataTable
	{
		dic = new Dictionary<int, T>();
		foreach (T temp in list)
		{
			dic.Add(temp.GetKey(), temp);
		}
	}

#if UNITY_EDITOR

	// 数据路径
	public static string FILE_PATH = "Assets/Resources/Csv/";

	/// <summary>
	/// 读取配置信息
	/// </summary>
	public void Load()
	{
		LoadData<HeroInfo>(ref heroInfoList);
		LoadData<SkillData>(ref skillDataList);
		LoadData<BuffData>(ref buffDataList);
		LoadData<CardTemplateData>(ref cardDataList);
	}

	/// <summary>
	/// 读取数据
	/// </summary>
	void LoadData<T>(ref List<T> data) where T : IDataTable, new()
	{
		data = new List<T>();

		// 读取文件
		T temp = new T();
		// MethodInfo method = type.GetMethod("GetFileName");
		string filePath = FILE_PATH + temp.GetFileName();
		TextAsset text = AssetDatabase.LoadAssetAtPath(filePath, typeof(TextAsset)) as TextAsset;
		// Debug.Log(text.text);
		
		// 读取列名
		string[] lines = text.text.Split('\n');
		if (lines.Length < 2)
			return;

		Type type = typeof(T);
		List<FieldInfo> fieldInfos = new List<FieldInfo>();
		FieldInfo fileInfo;
		string[] columns = lines[0].Split('\t');
		for (int i = 0; i < columns.Length; i++)
		{
			string field = columns[i];
			fileInfo = type.GetField(field);
			if (fileInfo != null)
				fieldInfos.Add(fileInfo);
			else
				columns[i] = string.Empty;
		}
		
		// 读取数据,默认第二行为中文注释
		T row;
		string[] rowData;
		string str;
		object v;
		for (int i = 2; i < lines.Length; i++)
		{
			// 空行
			if (lines[i].Trim() == string.Empty)
				continue;
			
			// 新建数据
			row = new T();
			rowData = lines[i].Split('\t');
			if (rowData.Length != columns.Length)
			{
				Debug.LogWarning("数据列数错误");
				continue;
			}
			for (int j = 0; j < columns.Length; j++)
			{
				if (columns[j] == string.Empty)
					continue;
				
				str = rowData[j];
				fileInfo = fieldInfos[j];
				v = Convert.ChangeType(str, fileInfo.FieldType);
				fileInfo.SetValue(row, v);
			}
			
			// 加入临时列表
			data.Add(row);
		}
	}
#endif
}
