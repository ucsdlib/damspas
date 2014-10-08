require 'spec_helper'

# Class to store the path of the assembled collection
class Path
	class << self
		attr_accessor :path
	end
	# Variable to be used to store dams assembled collection path
	# Used for editing specified collection
	@path = nil
end

def sign_in_developer
	visit new_user_session_path
	fill_in "name", :with => "name"
	fill_in "email", :with => "email@email.com"
	click_on "Sign In"
end
