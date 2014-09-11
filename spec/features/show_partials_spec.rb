require 'spec_helper'

test_pid = 'bd22194583'

feature 'Visitor wants to view object fields' do
  scenario 'Metadata on Solr view page' do
    visit dams_object_path(test_pid)

    # collections and unit
    expect(page).to have_link('Sample Assembled Collection',  href: dams_collection_path('bd3516400n'))
    expect(page).to have_link('Sample Provenance Collection', href: dams_collection_path('bd48133407'))
    expect(page).to have_link('Sample Provenance Part',       href: dams_collection_path('bd6110278b'))
    expect(page).to have_text('Library Digital Collections')
    
    # relationship - need to add relationship field into sample record bd22194583
    #expect(page).to have_link('Sample Creator', href:"/search?f%5Bcreator_sim%5D%5B%5D=Sample+Creator&id="+test_pid)

    # date and language
    expect(page).to have_selector('li', :text=>"Easter 2012")
    expect(page).to have_selector('li', :text=>"English")

    # image
    expect(page).to have_link('image', href:'/search?id='+test_pid+'&f%5Bobject_type_sim%5D%5B%5D=image')

    # conference name
    expect(page).to have_link('mads:ConferenceName value', href:'/search?id='+test_pid+'&f%5Bsubject_topic_sim%5D%5B%5D=mads%3AConferenceName+value')

    # corporate name
    expect(page).to have_selector('li', :text=>"mads:CorporateName value")

    # family name
    expect(page).to have_link('mads:FamilyName value', href:'/search?id='+test_pid+'&f%5Bsubject_topic_sim%5D%5B%5D=mads%3AFamilyName+value')

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
    expect(page).to have_selector('small', :text=>"This work is protected by the U.S. Copyright Law (Title 17, U.S.C.). Use of this work beyond that allowed by \"fair use\" requires written permission of the copyright holder(s). Responsibility for obtaining permissions and any use and distribution of this work rests exclusively with the user and not the UC San Diego Libraries.")
  end

  scenario 'Curator-Only Rights Information, is on Solr view page' do
    sign_in_developer
    visit dams_object_path(test_pid)

    # license
    #expect(page).to have_link('License note text here...', href:"http://library.ucsd.edu/licenses/lic12341.pdf")

    # other rights
    #expect(page).to have_link('Other rights note value', href:"http://bar.com")

    # rights holder
    # expect(page).to have_selector('li', :text=>"Smithee, Alan, 1968-")

    # statute
    #expect(page).to have_selector('strong', :text=>"Statute Citation value")
    #expect(page).to have_selector('p', :text=>"Statute Note")
  end

  scenario 'Simple Subjects, is on Solr view page' do
    visit dams_object_path(test_pid)

    # BuiltWorkPlace
    expect(page).to have_link('dams:BuiltWorkPlace value', href:'/search?id='+test_pid+'&f%5Bsubject_topic_sim%5D%5B%5D=dams%3ABuiltWorkPlace+value')

    # Cultural Context
    expect(page).to have_link('dams:CulturalContext value', href:'/search?id='+test_pid+'&f%5Bsubject_topic_sim%5D%5B%5D=dams%3ACulturalContext+value')

    # Function
    expect(page).to have_link('dams:Function value', href:'/search?id='+test_pid+'&f%5Bsubject_topic_sim%5D%5B%5D=dams%3AFunction+value')

    # Genre Form
    expect(page).to have_selector('li', :text=>"mads:GenreForm value")

    # Geographic
     expect(page).to have_link('mads:Geographic value', href:'/search?id='+test_pid+'&f%5Bsubject_topic_sim%5D%5B%5D=mads%3AGeographic+value')

    # Iconography
    expect(page).to have_link('dams:Iconography value', href:'/search?id='+test_pid+'&f%5Bsubject_topic_sim%5D%5B%5D=dams%3AIconography+value')

    # Occupation
    expect(page).to have_link('mads:Occupation value', href:'/search?id='+test_pid+'&f%5Bsubject_topic_sim%5D%5B%5D=mads%3AOccupation+value')

    # Scientific Name
    expect(page).to have_link('dams:ScientificName value', href:'/search?id='+test_pid+'&f%5Bsubject_topic_sim%5D%5B%5D=dams%3AScientificName+value')

    # Style Period
    expect(page).to have_link('dams:StylePeriod value', href:'/search?id='+test_pid+'&f%5Bsubject_topic_sim%5D%5B%5D=dams%3AStylePeriod+value')

    # Technique
    expect(page).to have_link('dams:Technique value', href:'/search?id='+test_pid+'&f%5Bsubject_topic_sim%5D%5B%5D=dams%3ATechnique+value')

    # Temporal
    expect(page).to have_link('mads:Temporal value', href:'/search?id='+test_pid+'&f%5Bsubject_topic_sim%5D%5B%5D=mads%3ATemporal+value')

    # Topic
    expect(page).to have_link('mads:Topic value', href:'/search?id='+test_pid+'&f%5Bsubject_topic_sim%5D%5B%5D=mads%3ATopic+value')
  end

  scenario 'Title, is on Solr view page' do
    visit dams_object_path(test_pid)
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
