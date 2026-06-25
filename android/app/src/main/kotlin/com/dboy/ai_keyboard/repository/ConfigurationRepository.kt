package com.dboy.ai_keyboard.repository

import com.dboy.ai_keyboard.config.ConfigurationInfo

/**
 * 配置仓库抽象接口。
 *
 * 负责配置数据的持久化读写，支持本地存储和云端存储两种实现。
 * 当前阶段使用本地存储实现，云端存储接口已预留，后续可无缝切换或双写。
 */
interface ConfigurationRepository {

    /**
     * 获取完整配置信息。
     *
     * 配置不存在时返回默认空配置（所有字段为默认值）。
     */
    suspend fun getConfiguration(): ConfigurationInfo

    /**
     * 保存完整配置信息。
     *
     * @param config 要保存的配置对象，会覆盖已有配置。
     */
    suspend fun saveConfiguration(config: ConfigurationInfo)

    /**
     * 函数式更新配置。
     *
     * 接收当前配置，返回更新后的新配置。
     * 返回更新后的完整配置对象，避免调用方再次 [getConfiguration]。
     *
     * 适用于 data class 的 copy 模式：
     * ```kotlin
     * val updated = repository.updateConfiguration {
     *     it.copy(platforms = newPlatforms)
     * }
     * ```
     *
     * @param updater 接收当前配置，返回更新后的新配置。
     * @return 更新后的完整配置对象。
     */
    suspend fun updateConfiguration(
        updater: (current: ConfigurationInfo) -> ConfigurationInfo,
    ): ConfigurationInfo

    /**
     * 清空所有配置数据。
     */
    suspend fun clearConfiguration()
}
