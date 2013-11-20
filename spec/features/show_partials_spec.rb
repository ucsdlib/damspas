require 'spec_helper'

feature 'Visitor wants to view object fields' do
  scenario 'Metadata on Solr view page' do
    visit dams_object_path('bd22194583')

    # collections and unit
    expect(page).to have_link('Sample Assembled Collection', href:"/dams_collections/bd3516400n")
    expect(page).to have_link('Sample Provenance Collection', href:"/dams_collections/bd48133407")
    expect(page).to have_link('Sample Provenance Part', href:"/dams_collections/bd6110278b")
    expect(page).to have_link('Library Digital Collections', href:"/dams_units/dlp")

    # date and language
    expect(page).to have_selector('li', :text=>"Easter 2012")
    expect(page).to have_selector('li', :text=>"English")

    # image
    expect(page).to have_link('Image', href:"/search?f%5Bobject_type_sim%5D%5B%5D%5B%5D=image&id=bd22194583")

    # conference name
    expect(page).to have_link('mads:ConferenceName value', href:"/search?f%5Bsubject_conferenceName_sim%5D%5B%5D=mads%3AConferenceName+value&id=bd22194583")

    # corporate name
    expect(page).to have_selector('li', :text=>"mads:CorporateName value")

    # family name
    expect(page).to have_link('mads:FamilyName value', href:"/search?f%5Bsubject_familyName_sim%5D%5B%5D=mads%3AFamilyName+value&id=bd22194583")

    # personal name
    expect(page).to have_selector('li', :text=>"Smith, John, Dr., 1965-")

    # identifier note
    expect(page).to have_selector('dt', :text=>"Identifier")
    expect(page).to have_link('http://library.ucsd.edu/ark:/20775/bd22194583', href: "http://library.ucsd.edu/ark:/20775/bd22194583")

    # preferred citation note
    expect(page).to have_selector('p', :text=>"PreferredCitationNote value")

    # scope content note
    expect(page).to have_selector('p', :text=>"ScopeContentNote value")

    # custodial responsibility note
    expect(page).to have_selector('p', :text=>"CustodialResponsibilityNote value")

    # related resource
    expect(page).to have_selector('strong', :text=>"EXHIBIT")
    expect(page).to have_link('Related Resource value', href:"http://relatedresource.com/")

    # copyright
    expect(page).to have_selector('strong', :text=>"Under copyright")
    expect(page).to have_selector('p', :text=>"This work is available from the UC San Diego Libraries. This digital copy of the work is intended to support research, teaching, and private study.")
    expect(page).to have_selector('small', :text=>"This work is protected by the U.S. Copyright Law (Title 17, U.S.C.). Use of this work beyond that allowed by \"fair use\" requires written permission of the copyright holder(s). Responsibility for obtaining permissions and any use and distribution of this work rests exclusively with the user and not the UC San Diego Libraries.")
  end

  scenario 'Curator-Only Rights Information, is on Solr view page' do
    sign_in_developer
    visit dams_object_path('bd22194583')

    # license
    #expect(page).to have_link('License note text here...', href:"http://library.ucsd.edu/licenses/lic12341.pdf")

    # other rights
    #expect(page).to have_link('Other rights note value', href:"http://bar.com")

    # rights holder
    expect(page).to have_selector('li', :text=>"Smithee, Alan, 1968-")

    # statute
    expect(page).to have_selector('strong', :text=>"Statute Citation value")
    expect(page).to have_selector('p', :text=>"Statute Note")
  end

  scenario 'Simple Subjects, is on Solr view page' do
    visit dams_object_path('bd22194583')

    # BuiltWorkPlace
    expect(page).to have_link('dams:BuiltWorkPlace value', href:"/search?f%5Bsubject_builtWorkPlace_sim%5D%5B%5D=dams%3ABuiltWorkPlace+value&id=bd22194583")

    # Cultural Context
    expect(page).to have_link('dams:CulturalContext value', href:"/search?f%5Bsubject_culturalContext_sim%5D%5B%5D=dams%3ACulturalContext+value&id=bd22194583")

    # Function
    expect(page).to have_link('dams:Function value', href:"/search?f%5Bsubject_function_sim%5D%5B%5D=dams%3AFunction+value&id=bd22194583")

    # Genre Form
    expect(page).to have_selector('li', :text=>"mads:GenreForm value")

    # Geographic
    expect(page).to have_link('mads:Geographic value', href:"/search?f%5Bsubject_geographic_sim%5D%5B%5D=mads%3AGeographic+value&id=bd22194583")

    # Iconography
    expect(page).to have_link('dams:Iconography value', href:"/search?f%5Bsubject_iconography_sim%5D%5B%5D=dams%3AIconography+value&id=bd22194583")

    # Occupation
    expect(page).to have_link('mads:Occupation value', href:"/search?f%5Bsubject_occupation_sim%5D%5B%5D=mads%3AOccupation+value&id=bd22194583")

    # Scientific Name
    expect(page).to have_link('dams:ScientificName value', href:"/search?f%5Bsubject_scientificName_sim%5D%5B%5D=dams%3AScientificName+value&id=bd22194583")

    # Style Period
    expect(page).to have_link('dams:StylePeriod value', href:"/search?f%5Bsubject_stylePeriod_sim%5D%5B%5D=dams%3AStylePeriod+value&id=bd22194583")

    # Technique
    expect(page).to have_link('mads:Technique value', href:"/search?f%5Bsubject_technique_sim%5D%5B%5D=mads%3ATechnique+value&id=bd22194583")

    # Temporal
    expect(page).to have_link('mads:Temporal value', href:"/search?f%5Bsubject_temporal_sim%5D%5B%5D=mads%3ATemporal+value&id=bd22194583")

    # Topic
    expect(page).to have_link('mads:Topic value', href:"/search?f%5Bsubject_topic_sim%5D%5B%5D=mads%3ATopic+value&id=bd22194583")
  end

  scenario 'Title, is on Solr view page' do
    visit dams_object_path('bd22194583')
    expect(page).to have_selector('h1', :text=>"Sample Simple Object")
    expect(page).to have_selector('h2', :text=>"An Image Object")
  end

end

def sign_in_developer
  visit new_user_session_path
  fill_in "name", :with => "name"
  fill_in "email", :with => "email@email.com"
  click_on "Sign In"
end
