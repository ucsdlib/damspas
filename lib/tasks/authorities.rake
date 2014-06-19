# $ rake authorities
# This task extract the column1 ISO and column5 country from countryInfo.txt pulling from remote.
# Generate yaml under config/authorities, format as:
# :terms:
# - :id: AD
#   :term: Andorra
#   :active: true
# ...

require 'open-uri' 

desc "Automate the process to create countries YAML"
task :authorities do 

  FileUtils::mkdir_p 'config/authorities'

  url = "http://download.geonames.org/export/dump/countryInfo.txt"
  local_fname = "config/authorities/countries.yml"
  arr_of_country = []
  hash_of_terms = {}

  open(url).each_line do |line|
    if line[0,1] != "#"
      tokens = line.split("\t")
      arr_of_country << {id: tokens[0], term: tokens[4], active: true }
     end
  end

  hash_of_terms = {terms: arr_of_country}

  File.open(local_fname, "w") {|file| file.write(hash_of_terms.to_yaml)}
end