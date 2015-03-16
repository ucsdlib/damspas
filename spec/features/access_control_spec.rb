require 'spec_helper'

feature 'Access control' do
  before(:all) do
    @unit = DamsUnit.create name: "Test Unit", description: "Test Description", code: "tu", uri: "http://example.com/"
    @copyPublic = DamsCopyright.create status: "Public domain"
    @copyCurator = DamsCopyright.create status: "Under copyright"
    @otherLocal = DamsOtherRight.create permissionType: "localDisplay"

    @publicObj = DamsObject.create titleValue: "Public Object", unitURI: @unit.pid, copyrightURI: @copyPublic.pid
    @curatorObj = DamsObject.create titleValue: "Curator Object", unitURI: @unit.pid, copyrightURI: @copyCurator.pid
    @localObj = DamsObject.create titleValue: "Local Object", unitURI: @unit.pid, copyrightURI: @copyCurator.pid, otherRightsURI: @otherLocal.pid

    solr_index @publicObj.pid
    solr_index @curatorObj.pid
    solr_index @localObj.pid
  end
  after(:all) do
    @publicObj.delete
    @curatorObj.delete
    @localObj.delete
    @unit.delete
    @copyPublic.delete
    @copyCurator.delete
    @otherLocal.delete
  end

  # anonymous
  scenario 'anonymous user searching' do
    visit catalog_index_path( {:q => 'object'} )
    expect(page).to have_selector('h3', 'Public Object')
    expect(page).to have_no_content('Curator Object')
    expect(page).to have_no_content('Local Object')
  end
  scenario 'anonymous user viewing public object' do
    visit dams_object_path @publicObj.pid
    response = page.driver.response
    expect(response.status).to eq( 200 )
  end
  scenario 'anonymous user viewing restricted object' do
    visit dams_object_path @curatorObj.pid
    expect(page).to have_selector('h1','You are not allowed to view this page.')
    expect(page).to have_no_content('Curator Object')
  end
  scenario 'anonymous user viewing local object' do
    visit dams_object_path @localObj.pid
    expect(page).to have_selector('h1','You are not allowed to view this page.')
    expect(page).to have_no_content('Local Object')
  end

  # local
  scenario 'local user searching' do
    sign_in_anonymous '132.239.0.3'
    visit catalog_index_path( {:q => 'object'} )
    expect(page).to have_selector('h3', 'Public Object')
    expect(page).to have_selector('h3', 'Local Object')
    expect(page).to have_no_content('Curator Object')
  end
  scenario 'local user viewing public object' do
    sign_in_anonymous '132.239.0.3'
    visit dams_object_path @publicObj.pid
    response = page.driver.response
    expect(response.status).to eq( 200 )
  end
  scenario 'local user viewing local object' do
    sign_in_anonymous '132.239.0.3'
    visit dams_object_path @localObj.pid
    response = page.driver.response
    expect(response.status).to eq( 200 )
  end
  scenario 'local user viewing restricted object' do
    sign_in_anonymous '132.239.0.3'
    visit dams_object_path @curatorObj.pid
    expect(page).to have_selector('h1','You are not allowed to view this page.')
    expect(page).to have_no_content('Curator Object')
  end

  # curator
  scenario 'curator user searching' do
    sign_in_developer
    visit catalog_index_path( {:q => 'object'} )
    expect(page).to have_selector('h3', 'Public Object')
    expect(page).to have_selector('h3', 'Curator Object')
    expect(page).to have_selector('h3', 'Local Object')
  end
  scenario 'curator user viewing public object' do
    sign_in_developer
    visit dams_object_path @publicObj.pid
    response = page.driver.response
    expect(response.status).to eq( 200 )
  end
  scenario 'curator user viewing local object' do
    sign_in_developer
    visit dams_object_path @localObj.pid
    response = page.driver.response
    expect(response.status).to eq( 200 )
  end
  scenario 'curator user viewing restricted object' do
    sign_in_developer
    visit dams_object_path @curatorObj.pid
    response = page.driver.response
    expect(response.status).to eq( 200 )
  end

  # audit log
  scenario 'anonymous user not allowed to view the audit log' do
    visit audits_path
    response = page.driver.response
    expect(response.status).to eq( 403 )
    expect(page).to have_selector('h1','You are not allowed to view this page.')
    expect(page).to have_no_content('Audit Log')
  end
  scenario 'curator allowed to view the audit log' do
    sign_in_developer
    visit audits_path
    response = page.driver.response
    expect(response.status).to eq( 200 )
    expect(page).to have_selector('h1', 'Audit Log')
  end

end
