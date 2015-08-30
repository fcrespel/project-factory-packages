class HooksManagerHook  < Redmine::Hook::ViewListener

    def view_layouts_base_html_head(context = {})
        head = stylesheet_link_tag('hooks', :plugin => 'hooks_manager')
        hook = Hook.find_by_hook('view_layouts_base_html_head')
        head << hook.html_code.html_safe if hook
        head
    end

    def respond_to?(method)
        if HooksManager::Placeholders[method]
            true
        else
            super
        end
    end

    def method_missing(symbol, *args, &block)
        if HooksManager::Placeholders[symbol]
            hook = Hook.find_by_hook(symbol.to_s)
            return hook.html_code if hook
        end
        return ''
    end

end
