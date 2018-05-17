require 'spec_helper'

describe DamsUnitsController do

  describe "GET 'view'" do
    before do
      sign_in User.create! ({:provider => 'developer'})
      @unit = DamsUnit.create pid: "un48484848", name: "Research Data Curation Program", description: "Research Cyberinfrastructure: the hardware, software, and people that support scientific research.", uri: "http://rci.ucsd.edu/", code: "unrdcp", group: "dams-rci"
    end
    after do
      @unit.delete
    end

    it "returns http success" do
      get 'show', :id => 'unrdcp'
      expect(response.status).to eq(200)
    end
  end

  describe 'object counts' do
    let(:unit) { DamsUnit.create name: 'Test Unit', description: 'Test Description', code: 'tu', uri: 'http://example.com/' }
    let(:copyPublic) { DamsCopyright.create status: 'Public domain' }
    let(:copyCurator) { DamsCopyright.create status: 'Under copyright' }
    let(:objPublic) { DamsObject.create titleValue: 'Test Public Record', beginDate: '2013', unitURI: unit.pid, copyrightURI: copyPublic.pid }
    let(:objCurator) { DamsObject.create titleValue: 'Test Private Record', unitURI: unit.pid, copyrightURI: copyCurator.pid }
    let(:objects_count_response) { controller.instance_variable_get('@count_resp') }

    before do
      solr_index objPublic.pid
      solr_index objCurator.pid
    end

    after do
      [objPublic, objCurator, copyPublic, copyCurator, unit].each(&:delete)
    end

    it 'has the count public user' do
      get 'index'

      expect(objects_count_response.response['numFound']).to eq 1
    end

    it 'has the count for curator' do
      sign_in User.create!(provider: 'developer')
      get 'index'

      expect(objects_count_response.response['numFound']).to eq 2
    end
  end
end
