class DamsFunctionInternal
  include ActiveFedora::RdfObject
  include Dams::DamsFunction
  def pid
      rdf_subject.to_s.gsub(/.*\//,'')
  end

end
