package com.dboy.ai_keyboard.utils

import android.content.Context

/**
 * 本地共享数据接口。
 *
 * 封装底层存储引擎（MMKV / SharedPreferences / DataStore 等），
 * 提供统一的键值读写能力。
 *
 * 在 Android 端，MMKV 是同步存储引擎；
 * 但接口统一用返回值包装，方便后续替换为异步引擎时不改调用方。
 */
interface SharesLocalData {

    /**
     * 初始化存储引擎。
     *
     * 必须在应用/服务启动时调用一次。
     *
     * @return 是否初始化成功
     */
    fun init(context: Context): Boolean

    /**
     * 判断指定 key 是否存在。
     */
    fun containsKey(key: String): Boolean

    /**
     * 存储布尔值。
     */
    fun putBool(key: String, value: Boolean): Boolean

    /**
     * 读取布尔值。
     *
     * @param key          键
     * @param defaultValue key 不存在时返回的默认值
     * @return 存储的值，或 defaultValue，或 null
     */
    fun getBool(key: String, defaultValue: Boolean? = null): Boolean?

    /**
     * 存储字符串。
     */
    fun putString(key: String, value: String): Boolean

    /**
     * 读取字符串。
     *
     * @param key          键
     * @param defaultValue key 不存在时返回的默认值
     * @return 存储的值，或 defaultValue，或 null
     */
    fun getString(key: String, defaultValue: String? = null): String?

    /**
     * 存储整型。
     */
    fun putInt(key: String, value: Int): Boolean

    /**
     * 读取整型。
     *
     * @param key          键
     * @param defaultValue key 不存在时返回的默认值
     * @return 存储的值，或 defaultValue，或 null
     */
    fun getInt(key: String, defaultValue: Int? = null): Int?

    /**
     * 存储浮点型。
     */
    fun putDouble(key: String, value: Double): Boolean

    /**
     * 读取浮点型。
     *
     * @param key          键
     * @param defaultValue key 不存在时返回的默认值
     * @return 存储的值，或 defaultValue，或 null
     */
    fun getDouble(key: String, defaultValue: Double? = null): Double?

    /**
     * 删除指定 key。
     */
    fun remove(key: String): Boolean

    /**
     * 清空所有数据。
     */
    fun removeAll(): Boolean
}
