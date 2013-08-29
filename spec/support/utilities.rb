#include Helper specs here
#eg. include DamsUnitsHelper

#define methods to reuse across various tests, they are included by default in RSPEC

# sign in as a developer
def sign_in_developer
  visit new_user_session_path
  fill_in "name", :with => "name"
  fill_in "email", :with => "email@email.com"
  click_on "Sign In"
end

#remove need for redundant tests for flash messages, using "have_TYPE_message"
#￼replace this: should have_selector('div.alert.alert-error', text: 'Invalid
# with this: should have_error_message('Invalid')
RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-error', text: message)
  end
end

RSpec::Matchers.define :have_success_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-success', text: message)
  end
end

RSpec::Matchers.define :have_notice_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-notice', text: message)
  end
end
