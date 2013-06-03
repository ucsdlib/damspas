require 'spec_helper'
require 'rack/test'

feature 'Visitor want to look at objects' do

  scenario 'view a sample object record' do
    visit dams_object_path('bb55555555')
    expect(page).to have_selector('h1',:text=>'Sample Complex Object Record #3')
  end

  scenario 'view a sample data file' do
    visit file_path('bb55555555','_5_5.jpg')
    response = page.driver.response
    expect(response.status).to eq( 200 )
    expect(response.header["Content-Type"]).to eq( "image/jpeg" )
  end

  scenario 'view a non-existent record' do
    expect { visit dams_object_path('xxx') }.to raise_error(
      ActionController::RoutingError)
  end

  scenario 'view a file from a non-existing object' do
    expect { visit file_path('xxx','xxx') }.to raise_error(
      ActionController::RoutingError)
  end

  scenario 'view a non-existing file from an existing object' do
    expect { visit file_path('bb55555555','xxx') }.to raise_error(
      ActionController::RoutingError)
  end

end
