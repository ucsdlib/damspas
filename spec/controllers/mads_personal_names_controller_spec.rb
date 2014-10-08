require 'spec_helper'

describe MadsPersonalNamesController do
  describe "A login user" do
	  before do
	  	sign_in User.create! ({:provider => 'developer'})
    	#MadsPersonalNameCollection.find_each{|z| z.delete}
	  end
  end
end

