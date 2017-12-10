require 'redmine'
require 'placeholders'

require_dependency 'hooks_manager_hook'

Rails.logger.info 'Starting Hooks Manager Plugin for Redmine'

Redmine::Plugin.register :hooks_manager do
    name 'Hooks manager'
    author 'Andriy Lesyuk'
    author_url 'http://www.andriylesyuk.com'
    description 'Allows specifying custom HTML code for different views in Redmine.'
    url 'http://projects.andriylesyuk.com/projects/hooks-manager'
    version '1.0.1'

    menu :admin_menu, :hooks,
                    { :controller => 'hooks', :action => 'index' },
                      :caption => :label_hook_plural,
                      :after => :enumerations,
                      :html => {:class => 'icon icon-hooks'}
end

unless defined? ChiliProject::Liquid::Tags
    Redmine::WikiFormatting::Macros.register do
        desc "Allows to embed custom HTML into Wiki content.\n\n" + 
             "All arguments get automatically converted to JavaScript variables, if any HTML content is defined for the @:view_wiki_inline_content@ hook through the Hooks Manager.\n\n" +
             "Example:\n\n" +
             "  !{{inline_hook(variable1=value1,variable2=value2)}}"
        macro :inline_hook do |page, args|
            vars = {}
            args.each do |arg|
                if arg =~ %r{^([a-z0-9_]+)\=(.*)$}i
                    vars[$1] = $2
                end
            end
            text = ''
            hook = Hook.find_by_hook('view_wiki_inline_content')
            if hook && vars.size > 0
                vars.each do |name, value|
                    text << "<script type=\"text/javascript\">\n"
                    text << "//<![CDATA[\n"
                    text << "#{name} = "
                    if value =~ %r{^(true|false|[0-9]+(\.[0-9]+)?)$}
                        text << value
                    else
                        text << '"' + value.gsub(%r{"}, '\\"') + '"'
                    end
                    text << ";\n"
                    text << "//]]>\n"
                    text << "</script>"
                end
            end
            text.html_safe + call_hook(:view_wiki_inline_content, { :page => page, :vars => vars })
        end
    end
end
