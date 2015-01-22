# require 'bantu_soundex'

class DemographicsController < ApplicationController
  soap_service namespace: 'urn:WashOut'

  soap_action "get_patient_by_npid",
              :args   => { :npid => :string },
              :return => :string
  def get_patient_by_npid

    matches = PatientIdentifier.where(identifier: params[:npid], identifier_type: (PatientIdentifierType.where(name: "National id").first.id)) rescue []

    result = []

    matches.each do |id|

      patient = id.patient rescue nil

      record = {

          "Name" => "#{patient.person.fullname rescue nil}",
          "National ID" => "#{patient.national_id rescue nil}",
          "Sex" => "#{((!patient.person.gender.blank? rescue false) ? (patient.person.gender.match(/F/) ? "Female" :
              (patient.person.gender.match(/M/) ? "Male" : nil)) : nil) }",
          "Age" => "#{((Date.today - patient.person.birthdate) / 365).to_i rescue nil}",
          "Date of birth" => "#{patient.person.birthdate.strftime("%d/%b/%Y") rescue nil}",
          "First Name" => "#{patient.person.names.first.given_name rescue nil}",
          "Last Name" => "#{patient.person.names.first.family_name rescue nil}",
          "Middle Name" => "#{patient.person.names.first.middle_name rescue nil}",
          "Home Village" => "#{patient.person.addresses.first.neighborhood_cell rescue nil}",
          "Home T/A" => "#{patient.person.addresses.first.county_district rescue nil}",
          "Home District" => "#{patient.person.addresses.first.address2 rescue nil}",
          "Current Village" => "#{patient.person.addresses.first.city_village rescue nil}",
          "Current T/A" => "#{patient.person.addresses.first.township_division rescue nil}",
          "Current District" => "#{patient.person.addresses.first.state_province rescue nil}",
          "Current Residence" => "#{patient.person.addresses.first.address1 rescue nil}"

      }

      result << record

    end

    render :soap => result
  end

  soap_action "get_patient_by_name",
              :args   => { :firstname => :string, :lastname => :string, :gender => :string },
              :return => :string
  def get_patient_by_name

    matches = Person.joins(:names => :person_name_code).where("person_name_code.given_name_code" => params[:firstname].soundex,
                                                              "person_name_code.family_name_code" => params[:lastname].soundex,
                                                              gender: (params[:gender].to_s[0] rescue nil)) # rescue []

    result = []

    matches.each do |id|

      patient = id.patient rescue nil

      record = {

          "Name" => "#{patient.person.fullname rescue nil}",
          "National ID" => "#{patient.national_id rescue nil}",
          "Sex" => "#{((!patient.person.gender.blank? rescue false) ? (patient.person.gender.match(/F/) ? "Female" :
              (patient.person.gender.match(/M/) ? "Male" : nil)) : nil) }",
          "Age" => "#{((Date.today - patient.person.birthdate) / 365).to_i rescue nil}",
          "Date of birth" => "#{patient.person.birthdate.strftime("%d/%b/%Y") rescue nil}",
          "First Name" => "#{patient.person.names.first.given_name rescue nil}",
          "Last Name" => "#{patient.person.names.first.family_name rescue nil}",
          "Middle Name" => "#{patient.person.names.first.middle_name rescue nil}",
          "Home Village" => "#{patient.person.addresses.first.neighborhood_cell rescue nil}",
          "Home T/A" => "#{patient.person.addresses.first.county_district rescue nil}",
          "Home District" => "#{patient.person.addresses.first.address2 rescue nil}",
          "Current Village" => "#{patient.person.addresses.first.city_village rescue nil}",
          "Current T/A" => "#{patient.person.addresses.first.township_division rescue nil}",
          "Current District" => "#{patient.person.addresses.first.state_province rescue nil}",
          "Current Residence" => "#{patient.person.addresses.first.address1 rescue nil}"

      }

      result << record

    end

    render :soap => result
  end

  soap_action "get_patient_by_name_and_dob",
              :args   => { :firstname => :string, :lastname => :string, :gender => :string, :birthdate => :string },
              :return => :string
  def get_patient_by_name_and_dob

    matches = Person.joins(:names => :person_name_code).where("person_name_code.given_name_code" => params[:firstname].soundex,
                                                              "person_name_code.family_name_code" => params[:lastname].soundex,
                                                              gender: (params[:gender].to_s[0] rescue nil),
                                                              :birthdate => (params[:birthdate].to_date.strftime("%Y-%m-%d") rescue nil)) # rescue []

    result = []

    matches.each do |id|

      patient = id.patient rescue nil

      record = {

          "Name" => "#{patient.person.fullname rescue nil}",
          "National ID" => "#{patient.national_id rescue nil}",
          "Sex" => "#{((!patient.person.gender.blank? rescue false) ? (patient.person.gender.match(/F/) ? "Female" :
              (patient.person.gender.match(/M/) ? "Male" : nil)) : nil) }",
          "Age" => "#{((Date.today - patient.person.birthdate) / 365).to_i rescue nil}",
          "Date of birth" => "#{patient.person.birthdate.strftime("%d/%b/%Y") rescue nil}",
          "First Name" => "#{patient.person.names.first.given_name rescue nil}",
          "Last Name" => "#{patient.person.names.first.family_name rescue nil}",
          "Middle Name" => "#{patient.person.names.first.middle_name rescue nil}",
          "Home Village" => "#{patient.person.addresses.first.neighborhood_cell rescue nil}",
          "Home T/A" => "#{patient.person.addresses.first.county_district rescue nil}",
          "Home District" => "#{patient.person.addresses.first.address2 rescue nil}",
          "Current Village" => "#{patient.person.addresses.first.city_village rescue nil}",
          "Current T/A" => "#{patient.person.addresses.first.township_division rescue nil}",
          "Current District" => "#{patient.person.addresses.first.state_province rescue nil}",
          "Current Residence" => "#{patient.person.addresses.first.address1 rescue nil}"

      }

      result << record

    end

    render :soap => result
  end

end
