package com.dboy.ai_keyboard.base

import android.inputmethodservice.InputMethodService
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.LifecycleRegistry
import androidx.lifecycle.ViewModelStore
import androidx.lifecycle.ViewModelStoreOwner
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel

/**
 * 带生命周期管理的输入法服务基类。
 *
 * [InputMethodService] 本身不是 [LifecycleOwner]，也不支持 [ViewModelStoreOwner]。
 * 这个基类把这两套能力封装起来，子类只需要关注业务逻辑。
 *
 * 提供的生命周期约定：
 * - [onCreate] 分发 ON_CREATE
 * - [onWindowShown] 分发 ON_START + ON_RESUME，并创建 [windowScope]
 * - [onWindowHidden] 分发 ON_PAUSE + ON_STOP，并取消 [windowScope]
 * - [onDestroy] 分发 ON_DESTROY，并清空 [viewModelStore]
 */
open class BaseInputMethodService : InputMethodService(), LifecycleOwner, ViewModelStoreOwner {

    /**
     * 用于分发 Service 生命周期事件。
     */
    private val lifecycleRegistry = LifecycleRegistry(this)

    override val lifecycle: Lifecycle
        get() = lifecycleRegistry

    /**
     * 用于存储 ViewModel，跟随 Service 生命周期。
     */
    override val viewModelStore = ViewModelStore()

    /**
     * 键盘窗口可见期间的协程作用域。
     *
     * 在 [onWindowShown] 中创建，在 [onWindowHidden] 中取消。
     * 子类通过 [windowScope] 启动协程，键盘收起时会自动取消。
     */
    private var _windowScope: CoroutineScope? = null

    /**
     * 获取当前窗口级协程作用域。
     *
     * 仅在键盘窗口显示期间非空，收起后为 null。
     */
    protected val windowScope: CoroutineScope?
        get() = _windowScope

    override fun onCreate() {
        super.onCreate()
        lifecycleRegistry.handleLifecycleEvent(Lifecycle.Event.ON_CREATE)
    }

    override fun onWindowShown() {
        super.onWindowShown()
        lifecycleRegistry.handleLifecycleEvent(Lifecycle.Event.ON_START)
        lifecycleRegistry.handleLifecycleEvent(Lifecycle.Event.ON_RESUME)

        if (_windowScope == null) {
            _windowScope = CoroutineScope(SupervisorJob() + Dispatchers.Main.immediate)
        }
    }

    override fun onWindowHidden() {
        super.onWindowHidden()
        _windowScope?.cancel()
        _windowScope = null

        lifecycleRegistry.handleLifecycleEvent(Lifecycle.Event.ON_PAUSE)
        lifecycleRegistry.handleLifecycleEvent(Lifecycle.Event.ON_STOP)
    }

    override fun onDestroy() {
        lifecycleRegistry.handleLifecycleEvent(Lifecycle.Event.ON_DESTROY)
        viewModelStore.clear()
        super.onDestroy()
    }
}
