module RedmineClosedColumn

  Rails.configuration.to_prepare do

    # Patches
    require 'redmine_closed_column/patches/issue_patch'
    require 'redmine_closed_column/patches/issue_query_patch'

  end # Rails.configuration.to_prepare do

end # module RedmineSla