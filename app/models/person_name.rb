class PersonName < ActiveRecord::Base
    self.table_name = 'person_name'
    self.primary_key = :person_name_id

    belongs_to :person, :foreign_key => :person_id
    has_one :person_name_code, :foreign_key => :person_name_id

    default_scope { order('preferred DESC') }

    default_scope { where(:voided => 0) } if column_names.include?("voided")

end
