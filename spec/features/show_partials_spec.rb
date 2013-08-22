require 'spec_helper'

feature 'Visitor wants to view an object\'s' do 
	scenario 'Note, is on Solr view page' do
		
    visit dams_object_path('bd22194583')
		expect(page).to have_selector('strong', :text=>"ARK ID")
		expect(page).to have_link('http://library.ucsd.edu/ark:/20775/bd22194583', href: "http://library.ucsd.edu/ark:/20775/bd22194583")
	end

	scenario 'Preferred Citation Note, is on Solr view page' do
    visit dams_object_path('bd22194583')
		
		expect(page).to have_selector('p', :text=>"PreferredCitationNote value")
	end

	scenario 'Scope Content Note, is on Solr view page' do
    visit dams_object_path('bd22194583')
		
		expect(page).to have_selector('p', :text=>"ScopeContentNote value")
	end

	scenario 'Custodial Responsibility Note, is on Solr view page' do
    visit dams_object_path('bd22194583')
		
		expect(page).to have_selector('p', :text=>"CustodialResponsibilityNote value")
	end

	scenario 'BuiltWorkPlace, is on Solr view page' do
    visit dams_object_path('bd22194583')
    expect(page).to have_link('dams:BuiltWorkPlace value', href:"/search?f%5Bsubject_builtWorkPlace_sim%5D%5B%5D=dams%3ABuiltWorkPlace+value&id=bd22194583")
	end

	scenario 'Collections, is on Solr view page' do
	  visit dams_object_path('bd22194583')
	  expect(page).to have_link('Sample Assembled Collection', href:"/dams_collections/bd3516400n")
	  expect(page).to have_link('Sample Provenance Collection', href:"/dams_collections/bd48133407")
	  expect(page).to have_link('Sample Provenance Part', href:"/dams_collections/bd6110278b")
	end

	scenario 'Conference Name, is on Solr view page' do
	  visit dams_object_path('bd22194583')
	  expect(page).to have_link('mads:ConferenceName value', href:"/search?f%5Bsubject_conferenceName_sim%5D%5B%5D=mads%3AConferenceName+value&id=bd22194583")
	end

	scenario 'Copyright, is on Solr view page' do
		visit dams_object_path('bd22194583')
		expect(page).to have_selector('strong', :text=>"Under copyright")
		expect(page).to have_selector('p', :text=>"This work is available from the UC San Diego Libraries. This digital copy of the work is intended to support research, teaching, and private study.")
		expect(page).to have_selector('small', :text=>"This work is protected by the U.S. Copyright Law (Title 17, U.S.C.). Use of this work beyond that allowed by \"fair use\" requires written permission of the copyright holder(s). Responsibility for obtaining permissions and any use and distribution of this work rests exclusively with the user and not the UC San Diego Libraries.")
	end

	scenario 'Corporate Name, is on Solr view page' do
		visit dams_object_path('bd22194583')
		expect(page).to have_selector('li', :text=>"mads:CorporateName value")
	end

	scenario 'Cultural Context, is on Solr view page' do
		visit dams_object_path('bd22194583')
		expect(page).to have_link('dams:CulturalContext value', href:"/search?f%5Bsubject_culturalContext_sim%5D%5B%5D=dams%3ACulturalContext+value&id=bd22194583")
	end

	scenario 'Date, is on Solr view page' do
		visit dams_object_path('bd22194583')
		expect(page).to have_selector('li', :text=>"Easter 2012")
		expect(page).to have_selector('li', :text=>"2012-04-08")
	end

	scenario 'Family Name, is on Solr view page' do
		visit dams_object_path('bd22194583')
		expect(page).to have_link('mads:FamilyName value', href:"/search?f%5Bsubject_familyName_sim%5D%5B%5D=mads%3AFamilyName+value&id=bd22194583")
	end

	scenario 'File Format, is on Solr view page' do
		visit dams_object_path('bd22194583')
		expect(page).to have_link('Still Image', href:"/search?f%5Bobject_type_sim%5D%5B%5D%5B%5D=still+image&id=bd22194583")
	end

	scenario 'Function, is on Solr view page' do
		visit dams_object_path('bd22194583')
		expect(page).to have_link('dams:Function value', href:"/search?f%5Bsubject_function_sim%5D%5B%5D=dams%3AFunction+value&id=bd22194583")
	end

	scenario 'Genre Form, is on Solr view page' do
		visit dams_object_path('bd22194583')
		expect(page).to have_selector('li', :text=>"mads:GenreForm value")
	end

	scenario 'Geographic, is on Solr view page' do
		visit dams_object_path('bd22194583')
		expect(page).to have_link('mads:Geographic value', href:"/search?f%5Bsubject_geographic_sim%5D%5B%5D=mads%3AGeographic+value&id=bd22194583")
	end

	scenario 'Iconography, is on Solr view page' do
		visit dams_object_path('bd22194583')
		expect(page).to have_link('dams:Iconography value', href:"/search?f%5Bsubject_iconography_sim%5D%5B%5D=dams%3AIconography+value&id=bd22194583")
	end

	scenario 'Language, is on Solr view page' do
		visit dams_object_path('bd22194583')
		expect(page).to have_selector('li', :text=>"English")
	end

	scenario 'License, is on Solr view page' do
		visit dams_object_path('bd22194583')
		expect(page).to have_link('License note text here...', href:"http://library.ucsd.edu/licenses/lic12341.pdf")
	end

	scenario 'Occupation, is on Solr view page' do
		visit dams_object_path('bd22194583')
		expect(page).to have_link('mads:Occupation value', href:"/search?f%5Bsubject_occupation_sim%5D%5B%5D=mads%3AOccupation+value&id=bd22194583")
	end

	scenario 'Other Rights, is on Solr view page' do
		visit dams_object_path('bd22194583')
		expect(page).to have_link('Other rights basis value', href:"http://bar.com")
	end

	scenario 'Personal Name, is on Solr view page' do
		visit dams_object_path('bd22194583')
		expect(page).to have_selector('li', :text=>"Smith, John, Dr., 1965-")
	end

	scenario 'Related Resource, is on Solr view page' do
		visit dams_object_path('bd22194583')
		expect(page).to have_selector('strong', :text=>"EXHIBIT")
		expect(page).to have_link('Related Resource value', href:"http://relatedresource.com/")
	end

	scenario 'Rights Holder, is on Solr view page' do
		visit dams_object_path('bd22194583')
		expect(page).to have_selector('li', :text=>"Smithee, Alan, 1968-")
	end

	scenario 'Scientific Name, is on Solr view page' do
		visit dams_object_path('bd22194583')
		expect(page).to have_link('dams:ScientificName value', href:"/search?f%5Bsubject_scientificName_sim%5D%5B%5D=dams%3AScientificName+value&id=bd22194583")
	end

	scenario 'Statute, is on Solr view page' do
		visit dams_object_path('bd22194583')
		expect(page).to have_selector('strong', :text=>"Statute Citation value")
		expect(page).to have_selector('p', :text=>"Statute Note")
	end

	scenario 'Style Period, is on Solr view page' do
		visit dams_object_path('bd22194583')
		expect(page).to have_link('dams:StylePeriod value', href:"/search?f%5Bsubject_stylePeriod_sim%5D%5B%5D=dams%3AStylePeriod+value&id=bd22194583")
	end

	scenario 'Technique, is on Solr view page' do
		visit dams_object_path('bd22194583')
		expect(page).to have_link('mads:Technique value', href:"/search?f%5Bsubject_technique_sim%5D%5B%5D=mads%3ATechnique+value&id=bd22194583")
	end

	scenario 'Temporal, is on Solr view page' do
		visit dams_object_path('bd22194583')
		expect(page).to have_link('mads:Temporal value', href:"/search?f%5Bsubject_temporal_sim%5D%5B%5D=mads%3ATemporal+value&id=bd22194583")
	end

	scenario 'Title, is on Solr view page' do
		visit dams_object_path('bd22194583')
		expect(page).to have_selector('h1', :text=>"Sample Simple Object")
		expect(page).to have_selector('h2', :text=>"An Image Object")
	end

	scenario 'Topic, is on Solr view page' do
		visit dams_object_path('bd22194583')
		expect(page).to have_link('mads:Topic value', href:"/search?f%5Bsubject_topic_sim%5D%5B%5D=mads%3ATopic+value&id=bd22194583")
	end

	scenario 'Unit, is on Solr view page' do
		visit dams_object_path('bd22194583')
		expect(page).to have_link('Library Digital Collections', href:"/dams_units/dlp")
	end
	
end