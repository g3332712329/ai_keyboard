package com.dboy.ai_keyboard.config

import android.annotation.SuppressLint
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/**
 * 完整配置信息。
 *
 * 与 Flutter 端的 ConfigurationInfo 字段一一对应，
 * 以 JSON 字符串形式存储在 MMKV 中。
 */
@SuppressLint("UnsafeOptInUsageError")
@Serializable
data class ConfigurationInfo(
    /**
     * 配置数据版本号，用于后续数据结构变更时的迁移兼容。
     */
    @SerialName("version")
    val version: Int = 1,

    /**
     * AI 平台配置列表。
     */
    @SerialName("platforms")
    val platforms: List<AiPlatform> = listOf(),

    /**
     * 应用偏好设置。
     */
    @SerialName("preferences")
    val preferences: List<AppPreference> = listOf(),

    /**
     * 回复风格配置（9 种内置风格）。
     */
    @SerialName("replyStyles")
    val replyStyles: List<ReplyStyle> = listOf(),
)

/**
 * AI 平台配置。
 */
@SuppressLint("UnsafeOptInUsageError")
@Serializable
data class AiPlatform(
    @SerialName("name")
    val name: String = "",

    @SerialName("baseUrl")
    val baseUrl: String = "",

    @SerialName("apiKey")
    val apiKey: String = "",

    /**
     * 该平台可用的模型列表（内置默认值 + API 刷新）。
     */
    @SerialName("models")
    val models: List<String> = emptyList(),

    /**
     * 当前选中的模型。
     */
    @SerialName("selectedModel")
    val selectedModel: String = "",

    /**
     * 是否启用该平台。
     */
    @SerialName("enable")
    val enable: Boolean = false,
)

/**
 * 回复风格配置。
 */
@SuppressLint("UnsafeOptInUsageError")
@Serializable
data class ReplyStyle(
    @SerialName("id")
    val id: Int = 0,

    @SerialName("name")
    val name: String = "",

    /**
     * System Prompt，用于风格编辑功能。
     */
    @SerialName("prompt")
    val prompt: String = "",

    /**
     * 是否是用户自定义风格。
     */
    @SerialName("isCustomization")
    val isCustomization: Boolean = false,
)

/**
 * 应用偏好设置。
 */
@SuppressLint("UnsafeOptInUsageError")
@Serializable
data class AppPreference(
    @SerialName("key")
    val key: String = "",

    @SerialName("name")
    val name: String = "",

    @SerialName("desc")
    val desc: String = "",

    /**
     * 开关状态，非空，默认关闭。
     */
    @SerialName("isOpen")
    val isOpen: Boolean = false,
)

/**
 * 自动发送偏好 key。
 */
internal const val APP_PREFERENCE_KEY_AUTO_SEND = "auto_send"




