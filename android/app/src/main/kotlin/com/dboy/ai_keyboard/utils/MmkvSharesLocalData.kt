package com.dboy.ai_keyboard.utils

import android.content.Context
import com.tencent.mmkv.MMKV

/**
 * 基于腾讯 MMKV 的本地存储实现。
 *
 * MMKV 特点：高性能、支持多进程、数据加密可选。
 * 适用于高频读写的键值场景。
 *
 * Android 端使用默认初始化即可，无需像 iOS 那样配置 App Group 路径。
 * 但要让主 App 和键盘服务（InputMethodService）共享数据，
 * 必须使用同一个 [mmapID] 且开启多进程模式。
 */
class MmkvSharesLocalData(
    private val mmapID: String = "ai_keyboard_config",
) : SharesLocalData {

    private lateinit var mmkv: MMKV

    /**
     * 初始化 MMKV。
     *
     * 使用多进程模式打开具名 mmapID，
     * 这样主 App 和键盘服务可以读到同一份数据。
     */
    override fun init(context: Context): Boolean {
        return try {
            MMKV.initialize(context)
            mmkv = MMKV.mmkvWithID(mmapID, MMKV.MULTI_PROCESS_MODE)
            true
        } catch (e: Exception) {
            false
        }
    }

    override fun containsKey(key: String): Boolean {
        return mmkv.containsKey(key)
    }

    override fun putBool(key: String, value: Boolean): Boolean {
        return mmkv.encode(key, value)
    }

    override fun getBool(key: String, defaultValue: Boolean?): Boolean? {
        if (!mmkv.containsKey(key)) {
            return defaultValue
        }
        return mmkv.decodeBool(key, defaultValue ?: false)
    }

    override fun putString(key: String, value: String): Boolean {
        return mmkv.encode(key, value)
    }

    override fun getString(key: String, defaultValue: String?): String? {
        if (!mmkv.containsKey(key)) {
            return defaultValue
        }
        return mmkv.decodeString(key) ?: defaultValue
    }

    override fun putInt(key: String, value: Int): Boolean {
        return mmkv.encode(key, value)
    }

    override fun getInt(key: String, defaultValue: Int?): Int? {
        if (!mmkv.containsKey(key)) {
            return defaultValue
        }
        return mmkv.decodeInt(key, defaultValue ?: 0)
    }

    override fun putDouble(key: String, value: Double): Boolean {
        return mmkv.encode(key, value)
    }

    override fun getDouble(key: String, defaultValue: Double?): Double? {
        if (!mmkv.containsKey(key)) {
            return defaultValue
        }
        return mmkv.decodeDouble(key, defaultValue ?: 0.0)
    }

    override fun remove(key: String): Boolean {
        mmkv.removeValueForKey(key)
        return true
    }

    override fun removeAll(): Boolean {
        mmkv.clearAll()
        return true
    }
}
