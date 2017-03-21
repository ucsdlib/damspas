require 'open-uri'
require 'httparty'

module Dams
  module ShareApi
    
    def self.share_push(pid)
      env = Rails.env || 'production'
      msg = ""
   
      begin
        if env == 'production' ||  env == 'staging' || env == 'development'
          hostname = Rails.configuration.host_name
          doc = JSON.load(open("#{hostname}/collection/#{pid}/osf_data"))


          if is_public?(doc) 
          
            document = ShareNotify::PushDocument.new("#{hostname}/collection/#{pid}", osf_date(doc))
            document.title = osf_title(doc)
            document.description = osf_description(doc)
            document.publisher = osf_publisher
            document.languages = osf_languages(doc)
            document.tags = osf_mads_fields(doc)
            osf_contributors(doc).each do |contributor|
              document.add_contributor(contributor)
            end
            
            if document.valid?
              @headers = {'Authorization' => "Token #{share_config.fetch('token')}", 
                         'Content-Type'  => 'application/json'
                        }

              @route = "#{share_config.fetch('host')}api/v1/share/data"
              @response = with_timeout { HTTParty.post(@route, body: document.to_share.to_json, headers: @headers)}
              msg = "success"
            else
              msg = "failed"
            end
          else
            msg = "non-public"
          end
        end
      rescue Exception => e
        p e
      end
    end
    
    def self.is_public?(document)
      !document.nil?
    end
 
    def self.share_config
      env = Rails.env || 'test'
      @config ||= YAML.load(ERB.new(IO.read(File.join(Rails.root, 'config', 'share_notify.yml'))).result)[env].with_indifferent_access
    end

    def self.with_timeout(&_block)
      Timeout.timeout(5) { yield }
    end

    #Mapping for OSF API
    def self.osf_title(document)
        field_name = "title_json_tesim"
        dams_data= document["#{field_name}"]
        osf_data=''

      if dams_data != nil
        dams_data.each do |datum|
          title = JSON.parse(datum)
          osf_data = title['name'] ? title['name'] : ''
          osf_data += title['name'] && !title['translationVariant'].blank? ? ' : ' : ''
          title_trans = title['translationVariant'] || []
          if title_trans.class == Array
            title_trans.each do |trans|  
              osf_data += trans
            end
          elsif title_trans.class == String
            osf_data += title_trans
          end
        end
      end
      osf_data
    end

    def self.osf_contributors(document)
      field_name = "relationship_json_tesim"
      dams_data = document["#{field_name}"]
      osf_data =[]

      if dams_data != nil
        dams_data.each do |datum|
          
          relationships = JSON.parse(datum)
          relationships.each do |key, value|
            value.each do |v|
              osf_data << {"name": v}
            end
          end
        end
      end
      osf_data = (osf_data.blank?) ? osf_data << {"name": "UC San Diego Library"} : osf_data
    end

    def self.osf_description(document)
      field_name = "otherNote_json_tesim"
      dams_data = document["#{field_name}"]
      osf_data = ''

      if dams_data != nil
        dams_data.each do |datum|
          other_note = JSON.parse(datum)
          osf_data = other_note['value'] if other_note['type'] == 'description'
        end
      end
      osf_data
    end 

    def self.osf_uris(document)
      field_name = "id"
      dams_data = document["#{field_name}"]
      osf_data = {}

      if dams_data != nil
        url = "http://library.ucsd.edu/dc/collection/#{dams_data}"
        osf_data = {"canonicalUri": url, "providerUris": url}
      end
      osf_data
    end

    def self.osf_date(document)
      field_name = "date_json_tesim"
      dams_data = document["#{field_name}"]
      osf_data = ''
      
      if dams_data != nil
        dams_data.each do |datum|
          date = JSON.parse(datum)
          if date['type'] == 'issued'
            d_date = date['beginDate']|| ''
            osf_data = DateTime.new(d_date.to_i,1,1) if d_date.match( '^\d{4}$' )
          end
        end
      end
      osf_data = (osf_data.is_a?(Time) || osf_data.is_a?(DateTime)) ? osf_data : Time.now
    end

    def self.osf_languages(document)
      field_name = "language_tesim"
      dams_data = document["#{field_name}"]
      langs = dams_data || []
      osf_data = []

      if langs.class == Array
        langs.each do |lang|  
          osf_data << lang
        end
      elsif langs.class == String
        osf_data << langs
      end
      osf_data 
    end

    def self.osf_mads_fields(document)
      osf_data = []

      field_names = [
        'geographic_tesim', 
        'topic_tesim',
        'commonName_tesim', 
        'scientificName_tesim', 
        'corporateName_tesim',
        'personalName_tesim',
        'subject_tesim',
        'genreForm_tesim',
        'anatomy_tesim',
        'cruise_tesim',
        'series_tesim',
        'culturalContext_tesim',
        'lithology_tesim'
      ]
      field_names.each do |field_name|
        dams_data = document["#{field_name}"]
        if dams_data.kind_of?(String)
          osf_data << dams_data 
        elsif dams_data.kind_of?(Array)
          dams_data.each do |datum| 
            osf_data << datum
          end
        end 
      end
      osf_data
    end

    def self.osf_publisher
      osf_data = {"name": "UC San Diego Library, Digital Collections", "uri": "http://library.ucsd.edu/dc"}
    end

    def self.export_to_API(document)
      field_map = {
        'title': osf_title(document),
        'description': osf_description(document),
        'contributor': osf_contributors(document),
        'uris': osf_uris(document),
        'languages': osf_languages(document),
        'providerUpdatedDateTime': osf_date(document),
        'tags': osf_mads_fields(document),
        'publisher': osf_publisher
      }
      json_data = {"jsonData": field_map}
    end
  end
end
