class DamsComplexSubject < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsSubjectDatastream 
  delegate_to "damsMetadata", [:name]
end
