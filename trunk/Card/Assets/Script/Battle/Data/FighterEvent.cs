using System;

/// <summary>
/// 卡牌事件参数
/// </summary>
public class FighterEvent : GEvent
{
	// 发出事件的卡牌
	public BaseFighter fighter;

	public FighterEvent()
	{
		fighter = null;
	}

	public FighterEvent(string _type, BaseFighter _card)
	{
		this.type = _type;
		this.fighter = _card;
	}

	/// <summary>
	/// 设置数据
	/// </summary>
	public override void SetParam(string _type, object _data)
	{
		this.type = _type;
		this.fighter = _data as BaseFighter;
	}
}
