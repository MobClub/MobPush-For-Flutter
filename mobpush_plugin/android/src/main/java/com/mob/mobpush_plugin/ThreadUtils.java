package com.mob.mobpush_plugin;

import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import java.util.concurrent.Executor;
import java.util.concurrent.Executors;

/**
 * 主线程和子线程快速切换的工具类
 * Created by lijianbin on 2016/10/12.
 */
public class ThreadUtils {
    private static final String TAG = "ThreadUtils";

    //初始化主线程handler
    private static Handler mHandler = new Handler(Looper.getMainLooper());
    //初始化单线程的线程池执行器
    private static Executor executor = Executors.newSingleThreadExecutor();

    private ThreadUtils() {
    }

    /**
     * 切换到主线程
     *
     * @param runnable
     */
    public static void runUIThread(Runnable runnable) {
        if (isOnUIThread()) {
            runnable.run();
        } else {
            mHandler.post(runnable);
        }
    }

    /**
     * 切换到子线程
     *
     * @param runnable
     */
    public static void runInThread(Runnable runnable) {
        if (!isOnUIThread()) {
            runnable.run();
        } else {
            executor.execute(runnable);
        }
    }

    /**
     * 子线程执行
     *
     * @param runnable
     */
    public static void excuteOnBackThread(Runnable runnable) {
        executor.execute(runnable);
    }

    /**
     * UI线程执行
     *
     * @param runnable
     */
    public static void excuteOnUIThread(Runnable runnable) {
        mHandler.post(runnable);
    }

    /**
     * 判断是当前线程是否是UI线程
     *
     * @return true表示UI线程, false表示子线程
     */
    public static boolean isOnUIThread() {
        Log.i(TAG, "isOnUIThread: " + Thread.currentThread().getName());
        return Looper.myLooper() == Looper.getMainLooper();
    }
}
