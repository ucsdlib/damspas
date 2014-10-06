require 'spec_helper'

# Class to store the path of the genre form
class Path
	class << self
		attr_accessor :path
	end
	# Variable to be used to store MADS GenreForm path
	# Used for editing specified genre form
	@path = nil
end

def sign_in_developer
  visit new_user_session_path
  fill_in "name", :with => "name"
  fill_in "email", :with => "email@email.com"
  click_on "Sign In"
end
