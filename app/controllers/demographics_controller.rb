
class DemographicsController < ApplicationController
  soap_service namespace: 'urn:http://www.baobabhealth.org/', wsse_auth_callback: ->(username, password) {
    return !User.authenticate(username, password).blank?
  }

  soap_action "get_patient_by_npid",
              :args   => { :npid => :string },
              :return => :string
  def get_patient_by_npid

    matches = PatientIdentifier.where(identifier: params[:npid], identifier_type: (PatientIdentifierType.where(name: "National id").first.id)) rescue []

    string = ""

    matches.each do |id|

      patient = id.patient rescue nil

      string = string + '<Result diffgr:id="' + patient.id.to_s + '" msdata:rowOrder="0">
          <NationalId>' + "#{patient.national_id rescue nil}" + '</NationalId>
          <FullName>' + "#{patient.person.fullname rescue nil}" + '</FullName>
          <Sex>' + "#{((!patient.person.gender.blank? rescue false) ? (patient.person.gender.match(/F/) ? "Female" :
          (patient.person.gender.match(/M/) ? "Male" : nil)) : nil) }" + '</Sex>
          <Age>' + "#{((Date.today - patient.person.birthdate) / 365).to_i rescue nil}" + '</Age>
          <DateOfBirth>' + "#{patient.person.birthdate.strftime("%d/%b/%Y") rescue nil}" + '</DateOfBirth>
          <FirstName>' + "#{patient.person.names.first.given_name rescue nil}" + '</FirstName>
          <LastName>' + "#{patient.person.names.first.family_name rescue nil}" + '</LastName>
          <MiddleName>' + "#{patient.person.names.first.middle_name rescue nil}" + '</MiddleName>
          <HomeVillage>' + "#{patient.person.addresses.first.neighborhood_cell rescue nil}" + '</HomeVillage>
          <HomeTA>' + "#{patient.person.addresses.first.county_district rescue nil}" + '</HomeTA>
          <HomeDistrict>' + "#{patient.person.addresses.first.address2 rescue nil}" + '</HomeDistrict>
          <CurrentVillage>' + "#{patient.person.addresses.first.city_village rescue nil}" + '</CurrentVillage>
          <CurrentTA>' + "#{patient.person.addresses.first.township_division rescue nil}" + '</CurrentTA>
          <CurrentDistrict>' + "#{patient.person.addresses.first.state_province rescue nil}" + '</CurrentDistrict>
          <CurrentResidence>' + "#{patient.person.addresses.first.address1 rescue nil}" + '</CurrentResidence>
      </Result>'

    end

    xml = '<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <soap:Body>
        <GetPatientByNpidResultsResponse xmlns="http://www.baobabhealth.org/">
            <GetPatientListResult>
                <xs:schema id="Patient" xmlns="" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:msdata="urn:schemas-microsoft-com:xml-msdata">
                    <xs:element name="NewDataSet" msdata:IsDataSet="true" msdata:MainDataTable="Result" msdata:UseCurrentLocale="true">
                        <xs:complexType>
                            <xs:choice minOccurs="0" maxOccurs="unbounded">
                                <xs:element name="Result">
                                    <xs:complexType>
                                        <xs:sequence>
                                            <xs:element name="NationalId" type="xs:string" minOccurs="0" />
                                            <xs:element name="FullName" type="xs:string" minOccurs="0" />
                                            <xs:element name="Sex" type="xs:string" minOccurs="0" />
                                            <xs:element name="Age" type="xs:string" minOccurs="0" />
                                            <xs:element name="DateOfBirth" type="xs:string" minOccurs="0" />
                                            <xs:element name="FirstName" type="xs:string" minOccurs="0" />
                                            <xs:element name="LastName" type="xs:string" minOccurs="0" />
                                            <xs:element name="MiddleName" type="xs:string" minOccurs="0" />
                                            <xs:element name="HomeVillage" type="xs:string" minOccurs="0" />
                                            <xs:element name="HomeTA" type="xs:string" minOccurs="0" />
                                            <xs:element name="HomeDistrict" type="xs:string" minOccurs="0" />
                                            <xs:element name="CurrentVillage" type="xs:string" minOccurs="0" />
                                            <xs:element name="CurrentTA" type="xs:string" minOccurs="0" />
                                            <xs:element name="CurrentDistrict" type="xs:string" minOccurs="0" />
                                            <xs:element name="CurrentResidence" type="xs:string" minOccurs="0" />
                                        </xs:sequence>
                                    </xs:complexType>
                                </xs:element>
                            </xs:choice>
                        </xs:complexType>
                    </xs:element>
                </xs:schema>
                <diffgr:diffgram xmlns:msdata="urn:schemas-microsoft-com:xml-msdata" xmlns:diffgr="urn:schemas-microsoft-com:xml-diffgram-v1">
                    <DocumentElement xmlns="">' +
        string +
        '</DocumentElement>
                </diffgr:diffgram>
            </GetPatientListResult>
        </GetPatientByNpidResultsResponse>
    </soap:Body>
</soap:Envelope>'

    render :text => xml

  end

  soap_action "get_patient_by_name",
              :args   => { :firstname => :string, :lastname => :string, :gender => :string, :page => :integer, :pagesize => :integer },
              :return => :string
  def get_patient_by_name

    matches = Person.joins(:names => :person_name_code).where("person_name_code.given_name_code" => params[:firstname].soundex,
                                                              "person_name_code.family_name_code" => params[:lastname].soundex,
                                                              gender: (params[:gender].to_s[0] rescue nil)
    ).limit(params[:pagesize]).offset(params[:pagesize].to_i * params[:page].to_i) # rescue []

    string = ""

    matches.each do |id|

      patient = id.patient rescue nil

      string = string + '<Result diffgr:id="' + patient.id.to_s + '" msdata:rowOrder="0">
          <NationalId>' + "#{patient.national_id rescue nil}" + '</NationalId>
          <FullName>' + "#{patient.person.fullname rescue nil}" + '</FullName>
          <Sex>' + "#{((!patient.person.gender.blank? rescue false) ? (patient.person.gender.match(/F/) ? "Female" :
          (patient.person.gender.match(/M/) ? "Male" : nil)) : nil) }" + '</Sex>
          <Age>' + "#{((Date.today - patient.person.birthdate) / 365).to_i rescue nil}" + '</Age>
          <DateOfBirth>' + "#{patient.person.birthdate.strftime("%d/%b/%Y") rescue nil}" + '</DateOfBirth>
          <FirstName>' + "#{patient.person.names.first.given_name rescue nil}" + '</FirstName>
          <LastName>' + "#{patient.person.names.first.family_name rescue nil}" + '</LastName>
          <MiddleName>' + "#{patient.person.names.first.middle_name rescue nil}" + '</MiddleName>
          <HomeVillage>' + "#{patient.person.addresses.first.neighborhood_cell rescue nil}" + '</HomeVillage>
          <HomeTA>' + "#{patient.person.addresses.first.county_district rescue nil}" + '</HomeTA>
          <HomeDistrict>' + "#{patient.person.addresses.first.address2 rescue nil}" + '</HomeDistrict>
          <CurrentVillage>' + "#{patient.person.addresses.first.city_village rescue nil}" + '</CurrentVillage>
          <CurrentTA>' + "#{patient.person.addresses.first.township_division rescue nil}" + '</CurrentTA>
          <CurrentDistrict>' + "#{patient.person.addresses.first.state_province rescue nil}" + '</CurrentDistrict>
          <CurrentResidence>' + "#{patient.person.addresses.first.address1 rescue nil}" + '</CurrentResidence>
      </Result>'

    end

    xml = '<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <soap:Body>
        <GetPatientByNameResultsResponse xmlns="http://www.baobabhealth.org/">
            <GetPatientListResult>
                <xs:schema id="Patient" xmlns="" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:msdata="urn:schemas-microsoft-com:xml-msdata">
                    <xs:element name="NewDataSet" msdata:IsDataSet="true" msdata:MainDataTable="Result" msdata:UseCurrentLocale="true">
                        <xs:complexType>
                            <xs:choice minOccurs="0" maxOccurs="unbounded">
                                <xs:element name="Result">
                                    <xs:complexType>
                                        <xs:sequence>
                                            <xs:element name="NationalId" type="xs:string" minOccurs="0" />
                                            <xs:element name="FullName" type="xs:string" minOccurs="0" />
                                            <xs:element name="Sex" type="xs:string" minOccurs="0" />
                                            <xs:element name="Age" type="xs:string" minOccurs="0" />
                                            <xs:element name="DateOfBirth" type="xs:string" minOccurs="0" />
                                            <xs:element name="FirstName" type="xs:string" minOccurs="0" />
                                            <xs:element name="LastName" type="xs:string" minOccurs="0" />
                                            <xs:element name="MiddleName" type="xs:string" minOccurs="0" />
                                            <xs:element name="HomeVillage" type="xs:string" minOccurs="0" />
                                            <xs:element name="HomeTA" type="xs:string" minOccurs="0" />
                                            <xs:element name="HomeDistrict" type="xs:string" minOccurs="0" />
                                            <xs:element name="CurrentVillage" type="xs:string" minOccurs="0" />
                                            <xs:element name="CurrentTA" type="xs:string" minOccurs="0" />
                                            <xs:element name="CurrentDistrict" type="xs:string" minOccurs="0" />
                                            <xs:element name="CurrentResidence" type="xs:string" minOccurs="0" />
                                        </xs:sequence>
                                    </xs:complexType>
                                </xs:element>
                            </xs:choice>
                        </xs:complexType>
                    </xs:element>
                </xs:schema>
                <diffgr:diffgram xmlns:msdata="urn:schemas-microsoft-com:xml-msdata" xmlns:diffgr="urn:schemas-microsoft-com:xml-diffgram-v1">
                    <DocumentElement xmlns="">' +
        string +
        '</DocumentElement>
                </diffgr:diffgram>
            </GetPatientListResult>
        </GetPatientByNameResultsResponse>
    </soap:Body>
</soap:Envelope>'

    render :text => xml

  end

  soap_action "get_patient_by_name_and_dob",
              :args   => { :firstname => :string, :lastname => :string, :gender => :string, :birthdate => :string, :page => :integer, :pagesize => :integer },
              :return => :string
  def get_patient_by_name_and_dob

    matches = Person.joins(:names => :person_name_code).where("person_name_code.given_name_code" => params[:firstname].soundex,
                                                              "person_name_code.family_name_code" => params[:lastname].soundex,
                                                              gender: (params[:gender].to_s[0] rescue nil),
                                                              :birthdate => (params[:birthdate].to_date.strftime("%Y-%m-%d") rescue nil)
    ).limit(params[:pagesize]).offset(params[:pagesize].to_i * params[:page].to_i) # rescue []

    string = ""

    matches.each do |id|

      patient = id.patient rescue nil

      string = string + '<Result diffgr:id="' + patient.id.to_s + '" msdata:rowOrder="0">
          <NationalId>' + "#{patient.national_id rescue nil}" + '</NationalId>
          <FullName>' + "#{patient.person.fullname rescue nil}" + '</FullName>
          <Sex>' + "#{((!patient.person.gender.blank? rescue false) ? (patient.person.gender.match(/F/) ? "Female" :
          (patient.person.gender.match(/M/) ? "Male" : nil)) : nil) }" + '</Sex>
          <Age>' + "#{((Date.today - patient.person.birthdate) / 365).to_i rescue nil}" + '</Age>
          <DateOfBirth>' + "#{patient.person.birthdate.strftime("%d/%b/%Y") rescue nil}" + '</DateOfBirth>
          <FirstName>' + "#{patient.person.names.first.given_name rescue nil}" + '</FirstName>
          <LastName>' + "#{patient.person.names.first.family_name rescue nil}" + '</LastName>
          <MiddleName>' + "#{patient.person.names.first.middle_name rescue nil}" + '</MiddleName>
          <HomeVillage>' + "#{patient.person.addresses.first.neighborhood_cell rescue nil}" + '</HomeVillage>
          <HomeTA>' + "#{patient.person.addresses.first.county_district rescue nil}" + '</HomeTA>
          <HomeDistrict>' + "#{patient.person.addresses.first.address2 rescue nil}" + '</HomeDistrict>
          <CurrentVillage>' + "#{patient.person.addresses.first.city_village rescue nil}" + '</CurrentVillage>
          <CurrentTA>' + "#{patient.person.addresses.first.township_division rescue nil}" + '</CurrentTA>
          <CurrentDistrict>' + "#{patient.person.addresses.first.state_province rescue nil}" + '</CurrentDistrict>
          <CurrentResidence>' + "#{patient.person.addresses.first.address1 rescue nil}" + '</CurrentResidence>
      </Result>'

    end

    xml = '<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <soap:Body>
        <GetPatientByNameAndDobResultsResponse xmlns="http://www.baobabhealth.org/">
            <GetPatientListResult>
                <xs:schema id="Patient" xmlns="" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:msdata="urn:schemas-microsoft-com:xml-msdata">
                    <xs:element name="NewDataSet" msdata:IsDataSet="true" msdata:MainDataTable="Result" msdata:UseCurrentLocale="true">
                        <xs:complexType>
                            <xs:choice minOccurs="0" maxOccurs="unbounded">
                                <xs:element name="Result">
                                    <xs:complexType>
                                        <xs:sequence>
                                            <xs:element name="NationalId" type="xs:string" minOccurs="0" />
                                            <xs:element name="FullName" type="xs:string" minOccurs="0" />
                                            <xs:element name="Sex" type="xs:string" minOccurs="0" />
                                            <xs:element name="Age" type="xs:string" minOccurs="0" />
                                            <xs:element name="DateOfBirth" type="xs:string" minOccurs="0" />
                                            <xs:element name="FirstName" type="xs:string" minOccurs="0" />
                                            <xs:element name="LastName" type="xs:string" minOccurs="0" />
                                            <xs:element name="MiddleName" type="xs:string" minOccurs="0" />
                                            <xs:element name="HomeVillage" type="xs:string" minOccurs="0" />
                                            <xs:element name="HomeTA" type="xs:string" minOccurs="0" />
                                            <xs:element name="HomeDistrict" type="xs:string" minOccurs="0" />
                                            <xs:element name="CurrentVillage" type="xs:string" minOccurs="0" />
                                            <xs:element name="CurrentTA" type="xs:string" minOccurs="0" />
                                            <xs:element name="CurrentDistrict" type="xs:string" minOccurs="0" />
                                            <xs:element name="CurrentResidence" type="xs:string" minOccurs="0" />
                                        </xs:sequence>
                                    </xs:complexType>
                                </xs:element>
                            </xs:choice>
                        </xs:complexType>
                    </xs:element>
                </xs:schema>
                <diffgr:diffgram xmlns:msdata="urn:schemas-microsoft-com:xml-msdata" xmlns:diffgr="urn:schemas-microsoft-com:xml-diffgram-v1">
                    <DocumentElement xmlns="">' +
        string +
        '</DocumentElement>
                </diffgr:diffgram>
            </GetPatientListResult>
        </GetPatientByNameAndDobResultsResponse>
    </soap:Body>
</soap:Envelope>'

    render :text => xml

  end

end
