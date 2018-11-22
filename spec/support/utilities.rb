# include Helper specs here
# eg. include DamsUnitsHelper
include Warden::Test::Helpers

# define methods to reuse across various tests, they are included by default in RSPEC

# sign in as a developer
def sign_in_developer
  visit new_user_session_path
  fill_in "name", :with => "name"
  fill_in "email", :with => "email@email.com"
  click_on "Sign In"
end

def sign_in_anonymous(ip)
  login_as(User.anonymous(ip), scope: :user)
end

# sign in as a curator only
def sign_in_curator
    user_attributes = { email: 'test@example.com' }
    user = User.new(user_attributes) { |u| u.save(validate: false) }
    user.groups = ['dams-curator']
    login_as user
end

def create_auth_link_user
  user_attributes = {
    email: 'test@example.com',
    provider: 'auth_link',
    uid: SecureRandom.uuid
  }
  user = User.new(user_attributes)
  user.ensure_authentication_token
  user.save
  user
end


# remove need for redundant tests for flash messages, using "have_TYPE_message"
# replace this: should have_selector('div.alert.alert-error', text: 'Invalid
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
