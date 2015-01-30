using UnityEngine;
using System.Collections;

/// <summary>
/// 光速特效
/// </summary>
public class LightSpeed : MonoBehaviour
{
    public UIAtlas Logoatlas;

    private UISprite lightSprite;
    private UISprite bottomTxtSprite;
    private UISprite ballSprite;
    private UISprite englishSprite;
    private UISprite chineseSprite;
    //frame 从1开始
    private int currentFrame = 0;
    private int maxFrame = 88;
    private string lightNamePrefix = "SD";
    private string bottomTxtPrefix = "XFZ";
    private string ballPrefix = "XQ";
    private string englishPrefix = "YWZ";
    private string chinesePrefix = "ZWZ";

	void Awake()
	{
		// 设置刷新率
		Application.targetFrameRate = 60;
	}

    void Start()
    {
        // Logoatlas = Resources.Load("LS_LOGO/SpeedLogo2015", typeof(UIAtlas)) as UIAtlas;

        lightSprite = CreateSprite(gameObject);
        lightSprite.depth = 5;
        lightSprite.width = Screen.width;
        lightSprite.height = Screen.height;

        bottomTxtSprite = CreateSprite(gameObject);
        bottomTxtSprite.depth = 4;
        bottomTxtSprite.width = Screen.width;
        bottomTxtSprite.height = Screen.height;

        ballSprite = CreateSprite(gameObject);
        ballSprite.depth = 3;
        ballSprite.width = Screen.width;
        ballSprite.height = Screen.height;

        englishSprite = CreateSprite(gameObject);
        englishSprite.depth = 1;
        englishSprite.width = Screen.width;
        englishSprite.height = Screen.height;

        chineseSprite = CreateSprite(gameObject);
        chineseSprite.depth = 2;
        chineseSprite.width = Screen.width;
        chineseSprite.height = Screen.height;

        this.GetComponent<AudioSource>().PlayDelayed(0.05f);

		StartCoroutine(ShowAnimation());
    }


	IEnumerator ShowAnimation()
	{
		while (maxFrame >= currentFrame)
		{
			yield return null;

			lightSprite.spriteName = GetNumStr(lightNamePrefix, currentFrame);
			bottomTxtSprite.spriteName = GetNumStr(bottomTxtPrefix, currentFrame);
			ballSprite.spriteName = GetNumStr(ballPrefix, currentFrame);
			englishSprite.spriteName = GetNumStr(englishPrefix, currentFrame);
			chineseSprite.spriteName = GetNumStr(chinesePrefix, currentFrame);
			currentFrame++;

			yield return null;
		}

		yield return new WaitForSeconds(1f);

		SceneManager.LoadScene("Login", false);
	}
	
//	private float skipPt = 0;
//	void Update()
//	{
//		skipPt += Time.deltaTime;
//        if (skipPt < 0.024)
//        {
//            return;
//        }
//        skipPt = 0;
//
//        if (maxFrame >= currentFrame)
//        {
//            lightSprite.spriteName = GetNumStr(lightNamePrefix, currentFrame);
//            bottomTxtSprite.spriteName = GetNumStr(bottomTxtPrefix, currentFrame);
//            ballSprite.spriteName = GetNumStr(ballPrefix, currentFrame);
//            englishSprite.spriteName = GetNumStr(englishPrefix, currentFrame);
//            chineseSprite.spriteName = GetNumStr(chinesePrefix, currentFrame);
//            currentFrame++;
//        }
//        else
//        {
//			skipPt = -9999999;
//        }
//    }

    private UISprite CreateSprite(GameObject g)
    {
        UISprite s = g.AddComponent<UISprite>();
        s.atlas = Logoatlas;
        s.MakePixelPerfect();
        return s;
    }

    private string GetNumStr(string namePrefix, int num)
    {
        string numStr = "";
        if (10 > num)
        {
            numStr = "000" + num;
        }
        else if (100 > num)
        {
            numStr = "00" + num;
        }
        return namePrefix + numStr;
    }
}
