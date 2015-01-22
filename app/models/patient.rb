class Patient < ActiveRecord::Base
    self.table_name = 'patient'
    self.primary_key = :patient_id

    has_one :person, :foreign_key => :person_id
    has_many :patient_identifiers, :foreign_key => :patient_id, :dependent => :destroy

    default_scope { where(:voided => 0) } if column_names.include?("voided")

  def national_id

    "#{self.patient_identifiers.where(identifier_type: (PatientIdentifierType.where(name: "National id").first.id)).first.identifier rescue nil}"

  end

end
