class PersonAttributeType < ActiveRecord::Base
    self.table_name = 'person_attribute_type'
    self.primary_key = :person_attribute_type_id

    default_scope { where(:voided => 0) } if column_names.include?("voided")

end
