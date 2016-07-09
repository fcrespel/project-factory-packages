RedmineApp::Application.routes.draw do
  get 'projects/:id/tokens/:action', :controller => 'tokens'
end
