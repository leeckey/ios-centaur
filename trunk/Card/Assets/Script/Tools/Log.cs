using UnityEngine;
using System.Collections;
using System.Text;
using System;

public enum LOG_LEVEL
{
    NONE = 0,
    DEBUG,
    WARNING,
    INFO,
    EXCEPTION,
    ERROR,
}

public class Log
{
    // 默认为debug级
    private static LOG_LEVEL logLevel = LOG_LEVEL.DEBUG;

    public static void SetLogLevel(LOG_LEVEL level)
    {
        logLevel = level;
    }

    public static void Debug(string text)
    {
        WriteLog(text, LOG_LEVEL.DEBUG);
    }

    public static void Info(string text)
    {
        WriteLog(text, LOG_LEVEL.INFO);
    }

    public static void Error(string text)
    {
        WriteLog(text, LOG_LEVEL.ERROR);
    }

    public static void Warning(string text)
    {
        WriteLog(text, LOG_LEVEL.WARNING);
    }

    public static void Exception(Exception e)
    {
        if ((int) LOG_LEVEL.EXCEPTION < (int) logLevel)
            // 当前级别log已屏蔽，不显示
            return;

		UnityEngine.Debug.LogException(e);
    }

    private static void WriteLog(string text, LOG_LEVEL level)
    {
        if ((int) level < (int) logLevel)
            // 当前级别log已屏蔽，不显示
            return;

        StringBuilder sb = new StringBuilder();
        sb.Append(DateTime.Now.ToString("")).Append(" : ").Append(text);

        switch (level)
        {
        case LOG_LEVEL.DEBUG:
			UnityEngine.Debug.Log(sb.ToString());
            break;

        case LOG_LEVEL.INFO:
			UnityEngine.Debug.Log(sb.ToString());
            break;

        case LOG_LEVEL.WARNING:
			UnityEngine.Debug.LogWarning(sb.ToString());
            break;

        case LOG_LEVEL.ERROR:
			UnityEngine.Debug.LogError(sb.ToString());
            break;
        }
    }

    // 显示当前系统调用栈
    public static void ShowCurStackTrace()
    {
        try
        {
            // 主动跑出系统异常
            throw new Exception();
        }
        catch (Exception e)
        {
			UnityEngine.Debug.Log(e.StackTrace);
        }
    }
}
