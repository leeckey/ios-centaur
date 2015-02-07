using UnityEngine;
using System.Collections;

/// <summary>
/// 玩家信息管理类
/// </summary>
public class GD_HeroInfo : GD_Base
{
	public HeroData heroData;

	// 初始化
	public override void Init()
	{
		base.Init();

		if (heroData == null)
		{
			heroData = new HeroData();
			Save();
		}
	}

	// 保存数据
	public override void Save()
	{
		XmlUtil.SaveXml("HeroData", heroData);
	}

	// 加载数据
	public override void Load()
	{
		heroData = XmlUtil.LoadFromXml("HeroData", typeof(HeroData)) as HeroData;
	}
}
