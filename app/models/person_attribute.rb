class PersonAttribute < ActiveRecord::Base
    self.table_name = 'person_attribute'
    self.primary_key = :person_attribute_id

    belongs_to :type, :class_name => "PersonAttributeType", :foreign_key => :person_attribute_type_id
    belongs_to :person, :foreign_key => :person_id

    default_scope { where(:voided => 0) } if column_names.include?("voided")

end
