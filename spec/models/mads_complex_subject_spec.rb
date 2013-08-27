require 'spec_helper'

describe MadsComplexSubject do
	exturi = RDF::Resource.new "http://id.loc.gov/authorities/subjects/sh85148221"
	scheme = RDF::Resource.new "http://library.ucsd.edu/ark:/20775/bb1234567x"
	scheme_2 = RDF::Resource.new "http://library.ucsd.edu/ark:/20775/bd9386739x"
	scheme_3 = RDF::Resource.new "http://library.ucsd.edu/ark:/20775/bd9386739y"
	topic_uri = RDF::Resource.new "http://library.ucsd.edu/ark:/20775/bd46424836"
	topic_uri_2 = RDF::Resource.new "http://library.ucsd.edu/ark:/20775/xx00000999"
  let(:params) {
    {
		name: "World politics--American politics--20th Century", externalAuthority: exturi,
		scheme_attributes: [
            id: scheme, code: "naf", name: "Library of Congress Name Authority File"
          ],
        topic_attributes: [
        	{name:"World politics", externalAuthority: exturi, 
        	 topicElement_attributes: [{ elementValue: "World politics" }],
        	 scheme_attributes: [id: scheme_2, code: "lcsh", name: "Library of Congress Subject Headings"]
	        },
        	{id: topic_uri_2, name:"American politics", externalAuthority: exturi,
        	 topicElement_attributes: [{ elementValue: "American politics" }],
        	  scheme_attributes: [id: scheme_3, code: "lcsh", name: "Library of Congress Subject Headings"]
        	}
        ],
        temporal_attributes: [
        	{name:"20th Century",  temporalElement_attributes: [{ elementValue: "20th Century" }]}
        ],
        genreForm_attributes: [
        	{name:"genreFormValue",  genreFormElement_attributes: [{ elementValue: "genreFormValue" }]}
        ],
		personalName_attributes: [
        	{name:"Burns", familyNameElement_attributes: [{ elementValue: "Burns" }]}
        ],
		genericName_attributes: [
        	{name:"genericNameValue", givenNameElement_attributes: [{ elementValue: "genericNameValue" }]}
        ]		        			        		        
	}}
  subject do
    MadsComplexSubject.new(pid: 'zzXXXXXXX1').tap do |t|
      t.attributes = params
    end
  end
  it "should create rdf/xml" do
    xml =<<END
<rdf:RDF xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
         xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
         xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#">
  <mads:ComplexSubject rdf:about="http://library.ucsd.edu/ark:/20775/zzXXXXXXX1">
    <mads:authoritativeLabel>World politics--American politics--20th Century</mads:authoritativeLabel>
    <mads:componentList rdf:parseType="Collection">
 	  <mads:Topic>
        <mads:authoritativeLabel>World politics</mads:authoritativeLabel>
        <mads:elementList rdf:parseType="Collection">
          <mads:TopicElement>
            <mads:elementValue>World politics</mads:elementValue>
          </mads:TopicElement>
        </mads:elementList>
        <mads:hasExactExternalAuthority rdf:resource="http://id.loc.gov/authorities/subjects/sh85148221"/>        
        <mads:isMemberOfMADSScheme>
          <mads:MADSScheme rdf:about="http://library.ucsd.edu/ark:/20775/bd9386739x">
            <mads:code>lcsh</mads:code>
            <rdfs:label>Library of Congress Subject Headings</rdfs:label>
            </mads:MADSScheme>
        </mads:isMemberOfMADSScheme>
      </mads:Topic>
      <mads:Topic rdf:about="http://library.ucsd.edu/ark:/20775/xx00000999">
        <mads:authoritativeLabel>American politics</mads:authoritativeLabel>
        <mads:elementList rdf:parseType="Collection">
          <mads:TopicElement>
            <mads:elementValue>American politics</mads:elementValue>
          </mads:TopicElement>
        </mads:elementList>
        <mads:hasExactExternalAuthority rdf:resource="http://id.loc.gov/authorities/subjects/sh85148221"/>
        <mads:isMemberOfMADSScheme>
          <mads:MADSScheme rdf:about="http://library.ucsd.edu/ark:/20775/bd9386739y">
            <mads:code>lcsh</mads:code>
            <rdfs:label>Library of Congress Subject Headings</rdfs:label>            
          </mads:MADSScheme>
        </mads:isMemberOfMADSScheme>
      </mads:Topic>
      <mads:Temporal>
        <mads:authoritativeLabel>20th Century</mads:authoritativeLabel>
        <mads:elementList rdf:parseType="Collection">
          <mads:TemporalElement>
            <mads:elementValue>20th Century</mads:elementValue>
          </mads:TemporalElement>
        </mads:elementList>
      </mads:Temporal>
 	  <mads:GenreForm>
	       <mads:authoritativeLabel>genreFormValue</mads:authoritativeLabel>
	       <mads:elementList rdf:parseType="Collection">
	         <mads:GenreFormElement>
	           <mads:elementValue>genreFormValue</mads:elementValue>
	         </mads:GenreFormElement>
	       </mads:elementList>
       </mads:GenreForm>
		<mads:PersonalName>
           <mads:authoritativeLabel>Burns</mads:authoritativeLabel>
           <mads:elementList rdf:parseType="Collection">
             <mads:FamilyNameElement>
               <mads:elementValue>Burns</mads:elementValue>
             </mads:FamilyNameElement>
           </mads:elementList>
         </mads:PersonalName>
		 <mads:Name>
           <mads:authoritativeLabel>genericNameValue</mads:authoritativeLabel>
           <mads:elementList rdf:parseType="Collection">
             <mads:GivenNameElement>
               <mads:elementValue>genericNameValue</mads:elementValue>
             </mads:GivenNameElement>
           </mads:elementList>
         </mads:Name>                               
    </mads:componentList>
    <mads:hasExactExternalAuthority rdf:resource="http://id.loc.gov/authorities/subjects/sh85148221"/>
    <mads:isMemberOfMADSScheme>
      <mads:MADSScheme rdf:about="http://library.ucsd.edu/ark:/20775/bb1234567x">
        <mads:code>naf</mads:code>
        <rdfs:label>Library of Congress Name Authority File</rdfs:label>        
      </mads:MADSScheme>
    </mads:isMemberOfMADSScheme>
  </mads:ComplexSubject>
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml
  end

  it "should have topicElement" do
    subject.topic.first.name.should == ['World politics']
    subject.topic[0].class.should == MadsTopicInternal
    # TO DO -need to convert the class RDF::URI into MadsTopicInternal
    #subject.topic[1].class.should == MadsTopicInternal
  end

  it "should be able to build a new topicElement" do
    subject.componentList.topic.build
  end
end