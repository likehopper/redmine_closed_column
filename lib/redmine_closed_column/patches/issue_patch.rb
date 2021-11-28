module RedmineClosedColumn

  module Patches
    
    module IssuePatch
      
      def first_closed_date
        _sql = "SELECT journals.created_on FROM journals INNER JOIN journal_details ON ( journals.id = journal_details.journal_id ) WHERE journals.journalized_id = #{id} AND journal_details.prop_key = 'status_id' AND journal_details.property = 'attr' AND journal_details.value::INTEGER IN ( SELECT is_close.id FROM issue_statuses AS is_close WHERE is_close.is_closed ) ORDER BY journals.created_on ASC LIMIT 1 "
	      result = ActiveRecord::Base.connection.select_value _sql
        unless result.nil?
          @first_closed_date ||= format_time(result, true)
        end
      end # def first_closed_date

      def last_closed_date
        _sql = "SELECT journals.created_on FROM journals INNER JOIN journal_details ON ( journals.id = journal_details.journal_id ) WHERE journals.journalized_id = #{id} AND journal_details.prop_key = 'status_id' AND journal_details.property = 'attr' AND journal_details.value::INTEGER IN ( SELECT is_close.id FROM issue_statuses is_close WHERE is_close.is_closed ) ORDER BY journals.created_on DESC LIMIT 1 ;"
	       result = ActiveRecord::Base.connection.select_value _sql
        unless result.nil?
          @last_closed_date ||= format_time(result, true)
        end
      end # def last_closed_date

      def count_closes
        _sql = "SELECT count(journals.created_on) FROM journals INNER JOIN journal_details ON ( journals.id = journal_details.journal_id )  WHERE journals.journalized_id = #{id} AND journal_details.prop_key = 'status_id' AND journal_details.property = 'attr' AND journal_details.value::INTEGER IN (SELECT is_close.id FROM issue_statuses is_close WHERE is_close.is_closed ) ;"
	      result = ActiveRecord::Base.connection.select_value _sql
        unless result.nil?
          @count_closes ||= result
        end
      end # def count_closes
      
    end # module IssuePatch

  end # module Patches

end # module RedmineClosedColumn