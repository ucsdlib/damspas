require 'spec_helper'

feature "Discover objects by Event ID note value" do
  scenario "An object with an Event ID note should link to canned search" do
    visit dams_object_path('bd22194583')
    expect(page).to have_text('Event ID: 19851203_01')
    expect(page).to have_link('19851203_01', href: catalog_index_path({'f[event_ssi][]' => '19851203_01'}) )
  end
  scenario "Canned search should retrieve object with Event ID" do
    visit catalog_index_path({'f[event_ssi][]' => '19851203_01'})
    link = page.find_link('Sample Simple Object: An Image Object')
    expect(link['href']).to include( dams_object_path('bd22194583') )
  end
end
