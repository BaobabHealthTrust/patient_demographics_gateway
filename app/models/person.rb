class Person < ActiveRecord::Base
    self.table_name = 'person'
    self.primary_key = :person_id

    has_one :patient, :foreign_key => :patient_id, :dependent => :destroy
    has_many :names, :class_name => 'PersonName', :foreign_key => :person_id, :dependent => :destroy
    has_many :addresses, :class_name => 'PersonAddress', :foreign_key => :person_id, :dependent => :destroy

    default_scope { where(:voided => 0) } if column_names.include?("voided")

end
