if Rails::VERSION::MAJOR < 3

    ActionController::Routing::Routes.draw do |map|
        map.connect('hooks/load',   :controller => 'hooks', :action => 'load')
        map.connect('hooks/tree',   :controller => 'hooks', :action => 'tree')
        map.connect('hooks/update', :controller => 'hooks', :action => 'update')
        map.connect('hooks/:hook',  :controller => 'hooks', :action => 'index')
        map.connect('hooks',        :controller => 'hooks', :action => 'index')
    end

else

    get  'hooks/load',   :to => 'hooks#load'
    get  'hooks/tree',   :to => 'hooks#tree'
    post 'hooks/update', :to => 'hooks#update'
    get  'hooks/:hook',  :to => 'hooks#index'
    get  'hooks',        :to => 'hooks#index'

end
