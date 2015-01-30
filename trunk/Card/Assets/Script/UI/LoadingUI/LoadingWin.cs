using UnityEngine;
using System.Collections;
using Holoville.HOTween;

/// <summary>
/// Loading界面实现
/// </summary>
public class LoadingWin : ILoading
{
	public UIPanel panel;

	/// <summary>
	/// 显示界面
	/// </summary>
	public override void Show()
	{
		gameObject.SetActive(true);
		panel.alpha = 0f;
		isShow = true;
		HOTween.To(panel, 0.5f, new TweenParms().Prop("alpha", 1f).OnComplete(() => { isShow = false; }));
	}


	// 隐藏界面
	public override void Hide()
	{
		panel.alpha = 1f;
		isShow = true;
		HOTween.To(panel, 0.5f, new TweenParms().Prop("alpha", 0f).OnComplete(() => { isShow = false;  gameObject.SetActive(false); }));
	}
}
