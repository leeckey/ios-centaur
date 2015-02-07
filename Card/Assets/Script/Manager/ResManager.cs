using UnityEngine;
using System.Collections;

/// <summary>
/// 资源管理类,可提供资源缓存,兼容不同平台下的加载方式
/// </summary>
public class ResManager
{
	/// <summary>
	/// 加载资源
	/// </summary>
	public static T LoadRes<T>(string path) where T : UnityEngine.Object
	{
		return Resources.Load<T>(path) as T;
	}

	/// <summary>
	/// 加载一个UI界面
	/// </summary>
	public static GameObject LoadUI(string path)
	{
		return LoadRes<GameObject>("Prefabs/UI/" + path);
	}

	/// <summary>
	/// 加载一张图片
	/// </summary>
	public static Texture LoadTexture(string path)
	{
		return LoadRes<Texture>("Texture/" + path);
	}
}
