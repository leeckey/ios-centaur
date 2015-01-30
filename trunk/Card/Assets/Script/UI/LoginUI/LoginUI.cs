using UnityEngine;
using System.Collections;

/// <summary>
/// 登录界面
/// </summary>
public class LoginUI : MonoBehaviour
{
	// 信息显示
	public UILabel infoLabel;

	IEnumerator Start()
	{
		infoLabel.text = "游戏初始化中...";

		while (!GameMain.isInit)
			yield return null;

		infoLabel.text = "点击屏幕继续...";
	}
}
