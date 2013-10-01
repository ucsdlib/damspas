class DamsObjectDatastream < DamsResourceDatastream
  include Dams::DamsObject
    
  def load_copyright ( copyright )
	if !copyright.first.nil?
	    c_pid = copyright.first.pid
	    if !copyright.first.status.first.nil? && copyright.first.status.to_s.length > 0
	      copyright.first
	    elsif c_pid.to_s.length > 0
	      DamsCopyright.find(c_pid)
	    end
	else
		nil
	end
  end
  def load_license
    load_license(license)
  end
  def load_license (license)
    foo = license.to_s
	if !license.first.nil?
	    l_pid = license.first.pid
	    
	    if (!license.first.note.first.nil? && license.first.note.first.length > 0) || ( !license.first.uri.first.nil? && license.first.uri.first.to_s.length > 0)
	      license.first
	    elsif l_pid.to_s.length > 0
	      DamsLicense.find(l_pid)
	    end
	end    
  end
  def load_statute
    load_statute(statute)
  end
  def load_statute (statute)    
	if !statute.first.nil?
	    s_pid = statute.first.pid
	    if !statute.first.citation.first.nil? && statute.first.citation.first.to_s.length > 0
	      statute.first
	    elsif s_pid.to_s.length > 0
	      DamsStatute.find(s_pid)
	    end
	end        
  end
  def load_otherRights
    load_otherRights(otherRights)
  end
  def load_otherRights (otherRights)
	if !otherRights.first.nil?
	    if !otherRights.first.uri.first.nil? && otherRights.first.uri.first.to_s.length > 0
	      otherRights.first
	    elsif otherRights.first.pid.to_s.length > 0
	      DamsOtherRight.find( otherRights.first.pid )
	    end
	end        
  end

  def load_sourceCapture(sourceCapture)
    uri = sourceCapture.first.to_s
    pid = uri.gsub(/.*\//,'')
    if pid != nil && pid != ""
      obj = DamsSourceCapture.find(pid)
      obj
    else
      nil
    end
  end

  def rightsHolder
    rightsHolderPersonal.concat(rightsHolderCorporate)
  end
  def load_rightsHolders
    load_rightsHolders(rightsHolder)
  end
  def load_rightsHolders(rightsHolder)
    rightsHolders = []
    rightsHolder.each do |name|
      if !name.name.first.nil? && name.name.first != ""
        # use inline data if available
        rightsHolders << name
      elsif name.pid != nil
        rightsHolders << MadsPersonalName.find(name.pid)
      end
    end
    rightsHolders
  end 
end

