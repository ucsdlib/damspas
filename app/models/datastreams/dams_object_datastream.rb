class DamsObjectDatastream < DamsResourceDatastream
  include Dams::DamsObject
    
  def load_copyright ( copyright )
    foo = copyright.to_s
    if copyright.first.instance_of?(DamsCopyrightInternal) && !copyright.first.status.first.nil?
      copyright.first
	elsif !copyright.first.nil?
	    c_pid = copyright.first.pid
	    if !copyright.first.status.first.nil? && copyright.first.status.first.to_s.length > 0
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
      if !license.first.note.first.blank? || !license.first.uri.first.blank?
        license.first
      elsif !license.first.pid.blank? && license.first.pid.to_s.length > 0
        DamsLicense.find(license.first.pid)
      end
    end
  end
  def load_statute
    load_statute(statute)
  end
  def load_statute (statute)    
    if statute.first.instance_of?(DamsStatuteInternal) && !statute.first.citation.first.nil?
      statute.first
	elsif !statute.first.nil?
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
    if otherRights.first.instance_of?(DamsOtherRightInternal) && !otherRights.first.uri.first.nil?
      otherRights.first
	elsif !otherRights.first.nil?
	    if !otherRights.first.uri.first.nil? && otherRights.first.uri.first.length > 0
	      otherRights.first
	    elsif otherRights.first.pid.to_s.length > 0
	      DamsOtherRight.find( otherRights.first.pid )
	    end
	end        
  end

  def load_sourceCapture(sourceCapture)
    srcCap = sourceCapture.first
    if srcCap.class.name == 'DamsSourceCaptureInternal'
      # use internal objects as-is
      srcCap
    else
      # fetch external records from the repo
      uri = srcCap.to_s
      pid = uri.gsub(/.*\//,'')
      if pid != nil && pid != ""
        obj = DamsSourceCapture.find(pid)
        obj
      end
    end
  end

  def rightsHolder
    rightsHolderPersonal.concat(rightsHolderCorporate).concat(rightsHolderFamily).concat(rightsHolderConference).concat(rightsHolderName)
  end
  def load_rightsHolders
    load_rightsHolders(rightsHolder)
  end
  def load_rightsHolders(rightsHolder)
    rightsHolders = []
    rightsHolder.each do |name|
      foo = name.to_s
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

