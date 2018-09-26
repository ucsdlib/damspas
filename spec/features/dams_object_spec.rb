require 'spec_helper'
require 'rack/test'
require 'capybara/poltergeist'

feature 'Visitor want to look at objects' do

  describe "titles and curator data views" do
    before(:all) do
      @o = DamsObject.create titleValue: 'Test Title, Test Part',
                             subtitle: 'Test Subtitle', titleNonSort: 'The',
                             titlePartName: 'Test Part', titlePartNumber: 'Test Number',
                             titleTranslationVariant: 'Test Translation Variant',
                             copyright_attributes: [{status: 'Public domain'}]
      solr_index @o.pid
    end
    after(:all) do
      @o.delete
    end
    it "should display titles" do
      visit dams_object_path @o
      expect(page).to have_selector('h1',:text=>'The Test Title, Test Part')
      expect(page).to have_selector('h2',:text=>'Test Subtitle, Test Part Test Number, Test Translation Variant')
    end
    it "should display admin links" do
      sign_in_developer
      visit dams_object_path @o
      expect(page).to have_link('RDF View', rdf_dams_object_path(@o.pid))
      expect(page).to have_link('Data View', data_dams_object_path(@o.pid))
      expect(page).to have_link('DAMS 4.2 Preview', dams42_dams_object_path(@o.pid))
    end
    it "should have a data view" do
      sign_in_developer
      visit dams_object_path @o
      click_on 'Data View'
      expect(page).to have_selector('td', :text => "Object")
      expect(page).to have_selector('td', :text => "http://library.ucsd.edu/ark:/20775/#{@o.pid}")
    end
    it "should have an rdf/xml view" do
      sign_in_developer
      visit dams_object_path @o
      click_on 'RDF View'
      expect(page.status_code).to eq 200
      expect(response_headers['Content-Type']).to include 'application/rdf+xml'
    end
    it "should have an rdf/ttl view" do
      sign_in_developer
      visit dams_object_path @o
      click_on 'RDF Turtle View'
      expect(page.status_code).to eq 200
      expect(response_headers['Content-Type']).to include 'text/turtle'
      expect(page).to have_content("@prefix");
    end
    it "should have an rdf/ntriples view" do
      sign_in_developer
      visit dams_object_path @o
      click_on 'RDF N-Triples View'
      expect(page.status_code).to eq 200
      expect(response_headers['Content-Type']).to include 'application/n-triples'
      expect(page).to have_content("\" .");
    end
    it "should have an dams 4.2 view" do
      sign_in_developer
      visit dams_object_path @o
      click_on 'DAMS 4.2 Preview'
      expect(page.status_code).to eq 200
      expect(response_headers['Content-Type']).to include 'application/rdf+xml'
    end
    it "should contain damsmanger url for RDF Edit" do
      sign_in_developer
      visit dams_object_path @o
      expect(page).to have_xpath "//a[contains(@href,'/damsmanager/rdfImport.do?ark=#{@o.pid}')]"
    end
    it "with anonymous access should not see the metadata tools" do
      sign_in_anonymous '132.239.0.3'
      visit dams_object_path @o
      expect(page).not_to have_link('RDF View', rdf_dams_object_path(@o.pid))
      expect(page).not_to have_link('Data View', data_dams_object_path(@o.pid))
      expect(page).not_to have_link('DAMS 4.2 Preview', dams42_dams_object_path(@o.pid))
    end
    it "with dams_curator role should see the metadata tools" do
      sign_in_curator
      visit dams_object_path @o
      expect(page).to have_link('RDF View', rdf_dams_object_path(@o.pid))
      expect(page).to have_link('Data View', data_dams_object_path(@o.pid))
      expect(page).to have_link('DAMS 4.2 Preview', dams42_dams_object_path(@o.pid))
    end
    it "with dams_curator role should not see Mint DOI and Push/Delete to/from OSF" do
      sign_in_curator
      visit dams_object_path @o
      expect(page).not_to have_content("Mint DOI");
      expect(page).not_to have_content("Push to OSF");
      expect(page).not_to have_content("Delete from OSF")
    end
    it "with dams_editor role should see Mint DOI and Push to OSF" do
      sign_in_developer
      visit dams_object_path @o
      expect(page).to have_content("Mint DOI");
      expect(page).to have_content("Push to OSF");
      expect(page).to have_content("Delete from OSF");
    end
  end

  describe "linked metadata records" do
    before(:all) do
      ns = Rails.configuration.id_namespace
      @acol = DamsAssembledCollection.create( titleValue: 'Test Assembled Collection',
                                              visibility: 'public' )
      @pcol = DamsProvenanceCollection.create( titleValue: 'Test Provenance Collection',
                                               visibility: 'public' )
      @part = DamsProvenanceCollectionPart.create( titleValue: 'Test Provenance Part Collection',
                                                   visibility: 'public' )

      @cart = DamsCartographics.create( point: 'Test Point', line: 'Test Line',
                                        polygon: 'Test Polygon' )
      @unit = DamsUnit.create( name: 'Test Unit', description: 'Test Description', code: 'tu',
                               group: 'dams-curator', uri: 'http://example.com/' )

      @note = DamsNote.create( value: 'Test Note' )
      @cust = DamsCustodialResponsibilityNote.create( value: 'Test Custodial Responsibility Note' )
      @cite = DamsPreferredCitationNote.create( value: 'Test Preferred Citation Note' )
      @scope = DamsScopeContentNote.create( value: 'Test Scope Content Note' )

      @built = DamsBuiltWorkPlace.create( name: 'Test Built Work Place' )
      @cult = DamsCulturalContext.create( name: 'Test Cultural Context' )
      @func = DamsFunction.create( name: 'Test Function' )
      @icon = DamsIconography.create( name: 'Test Iconography' )
      @ana = DamsAnatomy.create( name: 'Test Anatomy' )
      @other_ana = DamsAnatomy.create( name: 'Test Value Anatomy' )
      @lith = DamsLithology.create( name: 'Test Lithology' )
      @other_lith = DamsLithology.create( name: 'Test Value Lithology' )
      @ser = DamsSeries.create( name: 'Test Series' )
      @cru = DamsCruise.create( name: 'Test Cruise' )
      @cci = DamsCommonName.create( name: 'Test Common Name' )
      @sci = DamsScientificName.create( name: 'Test Scientific Name' )
      @style = DamsStylePeriod.create( name: 'Test Style Period' )
      @tech = DamsTechnique.create( name: 'Test Technique' )
      @complex = MadsComplexSubject.create( name: 'Test Complex Subject' )
      @conf = MadsConferenceName.create( name: 'Test Conference Name' )
      @corp = MadsCorporateName.create( name: 'Test Corporate Name' )
      @family = MadsFamilyName.create( name: 'Test Family Name' )
      @genre = MadsGenreForm.create( name: 'Test Genre Form' )
      @geog = MadsGeographic.create( name: 'Test Geographic' )
      @lang = MadsLanguage.create( name: 'Test Language' )
      @name = MadsName.create( name: 'Test Name' )
      @occu = MadsOccupation.create( name: 'Test Occupation' )
      @pers = MadsPersonalName.create( name: 'Test Personal Name' )
      @temp = MadsTemporal.create( name: 'Test Temporal' )
      @other_temp = MadsTemporal.create( name: 'Test Value Temporal' )
      @topic = MadsTopic.create( name: 'Test Topic' )

      @lic = DamsLicense.create( note: 'Creative Commons Attribution 4.0',
                                 uri: 'https://creativecommons.org/licenses/by/4.0/' )
      @other = DamsOtherRight.create( note: 'Test Other Rights' )
      @stat = DamsStatute.create( citation: 'Test Statute' )

      @o = DamsObject.create( titleValue: 'Linked Metadata Test',
                              assembledCollectionURI: [ @acol.pid ],
                              provenanceCollectionURI: [ @pcol.pid ],
                              provenanceCollectionPartURI: [ @part.pid ],
                              cartographics_attributes: [{ id: RDF::URI.new("#{ns}#{@cart.pid}") }],
                              unit_attributes: [{ id: RDF::URI.new("#{ns}#{@unit.pid}") }],
                              note_attributes: [{ id: RDF::URI.new("#{ns}#{@note.pid}") }],
                              custodialResponsibilityNote_attributes: [{ id: RDF::URI.new("#{ns}#{@cust.pid}") }],
                              preferredCitationNote_attributes: [{ id: RDF::URI.new("#{ns}#{@cite.pid}") }],
                              scopeContentNote_attributes: [{ id: RDF::URI.new("#{ns}#{@scope.pid}") }],
                              builtWorkPlace_attributes: [{ id: RDF::URI.new("#{ns}#{@built.pid}") }],
                              culturalContext_attributes: [{ id: RDF::URI.new("#{ns}#{@cult.pid}") }],
                              function_attributes: [{ id: RDF::URI.new("#{ns}#{@func.pid}") }],
                              iconography_attributes: [{ id: RDF::URI.new("#{ns}#{@icon.pid}") }],
                              anatomy_attributes: [{ id: RDF::URI.new("#{ns}#{@ana.pid}") },
                                                   { id: RDF::URI.new("#{ns}#{@other_ana.pid}") }],
                              lithology_attributes: [{ id: RDF::URI.new("#{ns}#{@lith.pid}") },
                                                     { id: RDF::URI.new("#{ns}#{@other_lith.pid}") }],
                              series_attributes: [{ id: RDF::URI.new("#{ns}#{@ser.pid}") }],
                              cruise_attributes: [{ id: RDF::URI.new("#{ns}#{@cru.pid}") }],
                              commonName_attributes: [{ id: RDF::URI.new("#{ns}#{@cci.pid}") }],
                              scientificName_attributes: [{ id: RDF::URI.new("#{ns}#{@sci.pid}") }],
                              stylePeriod_attributes: [{ id: RDF::URI.new("#{ns}#{@style.pid}") }],
                              technique_attributes: [{ id: RDF::URI.new("#{ns}#{@tech.pid}") }],
                              complexSubject_attributes: [{ id: RDF::URI.new("#{ns}#{@complex.pid}") }],
                              conferenceName_attributes: [{ id: RDF::URI.new("#{ns}#{@conf.pid}") }],
                              corporateName_attributes: [{ id: RDF::URI.new("#{ns}#{@corp.pid}") }],
                              familyName_attributes: [{ id: RDF::URI.new("#{ns}#{@family.pid}") }],
                              genreForm_attributes: [{ id: RDF::URI.new("#{ns}#{@genre.pid}") }],
                              geographic_attributes: [{ id: RDF::URI.new("#{ns}#{@geog.pid}") }],
                              language_attributes: [{ id: RDF::URI.new("#{ns}#{@lang.pid}") }],
                              name_attributes: [{ id: RDF::URI.new("#{ns}#{@name.pid}") }],
                              occupation_attributes: [{ id: RDF::URI.new("#{ns}#{@occu.pid}") }],
                              personalName_attributes: [{ id: RDF::URI.new("#{ns}#{@pers.pid}") }],
                              temporal_attributes: [{ id: RDF::URI.new("#{ns}#{@temp.pid}") },
                                                    { id: RDF::URI.new("#{ns}#{@other_temp.pid}") }],
                              topic_attributes: [{ id: RDF::URI.new("#{ns}#{@topic.pid}") }],
                              copyright_attributes: [{status: 'Public domain'}],
                              license_attributes: [{ id: RDF::URI.new("#{ns}#{@lic.pid}") }],
                              otherRights_attributes: [{ id: RDF::URI.new("#{ns}#{@other.pid}") }],
                              statute_attributes: [{ id: RDF::URI.new("#{ns}#{@stat.pid}") }]    )

      solr_index @o.pid
    end
    after(:all) do
      @o.delete
      @acol.delete
      @pcol.delete
      @part.delete
      @cart.delete
      @unit.delete
      @note.delete
      @cust.delete
      @cite.delete
      @scope.delete
      @built.delete
      @cult.delete
      @func.delete
      @icon.delete
      @cci.delete
      @sci.delete
      @style.delete
      @tech.delete
      @complex.delete
      @conf.delete
      @corp.delete
      @family.delete
      @genre.delete
      @geog.delete
      @lang.delete
      @name.delete
      @occu.delete
      @pers.delete
      @temp.delete
      @topic.delete
      @lic.delete
      @other.delete
      @stat.delete
      @lith.delete
      @other_lith.delete
      @other_temp.delete
      @other_ana.delete
    end
    it "should display linked metadata" do

      visit dams_object_path @o

      expect(page).to have_selector('li', text: 'Test Assembled Collection')
      expect(page).to have_selector('li', text: 'Test Provenance Collection')
      expect(page).to have_selector('li', text: 'Test Provenance Part Collection')

      expect(page).to have_selector('p', text: 'Test Point')
      expect(page).to have_selector('p', text: 'Test Line')
      expect(page).to have_selector('p', text: 'Test Polygon')
      expect(page).to_not have_selector('li', text: 'Test Unit')

      expect(page).to have_selector('p', text: 'Creative Commons Attribution 4.0')
      expect(page).to have_selector('p', text: 'Test Preferred Citation Note')
      expect(page).to have_selector('p', text: 'Test Scope Content Note')
      expect(page).to have_selector('li', text: 'Test Cultural Context')
      expect(page).to have_selector('li', text: 'Test Common Name')
      expect(page).to have_selector('li', text: 'Test Scientific Name')
      expect(page).to have_selector('li', text: 'Test Conference Name')
      expect(page).to have_selector('li', text: 'Test Corporate Name')
      expect(page).to have_selector('li', text: 'Test Family Name')
      expect(page).to have_selector('li', text: 'Test Genre Form')
      expect(page).to have_selector('li', text: 'Test Geographic')
      expect(page).to have_selector('li', text: 'Test Language')
      expect(page).to have_selector('li', text: 'Test Occupation')
      expect(page).to have_selector('li', text: 'Test Personal Name')
      expect(page).to have_selector('li', text: 'Test Temporal')
      expect(page).to have_selector('li', text: 'Test Value Temporal')
      expect(page).to have_selector('li', text: 'Test Topic')
      expect(page).to have_selector('li', text: 'Test Lithology')
      expect(page).to have_selector('li', text: 'Test Value Lithology')
      expect(page).to have_selector('li', text: 'Test Series')
      expect(page).to have_selector('li', text: 'Test Cruise')
      expect(page).to have_selector('li', text: 'Test Anatomy')
      expect(page).to have_selector('li', text: 'Test Value Anatomy')

      #Subject Label
      expect(page).to_not have_selector('dt', text: 'Lithologies')
      expect(page).to have_selector('dt', text: 'Lithology')
      expect(page).to_not have_selector('dt', text: 'Temporals')
      expect(page).to have_selector('dt', text: 'Temporal')
      expect(page).to_not have_selector('dt', text: 'Anatomies')
      expect(page).to have_selector('dt', text: 'Anatomy')
    end
    it "should display curator-only linked metadata" do

      sign_in_developer
      visit dams_object_path @o
      expect(page).to have_selector('p', text: 'Creative Commons Attribution 4.0')
      expect(page).to have_selector('p', text: 'Test other rights')
      expect(page).to have_selector('p', text: 'Test Statute')
    end
    it "should display facet links for subject types" do
      visit dams_object_path @o
      expect(page).to have_link('Test Corporate Name', href: catalog_index_path({'f[subject_topic_sim][]' => 'Test Corporate Name', 'id' => @o.pid}))
      expect(page).to have_link('Test Genre Form', href: catalog_index_path({'f[subject_topic_sim][]' => 'Test Genre Form', 'id' => @o.pid}))
      expect(page).to have_link('Test Personal Name', href: catalog_index_path({'f[subject_topic_sim][]' => 'Test Personal Name', 'id' => @o.pid}))
      expect(page).to have_link('Test Common Name', href: catalog_index_path({'f[subject_common_name_sim][]' => 'Test Common Name', 'id' => @o.pid}))
      expect(page).to have_link('Test Scientific Name', href: catalog_index_path({'f[subject_scientific_name_sim][]' => 'Test Scientific Name', 'id' => @o.pid}))
      expect(page).to have_link('Test Lithology', href: catalog_index_path({'f[subject_lithology_sim][]' => 'Test Lithology', 'id' => @o.pid}))
      expect(page).to have_link('Test Cruise', href: catalog_index_path({'f[subject_cruise_sim][]' => 'Test Cruise', 'id' => @o.pid}))
      expect(page).to have_link('Test Anatomy', href: catalog_index_path({'f[subject_anatomy_sim][]' => 'Test Anatomy', 'id' => @o.pid}))
      expect(page).to have_link('Test Cultural Context', href: catalog_index_path({'f[subject_cultural_context_sim][]' => 'Test Cultural Context', 'id' => @o.pid}))
      expect(page).to have_link('Test Series', href: catalog_index_path({'f[subject_series_sim][]' => 'Test Series', 'id' => @o.pid}))
    end
    it "should display complex subject" do
      visit dams_object_path @o
      expect(page).to have_content('Topics Test Complex Subject')
    end
  end
  describe "internal metadata records" do
    before(:all) do
      @acol = DamsAssembledCollection.create( titleValue: 'Test Assembled Collection',
                                              visibility: 'public' )
      @pcol = DamsProvenanceCollection.create( titleValue: 'Test Provenance Collection',
                                               visibility: 'public' )
      @part = DamsProvenanceCollectionPart.create( titleValue: 'Test Provenance Part Collection',
                                                   visibility: 'public' )
      @o = DamsObject.create( titleValue: 'Internal Metadata Test', typeOfResource: 'image',
                              assembledCollectionURI: [ @acol.pid ],
                              provenanceCollectionURI: [ @pcol.pid ],
                              provenanceCollectionPartURI: [ @part.pid ],
                              copyright_attributes: [{status: 'Public domain'}],
                              cartographics_attributes: [{ point: 'Test Point', line: 'Test Line',
                                                           polygon: 'Test Polygon' }],
                              unit_attributes: [{ name: 'Test Unit', description: 'Test Description', code: 'tu',
                                                  group: 'dams-curator', uri: 'http://example.com/' }],
                              note_attributes: [{value: 'test related publications', type: 'related publications'}, { value: 'Test Note' }, { value: 'Another Test Note' }, {value: '85-8', type: 'identifier', displayLabel: 'accession number'}],
                              custodialResponsibilityNote_attributes: [{ value: 'Test Custodial Responsibility Note' }],
                              preferredCitationNote_attributes: [{ value: 'Test Preferred Citation Note' }],
                              scopeContentNote_attributes: [{ value: 'Test Scope Content Note' }],
                              builtWorkPlace_attributes: [{ name: 'Test Built Work Place' }],
                              culturalContext_attributes: [{ name: 'Test Cultural Context' }],
                              function_attributes: [{ name: 'Test Function' }],
                              iconography_attributes: [{ name: 'Test Iconography' }],
                              lithology_attributes: [{ name: 'Test Lithology' }],
                              series_attributes: [{ name: 'Test Series' }],
                              cruise_attributes: [{ name: 'Test Cruise' }],
                              anatomy_attributes: [{ name: 'Test Anatomy' }],
                              commonName_attributes: [{ name: 'Test Common Name' }],
                              scientificName_attributes: [{ name: 'Test Scientific Name' }],
                              stylePeriod_attributes: [{ name: 'Test Style Period' }],
                              technique_attributes: [{ name: 'Test Technique' }],
                              complexSubject_attributes: [{ name: 'Test Complex Subject' }],
                              conferenceName_attributes: [{ name: 'Test Conference Name' }],
                              corporateName_attributes: [{ name: 'Test Corporate Name' }],
                              familyName_attributes: [{ name: 'Test Family Name' }],
                              genreForm_attributes: [{ name: 'Test Genre Form' }],
                              geographic_attributes: [{ name: 'Test Geographic' }],
                              language_attributes: [{ name: 'Test Language' }],
                              name_attributes: [{ name: 'Test Name' }],
                              occupation_attributes: [{ name: 'Test Occupation' }],
                              personalName_attributes: [{ name: 'Test Personal Name' }],
                              temporal_attributes: [{ name: 'Test Temporal' }],
                              topic_attributes: [{ name: 'Test Topic' }],
                              license_attributes: [{ note: 'Creative Commons Attribution 4.0',
                                                     uri: 'https://creativecommons.org/licenses/by/4.0/' }],
                              statute_attributes: [{ citation: 'Test Statute' }]  )

      solr_index @o.pid
    end
    after(:all) do
      @o.delete
      @acol.delete
      @pcol.delete
      @part.delete
    end
    it "should display linked metadata" do

      visit dams_object_path @o

      expect(page).to have_selector('li', text: 'Test Assembled Collection')
      expect(page).to have_selector('li', text: 'Test Provenance Collection')
      expect(page).to have_selector('li', text: 'Test Provenance Part Collection')

      expect(page).to have_selector('p', text: 'Test Point')
      expect(page).to have_selector('p', text: 'Test Line')
      expect(page).to have_selector('p', text: 'Test Polygon')
      expect(page).to_not have_selector('li', text: 'Test Unit')

      expect(page).to have_content('Related Publications')

      expect(page).to have_selector('p', text: 'Test Preferred Citation Note')
      expect(page).to have_selector('p', text: 'Test Scope Content Note')
      expect(page).to have_selector('p', text: 'Creative Commons Attribution 4.0')

      expect(page).to have_selector('li', text: 'Test Cultural Context')
      expect(page).to have_selector('li', text: 'Test Common Name')
      expect(page).to have_selector('li', text: 'Test Scientific Name')
      expect(page).to have_selector('li', text: 'Test Conference Name')
      expect(page).to have_selector('li', text: 'Test Corporate Name')
      expect(page).to have_selector('li', text: 'Test Family Name')
      expect(page).to have_selector('li', text: 'Test Genre Form')
      expect(page).to have_selector('li', text: 'Test Geographic')
      expect(page).to have_selector('li', text: 'Test Language')
      expect(page).to have_selector('li', text: 'Test Occupation')
      expect(page).to have_selector('li', text: 'Test Personal Name')
      expect(page).to have_selector('li', text: 'Test Temporal')
      expect(page).to have_selector('li', text: 'Test Topic')
      expect(page).to have_selector('li', text: 'Test Lithology')
      expect(page).to have_selector('li', text: 'Test Series')
      expect(page).to have_selector('li', text: 'Test Cruise')
      expect(page).to have_selector('li', text: 'Test Anatomy')

      expect(page).to_not have_selector('p', text: '85-8')
    end
    it "should display curator-only internal metadata" do

      sign_in_developer
      visit dams_object_path @o
      expect(page).to have_selector('p', text: 'Creative Commons Attribution 4.0')
      expect(page).to have_selector('p', text: 'Test Statute')
      expect(page).to have_selector('p', text: '85-8')
    end
    it "should have a collection-scoped format link" do
      sign_in_developer
      visit dams_object_path @o
      expect(page).to have_link('image')

      click_link "image"
      expect(page).to have_selector('span.dams-filter a', :text => "Collection")
      expect(page).to have_selector('span.dams-filter a', :text => "image")
    end
  end

  describe "viewing non-existing records" do
    it 'should show an error when viewing a non-existing record' do
      visit dams_object_path('xxx')
      expect(page).to have_content 'The page you were looking for does not exist.'
    end
    it 'should show an error when viewing a file from a non-existing object' do
      visit file_path('xxx','xxx')
      expect(page).to have_content "The page you were looking for does not exist."
    end
    it 'should show an error when viewing a non-existing file from an existing object' do
      visit file_path('bd0922518w','xxx')
      expect(page).to have_content "The page you were looking for does not exist."
    end
  end

  describe "rendering correct file format" do
    before(:all) do
      @unit = DamsUnit.create pid: 'xx48484848', name: "Test Unit", description: "Test Description",
                              code: "tu", uri: "http://example.com/"
      @damsVideoObj = DamsObject.create(pid: "xxx1171293")
      @damsVideoObj.damsMetadata.content = File.new('spec/fixtures/damsObjectVideo.rdf.xml').read
      @damsVideoObj.save!
      solr_index (@damsVideoObj.pid)
    end
    after(:all) do
      @damsVideoObj.delete
      @unit.delete
    end
    it "should show video tags" do
      visit dams_object_path(@damsVideoObj.pid)
      expect(page).to have_selector('#dams-video')
    end
  end

  describe "viewing files" do
    before(:all) do
      @col = DamsAssembledCollection.create( titleValue: 'Test Collection', visibility: 'public' )
      @o = DamsObject.create( titleValue: 'Object Files Test', copyright_attributes: [ {status: 'Public domain'} ],
                              assembledCollectionURI: [ @col.pid ], typeOfResource: 'image' )
      jpeg_content = '/9j/4AAQSkZJRgABAQEAAQABAAD/2wBDAAMCAgICAgMCAgIDAwMDBAYEBAQEBAgGBgUGCQgKCgkICQkKDA8MCgsOCwkJDRENDg8QEBEQCgwSExIQEw8QEBD/wAALCAABAAEBAREA/8QAFAABAAAAAAAAAAAAAAAAAAAACf/EABQQAQAAAAAAAAAAAAAAAAAAAAD/2gAIAQEAAD8AVN//2Q=='
      @o.add_file( Base64.decode64(jpeg_content), "_1.jpg", "test.jpg" )
      @o.add_file( '<html><body><a href="/test">test link</a></body></html>', "_2_1.html", "test.html" )
      @o.add_file( 'THsdtk 100.5°', "_2_2.txt", "test.txt" )
      @o.add_file( '"Testing CSV", Format', "_2_3.csv", "test.csv" )
      @o.save
      solr_index @col.pid
      solr_index @o.pid
    end
    after(:all) do
      @o.delete
      @col.delete
    end
    it 'should show a data file' do
      sign_in_developer
      visit file_path( @o.pid, '_1.jpg' )
      response = page.driver.response
      expect(response.status).to eq( 200 )
      expect(response.header["Content-Type"]).to eq( "image/jpeg" )
    end
    it 'should show a sample public html content file' do
      sign_in_developer
      visit file_path( @o.pid, '_2_1.html' )
      response = page.driver.response
      expect(response.status).to eq( 200 )
      expect(response.header["Content-Type"]).to have_content( "text/html" )
      expect(page).to have_link('test link', href: '/test')
    end
    it 'should show a pan/zoom viewer' do
      sign_in_developer
      visit zoom_path @o.pid, '0'
      expect(page).to have_selector('div#map')
      expect(page).not_to have_selector('header')
    end

    it 'should not show a pan/zoom viewer for non-existing files' do
      sign_in_developer
      visit zoom_path @o.pid, '9'
      expect(page).to have_selector('p', :text => "Error: unable to find zoomable image.")
    end
    it 'should index fulltext of complex object html file' do
      visit catalog_index_path( { q: 'test link', sort: 'title_ssi asc' } )
      expect(page).to have_selector('h3', :text => "Object Files Test")
    end
    it 'should index fulltext of complex object text file' do
      visit catalog_index_path( { q: 'THsdtk', sort: 'title_ssi asc' } )
      expect(page).to have_selector('h3', :text => "Object Files Test")
    end
    it 'should index fulltext of complex object CSV file' do
      visit catalog_index_path( { q: 'Testing CSV', sort: 'title_ssi asc' } )
      expect(page).to have_content("Object Files Test")
    end
  end

  describe "results pager and counter parameter" do
    before(:all) do
      @o1 = DamsObject.create( titleValue: 'Zyp4H8YRJzfXhq7q4Ps One', copyright_attributes: [{status: 'Public domain'}] )
      @o2 = DamsObject.create( titleValue: 'Zyp4H8YRJzfXhq7q4Ps Two', copyright_attributes: [{status: 'Public domain'}] )
      solr_index @o1.pid
      solr_index @o2.pid
    end
    after(:all) do
      @o1.delete
      @o2.delete
    end
    it 'should show results pager when clicking on search results' do
      # perform search
      visit catalog_index_path( { q: 'Zyp4H8YRJzfXhq7q4Ps', sort: 'title_ssi asc' } )
      expect(page).to have_selector('div.pagination-note', :text => "Results 1 - 2 of 2")
      expect(page).to have_selector('span.dams-filter', :text => "Zyp4H8YRJzfXhq7q4Ps")

      # click search result link, should see pager, no counter
      click_link "Zyp4H8YRJzfXhq7q4Ps One"
      expect(page).to have_selector('div.search-results-pager', :text => "1 of 2 results Next")
      expect(URI.parse(current_url).request_uri).to eq("/object/#{@o1.pid}")

      # view another object through direct link, should not have pager
      visit dams_object_path @o2
      expect(page).to have_selector('h1', :text => "Zyp4H8YRJzfXhq7q4Ps Two")
      expect(page).not_to have_selector('div.search-results-pager', :text => "1 of 2 results Next")
    end
  end

end

####################################################################################################


describe "complex object view" do
  before(:all) do
    @unit = DamsUnit.create( pid: 'xx48484848', name: 'Test Unit', description: 'Test Description',
                             code: 'tu', group: 'dams-curator', uri: 'http://example.com/' )
    @commonName = DamsCommonName.create(pid: 'xx484848cn', name: 'thale-cress')
    @damsComplexObj = DamsObject.create(pid: "xx97626129")
    @damsComplexObj.damsMetadata.content = File.new('spec/fixtures/damsComplexObject3.rdf.xml').read
    @damsComplexObj.save!
    solr_index (@damsComplexObj.pid)
  end
  after(:all) do
    @damsComplexObj.delete
    @unit.delete
    @commonName.delete
  end
  it "should see the component hierarchy view" do
    visit dams_object_path(@damsComplexObj.pid)
    expect(page).to have_selector('h1:first',:text=>'PPTU04WT-027D (dredge, rock)')
    expect(page).to have_selector('h1[1]',:text=>'Interval 1 (dredge, rock)')
    expect(page).to have_selector('button#node-btn-1',:text => 'Interval 1 (dredge, rock)')
    expect(page).to have_selector('button#node-btn-2',:text => 'Files')

    #click on grand child link
    click_on 'Image 001'
    expect(page).to have_selector('h1:first',:text=>'PPTU04WT-027D (dredge, rock)')
    expect(page).to have_selector('h1[1]',:text=>'Image 001')

    #return to the top level record
    click_on 'Components'
    expect(page).to have_selector('h1:first',:text=>'PPTU04WT-027D (dredge, rock)')
    expect(page).to have_selector('h1[1]',:text=>'Interval 1 (dredge, rock)')
  end
  it "should display iternal and external reference common names in object level and components" do
    visit dams_object_path(@damsComplexObj.pid)
    expect(page).to have_selector('li', text: 'thale-cress')
    expect(page).to have_selector('li', text: 'thale-cress component')
  end

  it 'should display component pager' do
    visit dams_object_path(@damsComplexObj.pid)
    expect(page).to have_selector('#component-pager')
  end

  it 'testing component pager functionality' do
    Capybara.javascript_driver = :poltergeist
    Capybara.current_driver = Capybara.javascript_driver
    visit dams_object_path(@damsComplexObj.pid)
    click_button 'component-pager-back'
    find('#component-pager-label').should have_content('Component 1 of 4')
    click_button 'component-pager-forward'
    find('#component-pager-label').should have_content('Component 2 of 4')
    click_button 'component-pager-forward'
    find('#component-pager-label').should have_content('Component 3 of 4')
    click_button 'component-pager-forward'
    find('#component-pager-label').should have_content('Component 4 of 4')
    click_button 'component-pager-forward'
    find('#component-pager-label').should have_content('Component 4 of 4')
    click_button 'component-pager-back'
    find('#component-pager-label').should have_content('Component 3 of 4')
  end

end

describe "complex object component view" do
  before(:all) do
    @damsComplexObj4 = DamsObject.create(pid: "xx080808xx")
    @damsComplexObj4.damsMetadata.content = File.new('spec/fixtures/damsComplexObject4.rdf.xml').read
    @damsComplexObj4.save!
    solr_index (@damsComplexObj4.pid)
  end
  after(:all) do
    @damsComplexObj4.delete
    damsUnit = DamsUnit.find('xx080808uu')
    damsUnit.delete
  end
  it "should not see the generic component title" do
    visit dams_object_path(@damsComplexObj4.pid)
    expect(page).not_to have_content "Generic Component Title"
    expect(page).to have_content "Component 1 Title"
    expect(page).to have_content "Component 2 Title"
    expect(page).to have_content "Component 3 Title"
    expect(page).to have_content "Component 4 Title"
  end
  it "should have component notes" do
    sign_in_developer
    visit dams_object_path(@damsComplexObj4.pid)
    expect(page).to have_selector('div.file-metadata td', 'Identifier')
    expect(page).to have_selector('div.file-metadata p', 'abc123')
    expect(page).to have_selector('div.file-metadata span.dams-note-display-label', 'Local')
  end
  it "should have multiple related resources in component" do
    sign_in_developer
    visit dams_object_path(@damsComplexObj4.pid)
    expect(page).to have_selector('div.file-metadata td', 'Related Resource')
    expect(page).to have_content 'Related'
    expect(page).to have_content 'RELATED RESOURCE CONTENT 1'
    expect(page).to have_content 'Related'
    expect(page).to have_content 'RELATED RESOURCE CONTENT 2'
  end
end

describe "complex object component view" do
  before(:all) do
    @damsComplexObj5 = DamsObject.create(pid: "xx2322141x")
    @damsComplexObj5.damsMetadata.content = File.new('spec/fixtures/damsComplexObject5.rdf.xml').read
    @damsComplexObj5.save!
    solr_index (@damsComplexObj5.pid)
  end
  after(:all) do
    @damsComplexObj5.delete
    damsUnit = DamsUnit.find('xx080808uu')
    damsUnit.delete
  end
  it "should not see repeated component title" do
    visit dams_object_path(@damsComplexObj5.pid)
    expect(page).to have_content "Sample Wagner Record Structure"
    expect(page).to have_selector('button#node-btn-1:first',:text=>'Parameters')
    expect(page).not_to have_css("button#node-btn-1", :count => 2)
  end
  it "should see label Creation Date and Date Issued" do
    visit dams_object_path(@damsComplexObj5.pid)
    expect(page).to have_selector('dt', :text=>'Creation Date')
    expect(page).to have_selector('dt', :text=>'Date Issued')
  end
end

describe "audio complex object view" do
  before(:all) do
    @unit = DamsUnit.create( pid: 'xx48484848', name: 'Test Unit', description: 'Test Description',
                             code: 'tu', group: 'dams-curator', uri: 'http://example.com/' )
    @audioComplexObj = DamsObject.create( titleValue: 'Sonic Waters Archive 1981-84', typeOfResource: 'sound recording',
                                          unitURI: [ @unit.pid ], copyright_attributes: [{status: 'Public domain'}] )
    @audioComplexObj.add_file( 'dummy audio content', '_1_1.mp3', 'test.mp3' )
    @audioComplexObj.add_file( 'dummy audio content 2', '_2_1.wav', 'test2.wav' )
    @audioComplexObj.add_file( 'dummy audio content 3', '_3_1.mp3', 'test3.wav' )
    @audioComplexObj.save!
    solr_index (@unit.pid)
    solr_index (@audioComplexObj.pid)
  end
  after(:all) do
    @audioComplexObj.delete
    @unit.delete
  end
  it "should display the first component file content in the file viewing panel" do
    pending("Failed due to jwplayer 8.5.6 upgrade.  Will check again for future jwplayer upgrade.")
    Capybara.javascript_driver = :poltergeist
    Capybara.current_driver = Capybara.javascript_driver
    visit dams_object_path(@audioComplexObj.pid)
    expect(page).to have_content "Sonic Waters Archive 1981-84"
    expect(page).to have_selector('#component-pager-label', :text=>'Component 1 of 3')
    expect(page).to have_content('Generic Component Title 1')
    expect(page).to have_selector('div[id="component-1"][class="component first-component"][data="1"][style="display: block;"]')
    expect(page).to have_selector('#dams-audio-1',:text=>'loading player')
  end
end

describe "Curator User wants to view a metadata-only complex object" do
  let(:restricted_note) {'Restricted View Content not available. Access may granted for research purposes at the discretion of the UC San Diego Library. For more information please contact the Research Data Curation Program at research-data-curation@ucsd.edu'}
  before do
    @otherRight = DamsOtherRight.create pid: 'xx58718348', permissionType: "metadataDisplay"
    @metadataOnlyCollection = DamsProvenanceCollection.create pid: 'xx91824453', titleValue: "Test UCSD IP only Collection with metadata-only visibility", visibility: "local"
    @metadataOnlyObj = DamsObject.create(pid: "xx99999999")
    @metadataOnlyObj.damsMetadata.content = File.new('spec/fixtures/damsComplexObject10.rdf.xml').read
    @metadataOnlyObj.save!
    solr_index @otherRight.pid
    solr_index @metadataOnlyCollection.pid
    solr_index @metadataOnlyObj.pid
    Capybara.javascript_driver = :poltergeist
    Capybara.current_driver = Capybara.javascript_driver
    sign_in_developer
  end

  after do
    @otherRight.delete
    @metadataOnlyCollection.delete
    @metadataOnlyObj.delete
  end

  scenario 'should see Restricted access control information but not banner access text' do
    visit dams_object_path @metadataOnlyObj.pid
    expect(page).to have_selector('#component-pager-label', :text=>'Component 1 of 4')
    expect(page).to have_content('Interval 1 (dredge, rock)')
    expect(page).to have_selector('div.file-metadata', text: 'Restricted to UC San Diego use only')
    expect(page).to_not have_selector('div.restricted-notice-complex', text: restricted_note)
  end

  scenario 'should see Restricted access control info in other component' do
    visit dams_object_path @metadataOnlyObj.pid
    click_button 'component-pager-forward'
    find('#component-pager-label').should have_content('Component 2 of 4')
    expect(page).to have_content('Files')
    expect(page).to have_selector('div.file-metadata', text: 'Access Restricted to UC San Diego use only')
  end
end

describe "curator embargoed object view" do
  let (:embargo_note) { "Image not available due to cultural sensitivities of the community depicted. Access may be granted for research purposes at the discretion of the UC San Diego Library. For more information please contact the Special Collections & Archives at spcoll@ucsd.edu or (858) 534-2533." }
  before do
    @damsUnit = DamsUnit.create( pid: 'zz48484848', name: 'Test Unit', description: 'Test Description',
                                 code: 'tu', group: 'dams-curator', uri: 'http://example.com/' )
    @damsEmbObj = DamsObject.new(pid: "zz2765588d")
    @damsEmbObj.damsMetadata.content = File.new('spec/fixtures/embargoedObject.rdf.xml').read
    @damsEmbObj.save!
    solr_index (@damsEmbObj.pid)
  end
  after do
    @damsEmbObj.delete
    @damsUnit.delete
  end

  it "curator should not see the embargo banner and view content button" do
    sign_in_developer
    visit dams_object_path(@damsEmbObj.pid)
    expect(page).to have_no_selector('div.restricted-notice', text: embargo_note)
    expect(page).to have_no_selector('button#view-masked-object',:text=>'Yes, I would like to view this content.')
  end

  it "public user should see Response Status Code 404 - not found page" do
    visit dams_object_path(@damsEmbObj.pid)
    expect(page.driver.response.status).to eq( 404 )
  end

  scenario 'local user should see Response Status Code 404 - not found page' do
    sign_in_anonymous '132.239.0.3'
    visit dams_object_path(@damsEmbObj.pid)
    expect(page.driver.response.status).to eq( 404 )
  end

end

describe "Display internal personal name field" do
  before do
    @unit = DamsUnit.create pid: 'xx48484848', name: "Test Unit", description: "Test Description",
                            code: "tu", uri: "http://example.com/"
    @ctsObject = DamsObject.create(pid: "xx21171293")
    @ctsObject.damsMetadata.content = File.new('spec/fixtures/damsObjectNewspaper.rdf.xml').read
    @ctsObject.save!
    solr_index (@ctsObject.pid)
  end
  after do
    @ctsObject.delete
    @unit.delete
  end
  it "should sort the note fields" do
    visit dams_object_path(@ctsObject.pid)
    expect(page).to have_content "Internal Personal Name"
  end
end

describe "Curator complex object viewer" do
  before(:all) do
    @unit = DamsUnit.create pid: 'xx48484848', name: "Test Unit", description: "Test Description",
                            code: "tu", uri: "http://example.com/"
    @damsComplexObj8 = DamsObject.create(pid: "xx080808xx")
    @damsComplexObj8.damsMetadata.content = File.new('spec/fixtures/damsComplexObject8.rdf.xml').read
    @damsComplexObj8.add_file( 'dummy tiff content', "_1_1.tif", "test.tif" )
    @damsComplexObj8.add_file( 'dummy jpeg content', "_1_2.jpg", "test.jpg" )
    @damsComplexObj8.save!
    solr_index (@damsComplexObj8.pid)
  end
  after(:all) do
    @damsComplexObj8.delete
    @unit.delete
  end
  it "should have download link to master file" do
    sign_in_developer
    visit dams_object_path(@damsComplexObj8.pid)
    expect(page).to have_content "Component 1 Title"
    expect(page).to have_link('', href:"/object/xx080808xx/_1_1.tif/download?access=curator")
  end
  it "should have the label 'Components' in the component header" do
    sign_in_developer
    visit dams_object_path(@damsComplexObj8.pid)
    expect(page).to have_selector('strong',:text=>'Components')
  end
end

describe "PDF Viewer" do
  before(:all) do
    @unit = DamsUnit.create pid: 'xx48484848', name: "Test Unit", description: "Test Description",
                            code: "tu", uri: "http://example.com/"
    @damsPdfObj = DamsObject.create(pid: "xx21171293")
    @damsPdfObj.damsMetadata.content = File.new('spec/fixtures/damsObjectNewspaper.rdf.xml').read
    @damsPdfObj.save!
    solr_index (@damsPdfObj.pid)
  end
  after(:all) do
    @damsPdfObj.delete
    @unit.delete
  end
  it "should show a 'View file' button and a 'Download file' button " do
    visit dams_object_path(@damsPdfObj.pid)
    expect(page).to have_selector('#data-view-file')
    expect(page).to have_selector('#data-download-file')
    expect(page).to have_selector('#data-download-file-phone')
  end
end

describe "object with subscripts and superscripts title" do
  before do
    @damsUnit = DamsUnit.create( pid: 'zz48484848', name: 'Test Unit', description: 'Test Description',
                                 code: 'tu', group: 'dams-curator', uri: 'http://example.com/' )
    @damsObj = DamsObject.new(pid: "bd91298321")
    @damsObj.damsMetadata.content = File.new('spec/fixtures/damsObjectSubscriptTitle.xml').read
    @damsObj.save!
    solr_index (@damsObj.pid)
  end
  after do
    @damsObj.delete
    @damsUnit.delete
  end

  it "should not see the view content button" do
    sign_in_developer
    visit dams_object_path(@damsObj.pid)
    expect(page).to_not have_content('Data from: Coordination-Dependent Spectroscopic Signatures of Divalent Metal Ion Binding to Carboxylate Head Groups: H&lt;sub&gt;2&lt;/sub&gt;- and He-Tagged Vibrational Spectra of M&lt;sup&gt;2+&lt;/sup&gt;·RCO&lt;sub&gt;2&lt;/sub&gt;&lt;sup&gt;-&lt;/sup&gt; (M = Mg and Ca, R = −CD&lt;sub&gt;3&lt;/sub&gt;, −CD&lt;sub&gt;2&lt;/sub&gt;CD&lt;sub&gt;3&lt;/sub&gt;) Complexes')
    expect(page).to have_content('Data from: Coordination-Dependent Spectroscopic Signatures of Divalent Metal Ion Binding to Carboxylate Head Groups: H2- and He-Tagged Vibrational Spectra of M2+·RCO2- (M = Mg and Ca, R = −CD3, −CD2CD3) Complexes Creation')
  end
end

#---

describe 'User wants to see object view' do
  before do
    @unit = DamsUnit.create pid: 'xx48484848', name: "Test Unit", description: "Test Description",
                            code: "tu", uri: "http://example.com/", group: 'dams-curator'
    @ctsObject = DamsObject.create(pid: "xx21171293")
    @ctsObject.damsMetadata.content = File.new('spec/fixtures/damsComplexObject1.rdf.xml').read
    @ctsObject.save!
    solr_index (@ctsObject.pid)
  end
  after do
    @ctsObject.delete
    @unit.delete
  end
  it 'with access control information on page (curator)' do
    sign_in_developer
    visit dams_object_path(@ctsObject.pid)
    expect(page).to have_content('AccessCurator Only')
  end
end

describe "Cartographic Record" do
  before(:all) do
    ns = Rails.configuration.id_namespace
    @cart = DamsCartographics.create( point: '19.7667,-154.8' )
    @unit = DamsUnit.create( name: 'Test Unit', description: 'Test Description', code: 'tu',
                             group: 'dams-curator', uri: 'http://example.com/' )
    @cartObj = DamsObject.create( titleValue: 'Cartographic Test',
                                  cartographics_attributes: [{ id: RDF::URI.new("#{ns}#{@cart.pid}") }],
                                  unit_attributes: [{ id: RDF::URI.new("#{ns}#{@unit.pid}") }]
    )
    solr_index @cart.pid
    solr_index @unit.pid
    solr_index @cartObj.pid
  end
  after(:all) do
    @cartObj.delete
    @cart.delete
    @unit.delete
  end
  it "should display cartographic map" do
    Capybara.javascript_driver = :poltergeist
    Capybara.current_driver = Capybara.javascript_driver
    sign_in_developer
    visit dams_object_path @cartObj
    expect(page.status_code).to eq(200)
    expect(page).to have_selector('div[id="map-canvas"][data=\'{"type":"point","coords":"19.7667,-154.8"}\']')
    expect(page).to have_css('img.leaflet-tile-loaded[src="https://c.tiles.mapbox.com/v4/mapquest.streets-mb/4/0/6.png?access_token=pk.eyJ1IjoibWFwcXVlc3QiLCJhIjoiY2Q2N2RlMmNhY2NiZTRkMzlmZjJmZDk0NWU0ZGJlNTMifQ.mPRiEubbajc6a5y9ISgydg"]')
  end
end

describe "User wants to view simple object for local metadata-only collection" do
  before(:all) do
    ns = Rails.configuration.id_namespace
    @restricted_note = "Restricted ViewContent not available. Access may granted for research purposes at the discretion of the UC San Diego Library."
    @note = DamsNote.create type: "local attribution", value: "Digital Library Development Program, UC San Diego, La Jolla, 92093-0175"
    @localDisplay = DamsOtherRight.create permissionType: "localDisplay"
    @metadataDisplay = DamsOtherRight.create permissionType: "metadataDisplay"
    @metadataOnlyCollection = DamsProvenanceCollection.create titleValue: "Test UCSD IP only Collection with metadata-only visibility", visibility: "local"
    @localOnlyCollection = DamsProvenanceCollection.create titleValue: "Test UCSD IP only Collection with localDisplay visibility", visibility: "local"
    @collection = DamsProvenanceCollection.create titleValue: "Test UCSD IP only Collection with no localDisplay or metadata-only visibility", visibility: "local"
    @metadataOnlyObj = DamsObject.create titleValue: 'Test Object with metadataOnly Display', note_attributes: [{ id: RDF::URI.new("#{ns}#{@note.pid}") }], copyright_attributes: [{status: 'Public domain'}]
    @metadataOnlyObj.provenanceCollectionURI = @metadataOnlyCollection.pid
    @metadataOnlyObj.otherRightsURI = @metadataDisplay.pid
    @metadataOnlyObj.add_file( 'video content', '_1.mp4', 'test.mp4' )
    @metadataOnlyObj.save!
    @localObj = DamsObject.create titleValue: 'Test Object with localDisplay', provenanceCollectionURI: @localOnlyCollection.pid, otherRightsURI: @localDisplay.pid, note_attributes: [{ id: RDF::URI.new("#{ns}#{@note.pid}") }], copyright_attributes: [{status: 'Public domain'}]
    @obj = DamsObject.create titleValue: 'Test Object with no localDisplay, no metadataOnlyDisplay', provenanceCollectionURI: @localOnlyCollection.pid, copyright_attributes: [{status: 'Public domain'}]
    solr_index @note.pid
    solr_index @localDisplay.pid
    solr_index @metadataDisplay.pid
    solr_index @metadataOnlyCollection.pid
    solr_index @localOnlyCollection.pid
    solr_index @collection.pid
    solr_index @metadataOnlyObj.pid
    solr_index @localObj.pid
    solr_index @obj.pid
  end

  after(:all) do
    @note.delete
    @localDisplay.delete
    @metadataDisplay.delete
    @metadataOnlyCollection.delete
    @localOnlyCollection.delete
    @collection.delete
    @metadataOnlyObj.delete
    @localObj.delete
    @obj.delete
  end

  scenario 'curator user should see Restricted access control information and download link' do
    sign_in_developer
    visit dams_object_path @metadataOnlyObj.pid
    expect(page).to have_content('Restricted to UC San Diego use only')
    expect(page).to have_link('', href:"/object/#{@metadataOnlyObj.id}/_1.mp4/download?access=curator")
    visit dams_object_path @localObj.pid
    expect(page).to have_content('Restricted to UC San Diego use only')
  end

  scenario 'curator user should not see Restricted View access control information' do
    sign_in_developer
    visit dams_object_path @obj.pid
    expect(page).to_not have_content('Restricted View')
  end

  scenario 'curator user should not see Restricted View access text' do
    sign_in_developer
    visit dams_object_path @metadataOnlyObj.pid
    expect(page).to_not have_selector('div.restricted-notice', text: @restricted_note)
  end

  scenario 'curator user should see the collection link' do
    sign_in_developer
    visit dams_object_path @metadataOnlyObj.pid
    expect(page).to have_link('Test UCSD IP only Collection with metadata-only visibility', :href => "#{dams_collection_path @metadataOnlyCollection.pid}")
  end

  scenario 'local user should not see Restricted View label, access text or download link' do
    sign_in_anonymous '132.239.0.3'
    visit dams_object_path @metadataOnlyObj.pid
    expect(page).to_not have_content('Restricted View')
    expect(page).to_not have_selector('div.restricted-notice', text: @restricted_note)
    expect(page).to_not have_link('', href:"/object/#{@metadataOnlyObj.id}/_1.mp4/download")
  end

  scenario 'local user should see the collection link' do
    sign_in_anonymous '132.239.0.3'
    visit dams_object_path @metadataOnlyObj.pid
    expect(page).to have_link('Test UCSD IP only Collection with metadata-only visibility', :href => "#{dams_collection_path @metadataOnlyCollection.pid}")
  end

  scenario 'public user should see Restricted View access text and no download link' do
    visit dams_object_path @metadataOnlyObj.pid
    expect(page).to have_content('Restricted View')
    expect(page).to have_selector('div.restricted-notice', text: @restricted_note)
    expect(page).to_not have_link('', href:"/object/#{@metadataOnlyObj.id}/_1.mp4/download")
  end

  scenario 'public user should see the collection link' do
    visit dams_object_path @metadataOnlyObj.pid
    expect(page).to have_link('Test UCSD IP only Collection with metadata-only visibility', :href => "#{dams_collection_path @metadataOnlyCollection.pid}")
  end
end

describe "User wants to view simple object for public metadata-only collection" do
  before(:all) do
    ns = Rails.configuration.id_namespace
    @restricted_note = "Restricted ViewContent not available. Access may granted for research purposes at the discretion of the UC San Diego Library."
    @note = DamsNote.create type: "local attribution", value: "Digital Library Development Program, UC San Diego, La Jolla, 92093-0175"
    @metadataDisplay = DamsOtherRight.create permissionType: "metadataDisplay"
    @publicCollection = DamsProvenanceCollection.create titleValue: "Test Public metadata-only Collection", visibility: "public"
    @metadataOnlyObj = DamsObject.create titleValue: 'Test Object', note_attributes: [{ id: RDF::URI.new("#{ns}#{@note.pid}") }], copyright_attributes: [{status: 'Under copyright'}]
    @metadataOnlyObj.provenanceCollectionURI = @publicCollection.pid
    @metadataOnlyObj.otherRightsURI = @metadataDisplay.pid
    @metadataOnlyObj.add_file( 'video content', '_1.mp4', 'test.mp4' )
    @metadataOnlyObj.save!
    solr_index @note.pid
    solr_index @metadataDisplay.pid
    solr_index @publicCollection.pid
    solr_index @metadataOnlyObj.pid
  end

  after(:all) do
    @note.delete
    @metadataDisplay.delete
    @publicCollection.delete
    @metadataOnlyObj.delete
  end

  scenario 'curator user should not see Restricted View access text' do
    sign_in_developer
    visit dams_object_path @metadataOnlyObj.pid
    expect(page).to_not have_selector('div.restricted-notice', text: @restricted_note)
  end

  scenario 'curator user should see Restricted View access control information and download link' do
    sign_in_developer
    visit dams_object_path @metadataOnlyObj.pid
    expect(page).to have_content('Restricted View')
    expect(page).to have_link('', href:"/object/#{@metadataOnlyObj.id}/_1.mp4/download?access=curator")
  end

  scenario 'local user should see Access label' do
    sign_in_anonymous '132.239.0.3'
    visit dams_object_path @metadataOnlyObj.pid
    expect(page).to have_content('AccessRestricted View')
  end

  scenario 'local user should see Restricted View access text' do
    sign_in_anonymous '132.239.0.3'
    visit dams_object_path @metadataOnlyObj.pid
    expect(page).to have_selector('div.restricted-notice', text: @restricted_note)
  end

  scenario 'local user should not see download button' do
    sign_in_anonymous '132.239.0.3'
    visit dams_object_path @metadataOnlyObj.pid
    expect(page).to_not have_link('', href:"/object/#{@metadataOnlyObj.id}/_1.mp4/download")
  end

  scenario 'public user should see Access Information and Restricted View access text' do
    visit dams_object_path @metadataOnlyObj.pid
    expect(page).to have_content('Restricted View')
    expect(page).to have_selector('div.restricted-notice', text: @restricted_note)
    expect(page).to_not have_link('', href:"/object/#{@metadataOnlyObj.id}/_1.mp4/download")
  end

  scenario 'public user should not see download button' do
    visit dams_object_path @metadataOnlyObj.pid
    expect(page).to_not have_link('', href:"/object/#{@metadataOnlyObj.id}/_1.mp4/download")
  end

end

describe "User wants to view a PDF simple object for local metadata-only collection" do
  before(:all) do
    ns = Rails.configuration.id_namespace
    @restricted_note = "Restricted ViewContent not available. Access may granted for research purposes at the discretion of the UC San Diego Library."
    @note = DamsNote.create type: "local attribution", value: "Digital Library Development Program, UC San Diego, La Jolla, 92093-0175"
    @metadataDisplay = DamsOtherRight.create permissionType: "metadataDisplay"
    @metadataOnlyCollection = DamsProvenanceCollection.create titleValue: "Test UCSD IP only Collection with metadata-only visibility", visibility: "local"
    @metadataOnlyObj = DamsObject.create titleValue: 'Test Object with metadataOnly Display', note_attributes: [{ id: RDF::URI.new("#{ns}#{@note.pid}") }], copyright_attributes: [{status: 'Under copyright'}]
    @metadataOnlyObj.provenanceCollectionURI = @metadataOnlyCollection.pid
    @metadataOnlyObj.otherRightsURI = @metadataDisplay.pid
    @metadataOnlyObj.add_file( 'pdf content', '_1.pdf', 'test.pdf' )
    @metadataOnlyObj.save!
    solr_index @note.pid
    solr_index @metadataDisplay.pid
    solr_index @metadataOnlyCollection.pid
    solr_index @metadataOnlyObj.pid
  end

  after(:all) do
    @note.delete
    @metadataDisplay.delete
    @metadataOnlyCollection.delete
    @metadataOnlyObj.delete
  end

  scenario 'curator user should see download link' do
    sign_in_developer
    visit dams_object_path @metadataOnlyObj.pid
    expect(page).to have_link('', href:"/object/#{@metadataOnlyObj.id}/_1.pdf/download?access=curator")
  end

  scenario 'local user should not see download link' do
    sign_in_anonymous '132.239.0.3'
    visit dams_object_path @metadataOnlyObj.pid
    expect(page).to_not have_link('', href:"/object/#{@metadataOnlyObj.id}/_1.pdf/download")
  end

  scenario 'public user should not see download link' do
    visit dams_object_path @metadataOnlyObj.pid
    expect(page).to_not have_link('', href:"/object/#{@metadataOnlyObj.id}/_1.pdf/download")
  end
end

describe "User wants to view complex object for public metadata-only collection" do
  let (:restricted_note) { "Restricted ViewContent not available. Access may granted for research purposes at the discretion of the UC San Diego Library. For more information please contact the Digital Library Development Program at dlp@ucsd.edu" }

  before(:all) do
    Capybara.javascript_driver = :poltergeist
    Capybara.current_driver = Capybara.javascript_driver
    @tif_content = 'R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7=='
    @jpg_content = '/9j/4AAQSkZJRgABAQEAAQABAAD//2gAIAQEAAD8AVN//2Q=='
    @note = { type: "local attribution", value: "Digital Library Development Program, UC San Diego, La Jolla, 92093-0175" }

    @metadataDisplay = DamsOtherRight.create permissionType: "metadataDisplay"
    @publicCollection = DamsProvenanceCollection.create titleValue: "Test Public metadata-only Collection", visibility: "public"
    @complexMetaObj = DamsObject.create titleValue: 'Complex Object for Public UCSD Collection with metadataDisplay otherRights', typeOfResource: 'Still Image', note_attributes: [@note], copyright_attributes: [{status: 'Under copyright'}]
    @complexMetaObj.otherRightsURI = @metadataDisplay.pid
    @complexMetaObj.provenanceCollectionURI = @publicCollection.pid
    @complexMetaObj.add_file( Base64.decode64(@tif_content), '_1_1.tif', 'image_source1.tif' )
    @complexMetaObj.add_file( Base64.decode64(@jpg_content), '_1_2.jpg', 'image_service1.jpg' )
    @complexMetaObj.add_file( Base64.decode64(@tif_content), '_2_1.tif', 'image_source2.tif' )
    @complexMetaObj.add_file( Base64.decode64(@jpg_content), '_2_2.jpg', 'image_service2.jpg' )
    @complexMetaObj.save!

    solr_index @metadataDisplay.pid
    solr_index @publicCollection.pid
    solr_index @complexMetaObj.pid
  end

  after(:all) do
    @metadataDisplay.delete
    @publicCollection.delete
    @complexMetaObj.delete
  end

  scenario 'curator user should not see Restricted View access text' do
    sign_in_developer
    visit dams_object_path @complexMetaObj.pid
    expect(page).to_not have_selector('div.restricted-notice-complex', text: restricted_note)

    click_button 'component-pager-forward'
    expect(page).to have_content('Generic Component Title 2')
    expect(page).not_to have_selector('div.restricted-notice-complex', text: restricted_note)
  end

  scenario 'curator user should see Access information and download link' do
    sign_in_developer
    visit dams_object_path @complexMetaObj.pid
    expect(page).to have_content('Restricted View')
    expect(page).to have_link('', href:"/object/#{@complexMetaObj.id}/_1_1.tif/download?access=curator")
    click_button 'component-pager-forward'
    expect(page).to have_content('Generic Component Title 2')
    expect(page).to have_link('', href:"/object/#{@complexMetaObj.id}/_2_1.tif/download?access=curator")
  end

  scenario 'local user should see Access label' do
    sign_in_anonymous '132.239.0.3'
    visit dams_object_path @complexMetaObj.pid
    expect(page).to have_content('Restricted View')
  end

  scenario 'local user should see Restricted View access text' do
    sign_in_anonymous '132.239.0.3'
    visit dams_object_path @complexMetaObj.pid
    expect(page).to have_selector('div.restricted-notice-complex', text: restricted_note)

    click_button 'component-pager-forward'
    expect(page).to have_content('Generic Component Title 2')
    expect(page).to have_selector('div.restricted-notice-complex', text: restricted_note)
  end

  scenario 'local user should not see download button' do
    sign_in_anonymous '132.239.0.3'
    visit dams_object_path @complexMetaObj.pid
    expect(page).to_not have_link('', href:"/object/#{@complexMetaObj.id}/_1_2.jpg/download")
    click_button 'component-pager-forward'
    expect(page).to have_content('Generic Component Title 2')
    expect(page).to_not have_link('', href:"/object/#{@complexMetaObj.id}/_2_2.jpg/download")
  end

  scenario 'public user should see Access Information and Restricted View access text' do
    visit dams_object_path @complexMetaObj.pid
    expect(page).to have_content('Restricted View')
    expect(page).to have_selector('div.restricted-notice-complex', text: restricted_note)

    click_button 'component-pager-forward'
    expect(page).to have_content('Generic Component Title 2')
    expect(page).to have_selector('div.restricted-notice-complex', text: restricted_note)
  end

  scenario 'public user should not see download button' do
    visit dams_object_path @complexMetaObj.pid
    expect(page).to_not have_link('', href:"/object/#{@complexMetaObj.id}/_1_2.jpg/download")
    click_button 'component-pager-forward'
    expect(page).to have_content('Generic Component Title 2')
    expect(page).to_not have_link('', href:"/object/#{@complexMetaObj.id}/_2_2.jpg/download")
  end
end

describe "View simple UCSD localDisplay object" do
  let (:restricted_note) { "Restricted ViewContent not available. Access may granted for research purposes at the discretion of the UC San Diego Library. For more information please contact the Digital Library Development Program at dlp@ucsd.edu" }

  before(:all) do
    @note = { type: "local attribution", value: "Digital Library Development Program, UC San Diego, La Jolla, 92093-0175" }
    @licenseLocalDisplay = DamsLicense.create permissionType: "localDisplay"
    @localDisplay = DamsOtherRight.create permissionType: "localDisplay"
    @localOnlyCollection = DamsProvenanceCollection.create titleValue: "Test UCSD IP only Simple Object Collection with localDisplay visibility", visibility: "local"

    @licenseLocalObj = DamsObject.create titleValue: 'Test Object with License localDisplay', note_attributes: [@note], copyright_attributes: [{status: 'Unknown'}]
    @licenseLocalObj.provenanceCollectionURI = @localOnlyCollection.pid
    @licenseLocalObj.licenseURI = @licenseLocalDisplay.pid
    @licenseLocalObj.save

    @localObj = DamsObject.create titleValue: 'Test Object with localDisplay', note_attributes: [@note], copyright_attributes: [{status: 'Unknown'}]
    @localObj.provenanceCollectionURI = @localOnlyCollection.pid
    @localObj.otherRightsURI = @localDisplay.pid
    @localObj.add_file(Base64.decode64('R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7=='), '_1.tif', 'image_source.tif')
    @localObj.add_file(Base64.decode64('/9j/4AAQSkZJRgABAQEAAQABAAD//2gAIAQEAAD8AVN//2Q=='), '_2.jpg', 'image_service.jpg')
    @localObj.save

    solr_index @localDisplay.pid
    solr_index @localOnlyCollection.pid
    solr_index @localObj.pid
    solr_index @licenseLocalObj.pid
  end

  after(:all) do
    @licenseLocalDisplay.delete
    @localDisplay.delete
    @localOnlyCollection.delete
    @localObj.delete
    @licenseLocalObj.delete
  end

  scenario 'public user should see Restricted View access text in license localDisplay object' do
    visit dams_object_path @licenseLocalObj.pid
    expect(page).to have_selector('div.restricted-notice', text: restricted_note)
  end

  scenario 'local user should not see Restricted View access text in license localDisplay object' do
    sign_in_anonymous '132.239.0.3'
    visit dams_object_path @licenseLocalObj.pid
    expect(page).not_to have_selector('div.restricted-notice', text: restricted_note)
  end

  scenario 'curator user should not see Restricted View access text in license localDisplay object' do
    sign_in_developer
    visit dams_object_path @licenseLocalObj.pid
    expect(page).to_not have_selector('div.restricted-notice', text: restricted_note)
  end

  scenario 'public user should see Restricted View access text in OtherRights localDisplay object' do
    visit dams_object_path @localObj.pid
    expect(page).to have_selector('div.restricted-notice', text: restricted_note)
  end

  scenario 'local user should not see Restricted View access text in OtherRights localDisplay object' do
    sign_in_anonymous '132.239.0.3'
    visit dams_object_path @localObj.pid
    expect(page).not_to have_selector('div.restricted-notice', text: restricted_note)
  end

  scenario 'curator user should not see Restricted View access text in OtherRights localDisplay object' do
    sign_in_developer
    visit dams_object_path @localObj.pid
    expect(page).to_not have_selector('div.restricted-notice', text: restricted_note)
  end

  scenario 'public user should not see download button for any images in localDisplay object' do
    visit dams_object_path @localObj.pid
    expect(page).not_to have_link('', href:"/object/#{@localObj.pid}/_2.jpg/download")
  end

  scenario 'local user should see download button for service derivative in localDisplay object' do
    sign_in_anonymous '132.239.0.3'
    visit dams_object_path @localObj.pid
    expect(page).to have_link('', href:"/object/#{@localObj.pid}/_2.jpg/download")
  end

  scenario 'curator should see download button for master image in localDisplay object' do
    sign_in_developer
    visit dams_object_path @localObj.pid
    expect(page).to have_link('', href:"/object/#{@localObj.pid}/_1.tif/download?access=curator")
  end
end

describe "View complex UCSD localDisplay object" do
  let (:restricted_note) { "Restricted View Content not available. Access may granted for research purposes at the discretion of the UC San Diego Library. For more information please contact the Digital Library Development Program at dlp@ucsd.edu" }

  before(:all) do
    Capybara.javascript_driver = :poltergeist
    Capybara.current_driver = Capybara.javascript_driver
    @tif_content = 'R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7=='
    @jpg_content = '/9j/4AAQSkZJRgABAQEAAQABAAD//2gAIAQEAAD8AVN//2Q=='
    @note = { type: "local attribution", value: "Digital Library Development Program, UC San Diego, La Jolla, 92093-0175" }

    @localDisplay = DamsOtherRight.create permissionType: "localDisplay"
    @localCollection = DamsProvenanceCollection.create titleValue: "Test UCSD IP only Complex Object Collection", visibility: "local"
    @localObj = DamsObject.create titleValue: 'Complex Object with UCSD localDisplay', typeOfResource: 'Still Image', note_attributes: [@note], copyright_attributes: [{status: 'Unknown'}]

    @localObj.otherRightsURI = @localDisplay.pid
    @localObj.provenanceCollectionURI = @localCollection.pid
    @localObj.add_file( Base64.decode64(@tif_content), '_1_1.tif', 'image_source1.tif' )
    @localObj.add_file( Base64.decode64(@jpg_content), '_1_2.jpg', 'image_service1.jpg' )
    @localObj.add_file( Base64.decode64(@tif_content), '_2_1.tif', 'image_source2.tif' )
    @localObj.add_file( Base64.decode64(@jpg_content), '_2_2.jpg', 'image_service2.jpg' )
    @localObj.save!

    solr_index @localDisplay.pid
    solr_index @localCollection.pid
    solr_index @localObj.pid
  end

  after(:all) do
    @localDisplay.delete
    @localCollection.delete
    @localObj.delete
  end

  scenario 'public user should see Restricted View access text in localDisplay object' do
    visit dams_object_path @localObj.pid
    expect(page).to have_selector('div.restricted-notice-complex', text: restricted_note)

    click_button 'component-pager-forward'
    expect(page).to have_content('Generic Component Title 2')
    expect(page).to have_selector('div.restricted-notice-complex', text: restricted_note)
  end

  scenario 'local user should not see Restricted View access text in localDisplay object' do
    sign_in_anonymous '132.239.0.3'
    visit dams_object_path @localObj.pid
    expect(page).not_to have_selector('div.restricted-notice-complex', text: restricted_note)

    click_button 'component-pager-forward'
    expect(page).to have_content('Generic Component Title 2')
    expect(page).not_to have_selector('div.restricted-notice-complex', text: restricted_note)
  end

  scenario 'curator user should not see Restricted View access text in localDisplay object' do
    sign_in_developer
    visit dams_object_path @localObj.pid
    expect(page).to_not have_selector('div.restricted-notice-complex', text: restricted_note)

    click_button 'component-pager-forward'
    expect(page).to have_content('Generic Component Title 2')
    expect(page).not_to have_selector('div.restricted-notice-complex', text: restricted_note)
  end

  scenario 'public user should not see download button for service derivative in localDisplay object' do
    visit dams_object_path @localObj.pid
    expect(page).to_not have_link('', href:"/object/#{@localObj.id}/_1_2.jpg/download")
    click_button 'component-pager-forward'
    expect(page).to have_content('Generic Component Title 2')
    expect(page).to_not have_link('', href:"/object/#{@localObj.id}/_2_2.jpg/download")
  end

  scenario 'local user should see download button for service derivative in localDisplay object' do
    sign_in_anonymous '132.239.0.3'
    visit dams_object_path @localObj.pid
    expect(page).to have_link('', href:"/object/#{@localObj.id}/_1_2.jpg/download")
    click_button 'component-pager-forward'
    expect(page).to have_content('Generic Component Title 2')
    expect(page).to have_link('', href:"/object/#{@localObj.id}/_2_2.jpg/download")
  end

  scenario 'curator user should see download button for image source in localDisplay object' do
    sign_in_developer
    visit dams_object_path @localObj.pid
    expect(page).to have_link('', href:"/object/#{@localObj.id}/_1_1.tif/download?access=curator")
    click_button 'component-pager-forward'
    expect(page).to have_content('Generic Component Title 2')
    expect(page).to have_link('', href:"/object/#{@localObj.id}/_2_1.tif/download?access=curator")
  end
end

describe "User wants to view a simple ucsd-only video" do
  before(:all) do
    @license = DamsLicense.create permissionType: "localDisplay"
    @otherRight = DamsOtherRight.create permissionType: "localDisplay"
    @localCollection = DamsProvenanceCollection.create titleValue: "Test UCSD IP only Collection", visibility: "local"
    @obj = DamsObject.create titleValue: 'Simple Video Object with localDisplay license', typeOfResource: 'video', provenanceCollectionURI: @localCollection.pid, copyright_attributes: [{status: 'Public domain'}]
    @obj.licenseURI = @license.pid
    @obj.save!
    @obj.add_file( 'video content', '_1.mp4', 'test.mp4' )
    @obj.save!
    @objOtherRight = DamsObject.create titleValue: 'Simple Video Object with localDisplay otherRight', typeOfResource: 'video', provenanceCollectionURI: @localCollection.pid, copyright_attributes: [{status: 'Public domain'}]
    @objOtherRight.otherRightsURI = @otherRight.pid
    @objOtherRight.save!
    @objOtherRight.add_file( 'video content 2', '_1.mp4', 'test2.mp4' )
    @objOtherRight.save!
    solr_index @license.pid
    solr_index @otherRight.pid
    solr_index @localCollection.pid
    solr_index @obj.pid
    solr_index @objOtherRight.pid
  end

  after(:all) do
    @otherRight.delete
    @localCollection.delete
    @license.delete
    @obj.delete
    @objOtherRight.delete
  end

  scenario 'curator user should see download link for localDisplay license object' do
    sign_in_developer
    visit dams_object_path @obj.pid
    expect(page).to have_link('', href:"/object/#{@obj.id}/_1.mp4/download?access=curator")
  end

  scenario 'local user should not see download link for localDisplay license object' do
    sign_in_anonymous '132.239.0.3'
    visit dams_object_path @obj.pid
    expect(page).to_not have_link('', href:"/object/#{@obj.id}/_1.mp4/download")
  end

  scenario 'curator user should see download link for localDisplay otherRights object' do
    sign_in_developer
    visit dams_object_path @objOtherRight.pid
    expect(page).to have_link('', href:"/object/#{@objOtherRight.id}/_1.mp4/download?access=curator")
  end

  scenario 'local user should not see download link for localDisplay otherRights object' do
    sign_in_anonymous '132.239.0.3'
    visit dams_object_path @objOtherRight.pid
    expect(page).to_not have_link('', href:"/object/#{@objOtherRight.id}/_1.mp4/download")
  end

  scenario 'user should see an embed link' do
    visit dams_object_path @obj.pid
    expect(page).to have_css("a", :text => "Embed")
  end

  scenario 'user should see embed video UI' do
    sign_in_anonymous '132.239.0.3'
    visit embed_path @obj.pid, '0'
    expect(page).to have_selector(:css, 'video#dams-video')
    expect(page.body).to match(/20775-#{@obj.pid}-0-1.mp4/)
  end
end

describe "User wants to view a complex ucsd-only video" do
  before(:all) do
    @license = DamsLicense.create permissionType: "localDisplay"
    @localCollection = DamsProvenanceCollection.create titleValue: "Test UCSD IP only Collection", visibility: "local"
    @obj = DamsObject.create titleValue: 'Simple Video Object with localDisplay license', typeOfResource: 'video', provenanceCollectionURI: @localCollection.pid, copyright_attributes: [{status: 'Public domain'}]
    @obj.licenseURI = @license.pid
    @obj.save!
    @obj.add_file( 'video content', '_1_1.mp4', 'test.mp4' )
    @obj.add_file( 'video content 2', '_2_1.mp4', 'test2.mp4' )
    @obj.add_file( 'video content 3', '_3_1.mp4', 'test3.mp4' )
    @obj.save!
    solr_index @license.pid
    solr_index @localCollection.pid
    solr_index @obj.pid
  end

  after(:all) do
    @localCollection.delete
    @license.delete
    @obj.delete
  end

  scenario 'curator user should see download link for localDisplay license object' do
    pending("Failed due to jwplayer 8.5.6 upgrade.  Will check again for future jwplayer upgrade.")
    Capybara.javascript_driver = :poltergeist
    Capybara.current_driver = Capybara.javascript_driver
    sign_in_developer
    visit dams_object_path @obj.pid
    expect(page).to have_link('', href:"/object/#{@obj.id}/_1_1.mp4/download?access=curator")
    click_button 'component-pager-forward'
    expect(page).to have_content('Generic Component Title 2')
    expect(page).to have_link('', href:"/object/#{@obj.id}/_2_1.mp4/download?access=curator")
  end

  scenario 'local user should not see download link for localDisplay license object' do
    sign_in_anonymous '132.239.0.3'
    visit dams_object_path @obj.pid
    expect(page).to_not have_link('', href:"/object/#{@obj.id}/_1_1.mp4/download")
    click_button 'component-pager-forward'
    expect(page).to have_content('Generic Component Title 2')
    expect(page).to_not have_link('', href:"/object/#{@obj.id}/_2_1.mp4/download?access=curator")
  end

  scenario 'user should see an embed link' do
    pending("Failed due to jwplayer 8.5.6 upgrade.  Will check again for future jwplayer upgrade.")
    Capybara.javascript_driver = :poltergeist
    Capybara.current_driver = Capybara.javascript_driver
    sign_in_developer
    visit dams_object_path @obj.pid
    expect(page).to have_css("a", :text => "Embed")
    click_button 'component-pager-forward'
    expect(page).to have_content('Generic Component Title 2')
    expect(page).to have_css("a", :text => "Embed")
  end

  scenario 'user should see embed video UI' do
    sign_in_developer
    visit embed_path @obj.pid, '2'
    expect(page).to have_selector(:css, 'video#dams-video')
    expect(page.body).to match(/20775-#{@obj.pid}-2-1.mp4/)
  end
end

describe "culturally sensitive restricted object view" do
  let (:restricted_note) { "Restricted View Content not available. Access may granted for research purposes at the discretion of the UC San Diego Library. For more information please contact the Digital Library Development Program at dlp@ucsd.edu" }
  before(:all) do
    @damsUnit = DamsUnit.create( pid: 'zz48484848', name: 'Test Unit', description: 'Test Description',
                                 code: 'tu', group: 'dams-curator', uri: 'http://example.com/' )

    @sensitiveObj = DamsObject.new(pid: "zz2765588d")
    @sensitiveObj.damsMetadata.content = File.new('spec/fixtures/culturalRestrictedObject.rdf.xml').read
    @sensitiveObj.save!
    solr_index (@sensitiveObj.pid)
  end
  after(:all) do
    @sensitiveObj.delete
    @damsUnit.delete
  end

  it "curator user should see the view content button" do
    sign_in_developer
    visit dams_object_path(@sensitiveObj.pid)
    expect(page).to have_selector('button#view-masked-object',:text=>'Yes, I would like to view this content.')
  end

  it "curator user should not see Restricted View banner and label" do
    sign_in_developer
    visit dams_object_path(@sensitiveObj.pid)
    expect(page).not_to have_selector('div.restricted-notice-complex', text: restricted_note)
    expect(page).not_to have_content('Restricted View')
  end

  it "public user should see Response Status Code 404 - not found page" do
    visit dams_object_path(@sensitiveObj.pid)
    expect(page.driver.response.status).to eq( 404 )
  end

  scenario 'local user should see Response Status Code 404 - not found page' do
    sign_in_anonymous '132.239.0.3'
    visit dams_object_path(@sensitiveObj.pid)
    expect(page.driver.response.status).to eq( 404 )
  end
end

describe "User wants to view cultural sensitive object for public collection" do
  before(:all) do
    ns = Rails.configuration.id_namespace
    @note = DamsNote.create value: "Culturally sensitive content: This is an image of a person or persons now deceased. In some Aboriginal Communities, hearing names or seeing images of deceased persons may cause sadness or distress, particularly to the relatives of these people."
    @license = DamsLicense.create permissionType: "display"
    @otherRight = DamsOtherRight.create basis: "cultural sensitivity" , permissionType: "display"
    @publicCollection = DamsProvenanceCollection.create titleValue: "Test Public Collection", visibility: "public"
    @sensitiveObj = DamsObject.create titleValue: 'Click-thru: Cultural Sensitivity for Public', provenanceCollectionURI: @publicCollection.pid, otherRightsURI: @otherRight.pid, licenseURI: @license.pid, note_attributes: [{ id: RDF::URI.new("#{ns}#{@note.pid}") }], copyright_attributes: [{status: 'Under copyright'}]
    solr_index @note.pid
    solr_index @sensitiveObj.pid
    solr_index @publicCollection.pid
    solr_index @otherRight.pid
    solr_index @license.pid
  end

  after(:all) do
    @note.delete
    @otherRight.delete
    @publicCollection.delete
    @sensitiveObj.delete
    @license.delete
  end

  it "curator user should see the view content button" do
    sign_in_developer
    visit dams_object_path(@sensitiveObj.pid)
    expect(page).to have_selector('button#view-masked-object',:text=>'Yes, I would like to view this content.')
  end

  it "public user should see the view content button" do
    visit dams_object_path(@sensitiveObj.pid)
    expect(page).to have_selector('button#view-masked-object',:text=>'Yes, I would like to view this content.')
  end

  scenario 'local user should see the view content button' do
    sign_in_anonymous '132.239.0.3'
    visit dams_object_path(@sensitiveObj.pid)
    expect(page).to have_selector('button#view-masked-object',:text=>'Yes, I would like to view this content.')
  end

  scenario 'curator user should not see the grey generic thumbnail' do
    sign_in_developer
    visit catalog_index_path({:q => @sensitiveObj.pid})
    expect(page).to_not have_css('img.dams-search-thumbnail[src="https://library.ucsd.edu/assets/dams/site/thumb-restricted.png"]')
  end

  scenario 'local user should see the grey generic thumbnail' do
    sign_in_anonymous '132.239.0.3'
    visit catalog_index_path({:q => @sensitiveObj.pid})
    expect(page).to have_css('img.dams-search-thumbnail[src="https://library.ucsd.edu/assets/dams/site/thumb-restricted.png"]')
  end

  scenario 'public user should see the grey generic thumbnail' do
    visit catalog_index_path({:q => @sensitiveObj.pid})
    expect(page).to have_css('img.dams-search-thumbnail[src="https://library.ucsd.edu/assets/dams/site/thumb-restricted.png"]')
  end
end
