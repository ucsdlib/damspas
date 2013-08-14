class MadsComplexSubject < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => MadsComplexSubjectDatastream 
  delegate_to "damsMetadata", [:name, :componentList, :externalAuthority,
  		:scheme, :scheme_attributes,
  		:topic, :topic_attributes,
  		:temporal, :temporal_attributes, 
  		:genreForm, :genreForm_attributes,
  		:geographic, :geographic_attributes, 
  		:occupation, :occupation_attributes,
  		:personalName, :personalName_attributes, 
  		:conferenceName, :conferenceName_attributes,
  		:corporateName, :corporateName_attributes,
  		:familyName, :familyName_attributes,
  		:genericName, :genericName_attributes
  		]
end
