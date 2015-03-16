class DamsObjectDatastream < DamsResourceDatastream
  include Dams::ModelHelper
  include Dams::DamsObject
    
  def load_copyright ( copyright )
    if !copyright.first.nil? && !copyright.first.status.first.nil?
      copyright.first
    else
      loadRdfObjects(copyright, DamsCopyright).first
    end
  end
  def load_license
    load_license(license)
  end
  def load_license (license)
    if !license.first.nil? && (!license.first.note.first.nil? || !license.first.uri.first.nil?)
      license.first
    else
      loadRdfObjects(license, DamsLicense).first
    end
  end
  def load_statute
    load_statute(statute)
  end
  def load_statute (statute)
    if !statute.first.nil? && !statute.first.citation.first.nil?
      statute.first
    else
      loadRdfObjects(statute, DamsStatute).first
    end
  end
  def load_otherRights
    load_otherRights(otherRights)
  end
  def load_otherRights (otherRights)
    loadRdfObjects(otherRights, DamsOtherRight).first
  end

  def rightsHolder
    rightsHolderPersonal.concat(rightsHolderCorporate).concat(rightsHolderFamily).concat(rightsHolderConference).concat(rightsHolderName)
  end
  def load_rightsHolders
    load_rightsHolders(rightsHolder)
  end
  def load_rightsHolders(rightsHolder)
    loadRdfObjects rightsHolder, MadsPersonalName
  end 
end
