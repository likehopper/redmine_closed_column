module RedmineClosedColumn

  module Patches

    module IssueQueryPatch

      def self.included(base)

        base.class_eval do

            unloadable
            
            self.available_columns << QueryColumn.new(
              :first_closed_date,
              :caption => :label_first_closed_date,
              :sortable => "(
                SELECT MIN(journals.created_on) AS journals_created_on
                FROM journals INNER JOIN journal_details ON ( journals.id = journal_details.journal_id )
                WHERE journals.journalized_id = issues.id AND journal_details.prop_key = 'status_id' AND journal_details.property = 'attr'
                AND journal_details.value::bigint IN (
                  SELECT is_close.id
                  FROM issue_statuses is_close
                  WHERE is_close.is_closed IS TRUE
                )
                ORDER BY journals_created_on
                LIMIT 1
              )",
            ) unless columns.detect{ |c| c.name == :first_closed_date }

            self.available_columns << QueryColumn.new(
              :last_closed_date,
              :caption => :label_last_closed_date,
              :sortable => "(
                SELECT MAX(journals.created_on) AS journals_created_on
                FROM journals INNER JOIN journal_details ON ( journals.id = journal_details.journal_id )
                WHERE journals.journalized_id = issues.id AND journal_details.prop_key = 'status_id' AND journal_details.property = 'attr'
                AND journal_details.value::bigint IN (
                  SELECT is_close.id
                  FROM issue_statuses is_close
                  WHERE is_close.is_closed IS TRUE
                )
                ORDER BY journals_created_on
                LIMIT 1 
              )"
            ) unless columns.detect{ |c| c.name == :last_closed_date }

            self.available_columns << QueryColumn.new(
              :count_closes,
              :caption => :label_count_closes,
              :sortable => "(
                SELECT COUNT(journals.created_on)
                FROM journals INNER JOIN journal_details ON ( journals.id = journal_details.journal_id )
                WHERE journals.journalized_id = issues.id AND journal_details.prop_key = 'status_id' AND journal_details.property = 'attr'
                AND journal_details.value::bigint IN (
                  SELECT is_close.id
                  FROM issue_statuses is_close
                  WHERE is_close.is_closed IS TRUE
                )
                ORDER BY COUNT(journals.created_on)
                LIMIT 1
              )"
            ) unless columns.detect{ |c| c.name == :count_closes }

        end # base.class_eval do

      end # def self.included(base)

    end # module IssueQueryPatch

  end # module Patches

end # module RedmineClosedColumn