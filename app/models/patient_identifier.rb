class PatientIdentifier < ActiveRecord::Base
    self.table_name = 'patient_identifier'
    self.primary_key = :patient_identifier_id

end
