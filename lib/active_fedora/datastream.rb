module ActiveFedora

  #This class represents a Fedora datastream
  class Datastream < Rubydora::Datastream

    ## override solrize_profile to catch date parsing problems
    def solrize_profile # :nodoc:
      profile_hash = {}
      profile.each_pair do |property,value|
        if property =~ /Date/
          begin
            value = Time.parse(value) unless value.is_a?(Time)
            value = value.xmlschema
          rescue Exception => e
            puts "Error: #{e}: #{value}"
          end
        end
        profile_hash[property] = value
      end
      profile_hash
    end
  end
end
