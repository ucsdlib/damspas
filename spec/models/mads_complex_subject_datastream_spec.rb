require 'spec_helper'

describe MadsComplexSubjectDatastream do
  describe "nested attributes" do
    it "should create rdf/xml" do
		exturi = RDF::Resource.new "http://id.loc.gov/authorities/subjects/sh85148221"
		scheme = RDF::Resource.new "http://library.ucsd.edu/ark:/20775/bb1234567x"
		scheme_2 = RDF::Resource.new "http://library.ucsd.edu/ark:/20775/bd9386739x"
		scheme_3 = RDF::Resource.new "http://library.ucsd.edu/ark:/20775/bd9386739y"
		topic_uri = RDF::Resource.new "http://library.ucsd.edu/ark:/20775/xx00060346"
		topic_uri_2 = RDF::Resource.new "http://library.ucsd.edu/ark:/20775/xx00060347"
		params = {
			complexSubject: {
				name: "World politics--American politics--20th Century", externalAuthority: exturi,
				scheme_attributes: [
		            id: scheme, code: "naf", name: "Library of Congress Name Authority File"
		          ],
		        topic_attributes: [
		        	{id: topic_uri, name:"World politics", externalAuthority: exturi, 
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
			}
	    }
      subject = MadsComplexSubjectDatastream.new(double("inner object", pid:"bd93182924", new?: true))
      subject.attributes = params[:complexSubject]

      xml =<<END
<rdf:RDF xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
         xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
         xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#">
  <mads:ComplexSubject rdf:about="http://library.ucsd.edu/ark:/20775/bd93182924">
    <mads:authoritativeLabel>World politics--American politics--20th Century</mads:authoritativeLabel>
    <mads:componentList rdf:parseType="Collection">
 	  <mads:Topic rdf:about="http://library.ucsd.edu/ark:/20775/xx00060346">
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
      <mads:Topic rdf:about="http://library.ucsd.edu/ark:/20775/xx00060347">
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
      subject.content.should be_equivalent_to xml
    end
    
	  describe "an instance with content" do
	    subject do
	      subject = MadsComplexSubjectDatastream.new(double('inner object', :pid=>'bbXXXXXXX5', :new? =>true), 'descMetadata')
	      subject.content = File.new('spec/fixtures/madsComplexSubject.xml').read
	      subject
	    end
	    it "should have a subject" do
	      subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bbXXXXXXX5"
	    end
	
	    it "should have fields" do
	      subject.name.should == ["Academic dissertations"]
	    end
	  end
	  describe "an instance with an element list" do
	    subject do
	      subject = MadsComplexSubjectDatastream.new(double('inner object', :pid=>'bbXXXXXXX5', :new? =>true), 'descMetadata')
	      subject.content = File.new('spec/fixtures/madsMoreComplexSubject.rdf.xml').read
	      subject
	    end
	    it "should have a subject" do
	      subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bbXXXXXXX5"
	    end
	
	    it "should have fields" do
	      list = subject.componentList	      
		  "#{list[0].class.name}".should == "MadsTopicInternal"
          list[0].name.should == ["African Americans"]  
          "#{list[1].class.name}".should == "MadsTopicInternal"
          list[1].name.should == ["Relations with Mexican Americans"]   
          "#{list[2].class.name}".should == "MadsTemporalInternal"
          list[2].name.should == ["20th Century"]  
          "#{list[3].class.name}".should == "MadsGenreFormInternal"
          list[3].name.should == ["genreFormValue"]        
          list.size.should == 4
	    end
	  end
	  
	  describe "an instance with an component list" do
	     subject do
	        subject = MadsComplexSubjectDatastream.new(double('inner object', :pid=>'bd6724414c', :new? =>true), 'damsMetadata')
	        subject.content = File.new('spec/fixtures/madsMoreComplexSubject2.rdf.xml').read
	        subject
	      end
	            
	      it "should have name" do
	        subject.name.should == ["Galaxies--Clusters"]
	      end
	 
	      it "should have an scheme" do
	        subject.scheme.first.pid.should == "bd9386739x"
	      end
	
	    it "should have fields" do
	      list = subject.componentList
	      "#{list[0].class.name}".should == "MadsTopicInternal"
	      list[0].name.should == ["Galaxies"]
	      "#{list[1].class.name}".should == "MadsTopicInternal"
	      list[1].name.should == ["Clusters"]
	      "#{list[2].class.name}".should == "MadsGenreFormInternal"
	      list[2].name.should == ["Film and video adaptions"]      
	      list.size.should == 19
	    end
	    
	    it "should have fields from solr doc" do
	        solr_doc = subject.to_solr
	        solr_doc["complexSubject_0_0_topic_tesim"].should == ["Galaxies"]
	        solr_doc["complexSubject_0_1_topic_tesim"].should == ["Clusters"]
	        solr_doc["complexSubject_0_2_genreForm_tesim"].should == ["Film and video adaptions"]
	        #solr_doc["complexSubject_0_3_genreForm_tesim"].should == ["Film and video adaptions"]  
	        #solr_doc["complexSubject_0_4_topic_tesim"].should == ["Baseball"]          
	        #solr_doc["complexSubject_0_5_iconography_tesim"].should == ["Madonna and Child"]
	        #solr_doc["complexSubject_0_6_scientificName_tesim"].should == ["Western lowland gorilla (Gorilla gorilla gorilla)"]
	        #solr_doc["complexSubject_0_7_technique_tesim"].should == ["Impasto"]
	        #solr_doc["complexSubject_0_8_builtWorkPlace_tesim"].should == ["The Getty Center"]
	        #solr_doc["complexSubject_0_9_personalName_tesim"].should == ["Burns, Jack O."]
	        #solr_doc["complexSubject_0_10_geographic_tesim"].should == ["Ness, Loch (Scotland)"]
	        #solr_doc["complexSubject_0_11_temporal_tesim"].should == ["16th century"]
	        #solr_doc["complexSubject_0_12_culturalContext_tesim"].should == ["Dutch"]
	        #solr_doc["complexSubject_0_13_stylePeriod_tesim"].should == ["Impressionism"]
	        #solr_doc["complexSubject_0_14_conferenceName_tesim"].should == ["American Library Association. Annual Conference"]
	        #solr_doc["complexSubject_0_15_function_tesim"].should == ["Sample Function"]
	        #solr_doc["complexSubject_0_16_corporateName_tesim"].should == ["Lawrence Livermore Laboratory"]
	        #solr_doc["complexSubject_0_17_occupation_tesim"].should == ["Pharmacist"]
	        #solr_doc["complexSubject_0_18_familyName_tesim"].should == ["Calder (Family : 1757-1959 : N.C.)"]
	    end           
	  end  
	end
end