require 'redmine'
require 'redmine_closed_column'

Redmine::Plugin.register :redmine_closed_column do

  name 'Redmine closed column'
  author 'Vincent VIGNOLLE'
  description 'This plugin adds a first closed date, last closed date and count closes column to issue lists.'
  version RedmineClosedColumn::VERSION
  author_url 'https://github.com/likehopper'  
  url 'https://github.com/likehopper/redmine_closed_column'


  requires_redmine :version_or_higher => '4.2.0'

  ActiveSupport::Reloader.to_prepare do

    unless Issue.included_modules.include? RedmineClosedColumn::Patches::IssuePatch
      Issue.send(:include, RedmineClosedColumn::Patches::IssuePatch)
    end

    if (ActiveRecord::Base.connection.tables.include?('queries') rescue false) &&
      IssueQuery.included_modules.exclude?(RedmineClosedColumn::Patches::IssueQueryPatch)
      IssueQuery.send(:include, RedmineClosedColumn::Patches::IssueQueryPatch)
    end      

  end # ActiveSupport::Reloader.to_prepare do

end # Redmine::Plugin.register :redmine_closed_column do