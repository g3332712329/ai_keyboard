package com.dboy.ai_keyboard.repository

import com.dboy.ai_keyboard.config.ConfigurationInfo
import com.dboy.ai_keyboard.utils.SharesLocalData
import kotlinx.serialization.json.Json

/**
 * 本地配置仓库实现。
 *
 * 基于 [SharesLocalData]（MMKV）进行配置的本地持久化存储。
 * 配置数据以 JSON 字符串形式存储，读写时进行序列化/反序列化。
 *
 * @property localData 本地存储引擎，外部注入。
 */
class LocalConfigurationRepository(
    private val localData: SharesLocalData,
) : ConfigurationRepository {

    /**
     * 存储配置数据所用的 key。
     */
    private val storageKey = "configuration"

    /**
     * JSON 解析器。
     *
     * 忽略未知字段、允许宽松解析，避免 Flutter 端新增字段后 Android 端解析失败。
     */
    private val json = Json {
        ignoreUnknownKeys = true
        isLenient = true
    }

    override suspend fun getConfiguration(): ConfigurationInfo {
        val jsonString = localData.getString(storageKey)
        if (jsonString.isNullOrEmpty()) {
            return ConfigurationInfo()
        }
        return try {
            json.decodeFromString<ConfigurationInfo>(jsonString)
        } catch (_: Exception) {
            // JSON 解析失败时返回默认配置，避免崩溃。
            ConfigurationInfo()
        }
    }

    override suspend fun saveConfiguration(config: ConfigurationInfo) {
        val jsonString = json.encodeToString(config)
        localData.putString(storageKey, jsonString)
    }

    override suspend fun updateConfiguration(
        updater: (current: ConfigurationInfo) -> ConfigurationInfo,
    ): ConfigurationInfo {
        val current = getConfiguration()
        val updated = updater(current)
        saveConfiguration(updated)
        return updated
    }

    override suspend fun clearConfiguration() {
        localData.remove(storageKey)
    }
}
