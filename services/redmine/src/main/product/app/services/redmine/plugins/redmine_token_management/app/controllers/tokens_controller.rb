class TokensController < ApplicationController
  unloadable

  before_filter :find_project, :authorize, :only => :index  
  
  def index
    @project_custom_fields = ProjectCustomField.find(:all)
    @time_entry_custom_fields = TimeEntryCustomField.find(:all)
    @custom_values = CustomValue.find(:all)
    all_issues = Issue.find(:all)
    all_time_entries = TimeEntry.find(:all)
    all_trackers = Tracker.find(:all)
    all_enumerations = Enumeration.find(:all)
    find_all_custom_values()
    find_all_issues(all_issues, all_time_entries, all_trackers, all_enumerations)
  end
  
  def find_all_custom_values()
    @contractStartDate = find_custom_value(@project_custom_fields, @custom_values, Setting.plugin_redmine_token_management["var_lab_contract_start_date"])
    @qualifyingPeriod = find_custom_value(@project_custom_fields, @custom_values, Setting.plugin_redmine_token_management["var_lab_qualifying_period"])
    @tokensCost = find_custom_value(@project_custom_fields, @custom_values, Setting.plugin_redmine_token_management["var_lab_tokens_cost"])
    @tokensBought = find_custom_value(@project_custom_fields, @custom_values, Setting.plugin_redmine_token_management["var_lab_tokens_bought"])
    @tokensConsumed = 0
  end   

  def find_all_issues(all_issues, all_time_entries, all_trackers, all_enumerations)
    @currentIssue = Array.new
	
	custom_field_index = find_custom_field(@time_entry_custom_fields, Setting.plugin_redmine_token_management["var_lab_tokens_consumed"])
    all_issues.each{ |issue|
      currentTokensIssue = 0.0
      if (issue.project_id == @project.id)
        all_time_entries.each{ |time_entry|
          if (time_entry.issue_id == issue.id)
            currentTokensByTimeEntry = find_token_by_time_entry(time_entry.id, custom_field_index, @custom_values)
            currentTokensIssue += currentTokensByTimeEntry.to_f
          end
        }
        currentTracker = find_tracker(issue.tracker_id, all_trackers)
        currentPriority = find_priority(issue.priority_id, all_enumerations)
        @currentIssue.insert(-1, Hash["id", issue.id, "subject", issue.subject , "tokens", currentTokensIssue, 
                  "updateDate", issue.updated_on.to_date, "tracker", currentTracker, "priority", currentPriority])
        @tokensConsumed += currentTokensIssue
      end
    }
  end
  
    
  private
  def find_project
    # @project variable must be set before calling the authorize filter
    @project = Project.find(params[:id])
  end
  
  def find_custom_field(custom_fields, custom_field_name)
    ret = nil
    custom_fields.each{ |custom_field|
      if (custom_field.name == custom_field_name)
        ret = custom_field.id 
      end
    }
	return ret
  end
  
  def find_custom_value(project_custom_fields, custom_values, custom_field_name)
    ret = nil
    custom_field_index = find_custom_field(project_custom_fields, custom_field_name)
    custom_values.each{ |custom_value|
      if (custom_value.customized_id == @project.id) && (custom_value.custom_field_id == custom_field_index)
        ret = custom_value.value
      end
    }
	return ret
  end
  
  def find_token_by_time_entry(time_entry_id, custom_field_index, custom_values)
    ret = 0
    custom_values.each{ |custom_value|
      if (custom_value.customized_id == time_entry_id) && (custom_value.custom_field_id == custom_field_index)
        ret = custom_value.value.to_f
      end
    }
	return ret
  end
  
  def find_tracker(tracker_id, all_trackers)
    ret = nil
    all_trackers.each{ |tracker|
      if (tracker.id == tracker_id)
        ret = tracker.name
      end
    }
	return ret
  end
  
  def find_priority(priority_id, allEnumeration)
    ret = nil
    allEnumeration.each{ |enumeration|
      if (enumeration.id == priority_id)
        ret = enumeration.name
      end
    }
	return ret
  end
  
end
