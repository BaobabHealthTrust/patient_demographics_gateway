class PersonNameCode < ActiveRecord::Base
    self.table_name = 'person_name_code'
    self.primary_key = :person_name_code_id

    belongs_to :person_name

    default_scope { where(:voided => 0) } if column_names.include?("voided")

end
