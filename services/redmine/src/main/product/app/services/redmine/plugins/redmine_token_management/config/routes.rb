RedmineApp::Application.routes.draw do
  match 'projects/:id/tokens/:action', :controller => 'tokens'
end
