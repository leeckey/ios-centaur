using UnityEngine;
using System.Collections;

/// <summary>
/// 场景管理
/// </summary>
public class SceneManager : MonoBehaviour
{
	// 单例
	static SceneManager instance;

	// 当前场景名称
	public static string currScene;

	// Loading界面
	public ILoading loadingWin;

	void Awake()
	{
		instance = this;

		// 不会销毁
		DontDestroyOnLoad(gameObject);
	}

	/// <summary>
	/// 加载场景
	/// </summary>
	public static void LoadScene(string sceneName, bool isAsyns = false)
	{
		if (instance == null)
			return;

		// 已经是当前场景了
		if (sceneName == currScene)
			return;

		instance._LoadScene(sceneName, isAsyns);
	}

	// 加载场景
	void _LoadScene(string sceneName, bool isAsyns)
	{
		currScene = sceneName;

		if (isAsyns)
		{
			// 异步加载
			StartCoroutine(LoadAsysnScene(sceneName));
		}
		else
		{
			// 同步加载
			Application.LoadLevel(sceneName);
		}
	}

	// 异步加载
	IEnumerator LoadAsysnScene(string sceneName)
	{
		// 显示Loading界面
		loadingWin.Show();

		while (loadingWin.isShow)
			yield return null;

		// 开始加载新场景
		AsyncOperation async = Application.LoadLevelAsync(sceneName);
		while (!async.isDone)
		{
			yield return async;
		}

		yield return new WaitForSeconds(2f);

		// 隐藏Loading界面
		loadingWin.Hide();
	}
}
