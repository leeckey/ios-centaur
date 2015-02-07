using UnityEngine;
using System.Collections;

/// <summary>
/// 战斗测试
/// </summary>
public class BattleTest : MonoBehaviour
{
	void Awake()
	{
		// TestFight();
		DataManager.GetInstance().Init();

		foreach (SkillData data in DataManager.GetInstance().skillData.Values)
			print(data.id);
	}

	void TestFight()
	{
		Player player0 = new Player();
		player0.ID = 10000;
		Player player1 = new Player();
		player1.ID = 10001;
		BattleRoom room = new BattleRoom();

		for (int i = 0; i < 10; i++)
		{
			Card card = new Card();
			card.attackSkill = new Skill100(card);
			card.ID = i;

			if (i < 5)
			{
				card.owner = player0;
				player0.initialCard.Add(card);
			}
			else
			{
				card.owner = player1;
				player1.initialCard.Add(card);
			}
		}

		room.SetFighters(player0, player1);
		room.StartFight();
	}
}
