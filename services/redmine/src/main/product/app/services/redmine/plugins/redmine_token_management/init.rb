# encoding: utf-8
require 'redmine'

Redmine::Plugin.register :redmine_token_management do
  name 'Redmine Token Management plugin'
  author 'Jeremy Mistero'
  author_url 'mailto:jeremy.mistero@cgi.com'
  description 'This plugin lets you track issue tokens (billing units) per project'
  version '1.2.1'
  requires_redmine :version_or_higher => '2.0.0'

  project_module :tokens do
    permission :view_tokens, :tokens => :index, :require => :member
  end
  
  settings :default => {
      'var_lab_tokens_consumed' => 'Jetons consommés',
      'var_lab_tokens_cost' => 'Coût du jeton',
      'var_lab_contract_start_date' => 'Date de début du contrat',
      'var_lab_qualifying_period' => 'Durée période probatoire(mois)',
      'var_lab_tokens_bought' => 'Jetons achetés',
      'show_issues' => 'true',
    }, :partial => 'settings/token_management_settings'
    
  menu :project_menu, :tokens, { :controller => 'tokens', :action => 'index' }, :param => :id, :caption => :tokens_name, :after => :activity
end

