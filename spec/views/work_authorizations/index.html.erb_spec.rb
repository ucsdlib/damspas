require 'spec_helper'

RSpec.describe "work_authorizations/index.html.erb", type: :view do
  context 'a user with work authorizations' do
    before(:each) do
      @user = create_auth_link_user
      @user.work_authorizations.create(work_title: 'test_work', work_pid: 'test_pid')
    end

    it 'shows a list of works user is authorized to view' do
      assign(:work_authorizations, @user.work_authorizations.all)

      render

      rendered.should have_selector('table.table', text: 'test_work')
    end
  end

  context 'a user without work authorizations' do
    it 'tells the user they have no work authorizations' do
      render

      rendered.should have_selector('p', text: 'No work authorizations to show')
    end
  end
end
