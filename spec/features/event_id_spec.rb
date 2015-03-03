require 'spec_helper'

feature "Discover objects by Event ID note value" do
  before do
    @copy = DamsCopyright.create status: "Public domain"
    note = [{ type: 'identifier', displayLabel: 'event id', value: '19851203_01' }]
    @obj = DamsObject.create titleValue: 'Test Event Object', copyrightURI: @copy.pid, note_attributes: note
    solr_index @obj.pid
  end
  after do
    @obj.delete
    @copy.delete
  end
  scenario "An object with an Event ID note should link to canned search" do
    visit dams_object_path @obj.pid
    expect(page).to have_text('Event ID: 19851203_01')
    expect(page).to have_link('19851203_01', href: catalog_index_path({'f[event_ssi][]' => '19851203_01'}) )
  end
  scenario "Canned search should retrieve object with Event ID" do
    visit catalog_index_path({'f[event_ssi][]' => '19851203_01'})
    link = page.find_link('Test Event Object')
    expect(link['href']).to include( dams_object_path(@obj.pid) )
  end
end
