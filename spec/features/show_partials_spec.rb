require 'spec_helper'


feature 'Visitor wants to view collection links' do
  pending "Working object metadata creation" do
  before (:all) do
    @test_pid1 = 'bd6212468x'
    @test_pid2 = 'xx25252525'
    @test_pid3 = 'xx03030303'
    @test_pid4 = 'xx48133407'

    @damsColl3 = DamsProvenanceCollection.new(pid: @test_pid2)
    @damsColl3.damsMetadata.content = File.new('spec/fixtures/damsProvenanceCollectionPart.rdf.xml').read
    @damsColl3.save!
    solr_index @test_pid2

    @damsColl1 = DamsProvenanceCollection.new(pid: @test_pid4)
    @damsColl1.damsMetadata.content = File.new('spec/fixtures/damsProvenanceCollection4Curator.rdf.xml').read
    @damsColl1.save!
    solr_index @test_pid4
    
    @damsColl2 = DamsAssembledCollection.new(pid: @test_pid3)
    @damsColl2.damsMetadata.content = File.new('spec/fixtures/damsAssembledCollection4Access.rdf.xml').read
    @damsColl2.save!
    solr_index @test_pid3

    @copy = DamsCopyright.create pid: 'xx15151515', status: 'Public domain'
    
    @damsObj = DamsObject.new(pid: @test_pid1)
    @damsObj.damsMetadata.content = File.new('spec/fixtures/damsObject2.rdf.xml').read
    @damsObj.copyrightURI = @copy.pid
    @damsObj.save!
    solr_index @test_pid1
  end
  after (:all) do
    @damsColl1.delete
    @damsColl2.delete
    @damsColl3.delete
    @damsObj.delete
    @copy.delete
  end

  scenario 'A anonymous user should not see a curator collection link' do
    visit dams_object_path(@test_pid3)
save_and_open_page
    expect(page).not_to have_link('DAMS Curator Collection',   href: dams_collection_path(@test_pid4))
    expect(page).to have_link('Sample Provenance Collection',  href: dams_collection_path(@test_pid4))
  end
  
  scenario 'A curator should see any collection links, including curator collections' do
    sign_in_developer
    visit dams_object_path(@test_pid3)
    expect(page).to have_link('DAMS Curator Collection',       href: dams_collection_path(@test_pid4))
    expect(page).to have_link('Sample Provenance Collection',  href: dams_collection_path(@test_pid4))
  end

  scenario 'Metadata on Solr view page' do
    visit dams_object_path(@test_pid1)

    # Title, subtitle, part name and part number
    expect(page).to have_content('Sample Simple Object')
    expect(page).to have_content('An Image Object')
    expect(page).to have_content('Allegro 1')

    # collections and unit
    expect(page).to have_link('Sample Assembled Collection',  href: dams_collection_path(@test_pid3))
    expect(page).to have_link('Sample Provenance Collection', href: dams_collection_path(@test_pid4))
    expect(page).to have_link('Sample Provenance Part',       href: dams_collection_path(@test_pid2))
    expect(page).to have_text('Library Digital Collections')
    
    # relationship 
    expect(page).to have_content('Donor')
    expect(page).to have_content('Wagner, Rick, 1972-')

    # date and language
    expect(page).to have_selector('li', :text=>"Easter 2012")
    expect(page).to have_selector('li', :text=>"English")

    # image
    expect(page).to have_link('image', href:"/search?f%5Bcollection_sim%5D%5B%5D=Sample+Provenance+Part&f%5Bobject_type_sim%5D%5B%5D=image")

    # conference name
    expect(page).to have_link('mads:ConferenceName value', href:"/search?f%5Bsubject_topic_sim%5D%5B%5D=mads%3AConferenceName+value&id="+@test_pid1)

    # corporate name
    expect(page).to have_selector('li', :text=>"mads:CorporateName value")

    # family name
    expect(page).to have_link('mads:FamilyName value', href:"/search?f%5Bsubject_topic_sim%5D%5B%5D=mads%3AFamilyName+value&id="+@test_pid1)

    # personal name
    expect(page).to have_selector('li', :text=>"Smith, John, Dr., 1965-")

    # preferred citation note
    expect(page).to have_selector('p', :text=>"PreferredCitationNote value")

    # scope content note
    expect(page).to have_selector('p', :text=>"ScopeContentNote value")

    # custodial responsibility note
    expect(page).to have_selector('p', :text=>"CustodialResponsibilityNote value")

    # related resource
    expect(page).to have_selector('strong', :text=>"Exhibit")
    expect(page).to have_link('Related Resource value', href:"http://relatedresource.com/")

    # copyright
    expect(page).to have_selector('strong', :text=>"Under copyright")
    expect(page).to have_selector('p', :text=>"This work is available from the UC San Diego Libraries. This digital copy of the work is intended to support research, teaching, and private study.")
    expect(page).to have_selector('p', :text=>"This work is protected by the U.S. Copyright Law (Title 17, U.S.C.). Use of this work beyond that allowed by \"fair use\" requires written permission of the copyright holder(s). Responsibility for obtaining permissions and any use and distribution of this work rests exclusively with the user and not the UC San Diego Libraries.")
  end

  scenario 'Simple Subjects, is on Solr view page' do
    visit dams_object_path(@test_pid1)

    # BuiltWorkPlace
    expect(page).to have_link('dams:BuiltWorkPlace value', href:"/search?f%5Bsubject_topic_sim%5D%5B%5D=dams%3ABuiltWorkPlace+value&id="+@test_pid1)

    # Cultural Context
    expect(page).to have_link('dams:CulturalContext value', href:"/search?f%5Bsubject_topic_sim%5D%5B%5D=dams%3ACulturalContext+value&id="+@test_pid1)

    # Function
    expect(page).to have_link('dams:Function value', href:"/search?f%5Bsubject_topic_sim%5D%5B%5D=dams%3AFunction+value&id="+@test_pid1)

    # Genre Form
    expect(page).to have_selector('li', :text=>"mads:GenreForm value")

    # Geographic
    expect(page).to have_link('mads:Geographic value', href:"/search?f%5Bsubject_topic_sim%5D%5B%5D=mads%3AGeographic+value&id="+@test_pid1)

    # Iconography
    expect(page).to have_link('dams:Iconography value', href:"/search?f%5Bsubject_topic_sim%5D%5B%5D=dams%3AIconography+value&id="+@test_pid1)

    # Occupation
    expect(page).to have_link('mads:Occupation value', href:"/search?f%5Bsubject_topic_sim%5D%5B%5D=mads%3AOccupation+value&id="+@test_pid1)

    # Scientific Name
    expect(page).to have_link('dams:ScientificName value', href:"/search?f%5Bsubject_topic_sim%5D%5B%5D=dams%3AScientificName+value&id="+@test_pid1)

    # Style Period
    expect(page).to have_link('dams:StylePeriod value', href:"/search?f%5Bsubject_topic_sim%5D%5B%5D=dams%3AStylePeriod+value&id="+@test_pid1)

    # Technique
    expect(page).to have_link('dams:Technique value', href:"/search?f%5Bsubject_topic_sim%5D%5B%5D=dams%3ATechnique+value&id="+@test_pid1)

    # Temporal
    expect(page).to have_link('mads:Temporal value', href:"/search?f%5Bsubject_topic_sim%5D%5B%5D=mads%3ATemporal+value&id="+@test_pid1)

    # Topic
    expect(page).to have_link('mads:Topic value', href:"/search?f%5Bsubject_topic_sim%5D%5B%5D=mads%3ATopic+value&id="+@test_pid1)
  end

  scenario 'Title, is on Solr view page' do
    visit dams_object_path(@test_pid1)
    expect(page).to have_selector('h1', :text=>"Sample Simple Object")
    expect(page).to have_selector('h2', :text=>"An Image Object")
  end

  end
end
