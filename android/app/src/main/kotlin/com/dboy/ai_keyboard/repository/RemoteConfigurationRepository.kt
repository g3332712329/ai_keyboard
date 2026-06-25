package com.dboy.ai_keyboard.repository

import com.dboy.ai_keyboard.config.ConfigurationInfo

/**
 * 云端配置仓库实现（预留）。
 *
 * 当前为占位实现，后续接入云端同步服务时替换为真实逻辑。
 * 现阶段调用任何方法都会抛出 [UnsupportedOperationException]。
 */
class RemoteConfigurationRepository : ConfigurationRepository {

    override suspend fun getConfiguration(): ConfigurationInfo {
        throw UnsupportedOperationException(
            "RemoteConfigurationRepository.getConfiguration() 尚未实现，" +
                "当前阶段请使用 LocalConfigurationRepository。",
        )
    }

    override suspend fun saveConfiguration(config: ConfigurationInfo) {
        throw UnsupportedOperationException(
            "RemoteConfigurationRepository.saveConfiguration() 尚未实现，" +
                "当前阶段请使用 LocalConfigurationRepository。",
        )
    }

    override suspend fun updateConfiguration(
        updater: (current: ConfigurationInfo) -> ConfigurationInfo,
    ): ConfigurationInfo {
        throw UnsupportedOperationException(
            "RemoteConfigurationRepository.updateConfiguration() 尚未实现，" +
                "当前阶段请使用 LocalConfigurationRepository。",
        )
    }

    override suspend fun clearConfiguration() {
        throw UnsupportedOperationException(
            "RemoteConfigurationRepository.clearConfiguration() 尚未实现，" +
                "当前阶段请使用 LocalConfigurationRepository。",
        )
    }
}
