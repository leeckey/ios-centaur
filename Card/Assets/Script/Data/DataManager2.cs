using System;
using System.Reflection;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// 数据管理类,直接读取CSV配置
/// </summary>
public class DataManager2
{
	// 资源文件路径
	public static string FILE_PATH = "Csv/";

	public static Dictionary<int, HeroInfo> heroInfo;

	public static void Init()
	{
		//long t = DateTime.Now.Ticks;
		ReadData<HeroInfo>(ref heroInfo);
		//Debug.Log((DateTime.Now.Ticks - t)/10000);
	}

	/// <summary>
	/// 读取数据
	/// </summary>
	public static void ReadData<T>(ref Dictionary<int, T> data) where T : IDataTable, new()
	{
		data = new Dictionary<int, T>();

		// 读取文件
		T temp = new T();
		Type type = typeof(T);
		MethodInfo method = type.GetMethod("GetFileName");
		string filePath = FILE_PATH + (string)method.Invoke(temp, null);
		TextAsset text = Resources.Load(filePath) as TextAsset;
		// Debug.Log(text.text);

		// 读取列名
		string[] lines = text.text.Split('\n');
		if (lines.Length < 2)
			return;

		List<FieldInfo> fieldInfos = new List<FieldInfo>();
		FieldInfo fileInfo;
		string[] columns = lines[0].Split(',');
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
		int rowKey = 0;
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
			rowKey = 0;
			rowData = lines[i].Split(',');
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

				// 默认首列为Key值
				if (rowKey == 0)
				{
					rowKey = int.Parse(str);
				}
			}

			if (rowKey != 0)
			{
				if (data.ContainsKey(rowKey))
				{
					Debug.LogWarning("有重复的Key值");
					continue;
				}
				data.Add(rowKey, row);
			}
		}
	}
}
