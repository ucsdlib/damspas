class DamsObject < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsObjectDatastream 
  delegate_to "damsMetadata", [:title, :typeOfResource, :subtitle, :date, :beginDate, :endDate, :subject, :component, :file, :relatedResource, :notes ]
  def languages
    damsMetadata.load_languages
  end
  def units
    damsMetadata.load_unit
  end
  def collections
    damsMetadata.load_collection
  end
  def copyrights
    damsMetadata.load_copyright
  end
  def licenses
    damsMetadata.load_license
  end
  def statutes
    damsMetadata.load_statute
  end
  def otherRights
    damsMetadata.load_otherRights
  end
  def rightsHolders
    damsMetadata.load_rightsHolders
  end
end
