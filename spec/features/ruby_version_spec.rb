require 'spec_helper'

feature "ruby version" do
  scenario "objects should have meta tags" do
    skip("Waiting on circleci image to support current ruby")
    ver = File.read(File.join(File.dirname(__FILE__), '..', '..', '.ruby-version')).chomp
    visit ruby_version_path
    expect(page).to have_text "ruby version = #{ver}"
  end
end
