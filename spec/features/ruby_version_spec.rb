require 'spec_helper'

feature "ruby version" do
  scenario "objects should have meta tags" do
    ver = File.read(File.join(File.dirname(__FILE__), '..', '..', '.ruby-version')).chomp
    visit ruby_version_path
    page.should have_text "ruby version = #{ver}"
  end
end
