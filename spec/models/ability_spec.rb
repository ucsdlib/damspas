# -*- encoding: utf-8 -*-
require 'spec_helper'
require 'rdf'

describe Ability do
  before(:all) do
    @unit1 = DamsUnit.create name: "Test Unit 1", description: "Test Description 1", code: "tu1", group: "dams-curator", uri: "http://example1.com/"
    @unit2 = DamsUnit.create name: "Test Unit 2", description: "Test Description 2", code: "tu2", group: "dams-rci", uri: "http://example1.com/"
    @copy = DamsCopyright.create status: "Under copyright"
  end
  after(:all) do
    @copy.delete
    @unit1.delete
    @unit2.delete
  end
  describe "Anonymous user" do
  	subject do
      Ability.new(User.new)
    end
    
  	describe "to access a DamsObject" do
	    before(:all) do
	      @obj1 = DamsObject.create!(pid: "ac00000001", titleValue: "Test Title")
	    end
	    after(:all) do
	      @obj1.delete
	    end
	
	    it "should not be able to show damsObject" do
	      expect(subject.can?(:show,@obj1)).to be_falsey
	    end
	    it "should not be able to create damsObject" do
	      expect(subject.can?(:create,@obj1)).to be_falsey
	    end
	    
	    it "should not be able to edit damsObject" do
	      expect(subject.can?(:edit,@obj1)).to be_falsey
	    end
	    
	    it "should not be able to update damsObject" do
	      expect(subject.can?(:update,@obj1)).to be_falsey
	    end
    end
    
    describe "to access a DamsProvenanceCollection" do
		before(:all) do
	      	@damsProvenanceCollection = DamsProvenanceCollection.create!(pid: "ac00000011", titleValue: "Test ProvenanceCollection Title", visibility: "curator", resource_type: "text")
	    end
		after(:all) do
	      	@damsProvenanceCollection.delete
	    end
	    it "should not be allowed to show" do
	      expect(subject.can?(:show,@damsProvenanceCollection)).to be_falsey
	    end
	    it "should be allowed to create" do
	      expect(subject.can?(:create,@damsProvenanceCollectionUnit1)).to be_falsey
	    end
	    it "should be allowed edit" do
	      expect(subject.can?(:edit,@damsProvenanceCollectionUnit1)).to be_falsey
	    end
	    it "should be allowed to update" do
	      expect(subject.can?(:update,@damsProvenanceCollectionUnit1)).to be_falsey
	    end
    end

    describe "to access a DamsCopyright" do
        before(:all) do
        	@damsCopyright = mod_dams_copyright "ac00000021"
	    end
        after(:all) do
          @damsCopyright.delete
        end
	    it "should be allowed to show" do
	      expect(subject.can?(:show,@damsCopyright)).to be_truthy
	    end
	    it "should not be allowed to create" do
	      expect(subject.can?(:create,@damsCopyright)).to be_falsey
	    end
	    it "should not be allowed edit" do
	      expect(subject.can?(:edit,@damsCopyright)).to be_falsey
	    end
	    it "should not be allowed to update" do
	      expect(subject.can?(:update,@damsCopyright)).to be_falsey
	    end
	end	
	    
    describe "to access a MadsTopic" do
    	before(:all) do
		  @madsTopic = mod_mads_topic "ac00000031"
	    end
    	after(:all) do
		  @madsTopic.delete
	    end
	    it "should be allowed to show" do
	      expect(subject.can?(:show,@madsTopic)).to be_truthy
	    end
	    it "should not be allowed to create" do
	      expect(subject.can?(:create,@madsTopic)).to be_falsey
	    end
	    it "should not be allowed edit" do
	      expect(subject.can?(:edit,@madsTopic)).to be_falsey
	    end
	    it "should not be allowed to update" do
	      expect(subject.can?(:update,@madsTopic)).to be_falsey
	    end
	end
  end
  
  describe "anonymous ucsd local user" do
    let(:params) {
	    { basis: "fair use", 
	      note: "Educationally important works unavailable due to unknown copyright holders",
	      uri: "http://library.ucsd.edu/lisn/policy/4123412341/",
	      permission_node_attributes: [type: "localDisplay"],
	      relationship_attributes: [name: RDF::Resource.new("#{Rails.configuration.id_namespace}bd7509406v"),role: RDF::Resource.new("#{Rails.configuration.id_namespace}bd0785823z")]
  	}}
	subject do
      Ability.new(User.anonymous("132.239.0.3"))
    end
    describe "to access a ucsd local display DamsObject" do
    	before do
			@damsOtherRight = DamsOtherRight.create(pid: 'ac00000041')
		    @damsOtherRight.tap do |t|
		      t.attributes = params
		    end
			@damsOtherRight.save
	    	@obj2 = DamsObject.create!(pid: "ac00000051", titleValue: "Test UCSD Local Title", unitURI: @unit1.pid, copyrightURI: @copy.pid, otherRightsURI: "ac00000041")
            solr_index @obj2.pid
	    end
        after do
          @obj2.delete
          @damsOtherRight.delete
        end
	  	it "should be able to show record ac00000051" do   
		    expect(subject.can?(:show,@obj2)).to be_truthy
		 end
	 end
	 describe "to access a ucsd local display DamsProvenanceCollection" do
	 	before(:all) do
	    	@obj3 = DamsProvenanceCollection.create!(pid: "ac00000061", titleValue: "Test UCSD Local Provanence Collection Title", unitURI: @unit1.pid, visibility: "local")
            solr_index @obj3.pid
	    end
        after(:all) do
          @obj3.delete
        end
		 it "should be able to show record ac00000061" do   
		    expect(subject.can?(:show,@obj3)).to be_truthy
		 end
	 end
  end
  
  describe "a logged in user" do
    describe "#{Rails.configuration.super_role} (super user)" do
	    subject do
	      @user = User.create!
	  	  @user_groups = @user.groups
	      logger.debug("[CANCAN rspec user roles default: #{@user.groups.inspect}]")	    
	      @bak_user_groups = [];
	      @user_groups.each do |g|
	      	@bak_user_groups << g
	      end
	      @user.groups.clear
	      @user.groups << Rails.configuration.super_role
	      Ability.new(@user)
	    end
	    describe "to access a DLP DamsObject" do
		    before(:all) do
		      @damsObjectUnit1 = mod_dams_object "ac00000100", @unit1.pid, @copy.pid
              solr_index @damsObjectUnit1.pid
		    end
		    after(:all) do
		      @damsObjectUnit1.delete
		    end
		    it "should be able to show" do
		      expect(subject.can?(:show,@damsObjectUnit1)).to be_truthy
		    end
		    it "should be able to create" do
		      expect(subject.can?(:create,@damsObjectUnit1)).to be_truthy
		    end
		    it "should be able to edit" do
		      expect(subject.can?(:edit,@damsObjectUnit1)).to be_truthy
		    end
		    it "should be able to update" do
		      expect(subject.can?(:update,@damsObjectUnit1)).to be_truthy
		    end
	    end
	    describe "to access a RCI DamsObject" do
	    	before(:all) do
		      @damsObjectUnit2 = mod_dams_object "ac00000101", @unit2.pid, @copy.pid
              solr_index @damsObjectUnit2.pid
		    end
	    	after(:all) do
		      @damsObjectUnit2.delete
		    end
		    it "should be able to show" do
		      expect(subject.can?(:show,@damsObjectUnit2)).to be_truthy
		    end
		    it "should be allowed to create" do
		      expect(subject.can?(:create,@damsObjectUnit2)).to be_truthy
		    end
		    it "should be allowed to edit" do
		      expect(subject.can?(:edit,@damsObjectUnit2)).to be_truthy
		    end
		    it "should be allowed to update" do
		      expect(subject.can?(:update,@damsObjectUnit2)).to be_truthy
		    end
    	end
    	describe "to access a unit1 DamsProvenanceCollection" do
    		before(:all) do
			  @damsProvenanceCollectionUnit1 = mod_dams_provenance_collection "ac00000200", @unit1.pid
			  solr_index @damsProvenanceCollectionUnit1.pid
		    end
    		after(:all) do
			  @damsProvenanceCollectionUnit1.delete
		    end
		    it "should be allowed to show" do
		      expect(subject.can?(:show,@damsProvenanceCollectionUnit1)).to be_truthy
		    end
		    it "should be allowed to create" do
		      expect(subject.can?(:create,@damsProvenanceCollectionUnit1)).to be_truthy
		    end
		    it "should be allowed edit" do
		      expect(subject.can?(:edit,@damsProvenanceCollectionUnit1)).to be_truthy
		    end
		    it "should be allowed to update" do
		      expect(subject.can?(:update,@damsProvenanceCollectionUnit1)).to be_truthy
		    end
	    end
    	describe "to access a unit2 DamsProvenanceCollection" do
    		before(:all) do
			  @damsProvenanceCollectionUnit2 = mod_dams_provenance_collection "ac00000201", @unit2.pid
			  solr_index @damsProvenanceCollectionUnit2.pid
		    end
    		after(:all) do
			  @damsProvenanceCollectionUnit2.delete
		    end
		    it "should be allowed to show" do
		      expect(subject.can?(:show,@damsProvenanceCollectionUnit2)).to be_truthy
		    end
		    it "should be allowed to create" do
		      expect(subject.can?(:create,@damsProvenanceCollectionUnit2)).to be_truthy
		    end
		    it "should be allowed edit" do
		      expect(subject.can?(:edit,@damsProvenanceCollectionUnit2)).to be_truthy
		    end
		    it "should be allowed to update" do
		      expect(subject.can?(:update,@damsProvenanceCollectionUnit2)).to be_truthy
		    end
	    end
    	describe "to access a unit1 DamsProvenanceCollectionPart" do
    		before(:all) do
			  @damsProvenanceCollectionPartUnit1 = mod_dams_provenance_collection_part "ac00000204", @unit1.pid
			  solr_index @damsProvenanceCollectionPartUnit1.pid
		    end
    		after(:all) do
			  @damsProvenanceCollectionPartUnit1.delete
		    end
		    it "should be allowed to show" do
		      expect(subject.can?(:show,@damsProvenanceCollectionPartUnit1)).to be_truthy
		    end
		    it "should be allowed to create" do
		      expect(subject.can?(:create,@damsProvenanceCollectionPartUnit1)).to be_truthy
		    end
		    it "should be allowed edit" do
		      expect(subject.can?(:edit,@damsProvenanceCollectionPartUnit1)).to be_truthy
		    end
		    it "should be allowed to update" do
		      expect(subject.can?(:update,@damsProvenanceCollectionPartUnit1)).to be_truthy
		    end
	    end
    	describe "to access a unit2 DamsProvenanceCollectionPart" do
    		before(:all) do
			  @damsProvenanceCollectionPartUnit2 = mod_dams_provenance_collection_part "ac00000203", @unit2.pid
			  solr_index @damsProvenanceCollectionPartUnit2.pid
		    end
    		after(:all) do
			  @damsProvenanceCollectionPartUnit2.delete
		    end
		    it "should be allowed to show" do
		      expect(subject.can?(:show,@damsProvenanceCollectionPartUnit2)).to be_truthy
		    end
		    it "should be allowed to create" do
		      expect(subject.can?(:create,@damsProvenanceCollectionPartUnit2)).to be_truthy
		    end
		    it "should be allowed edit" do
		      expect(subject.can?(:edit,@damsProvenanceCollectionPartUnit2)).to be_truthy
		    end
		    it "should be allowed to update" do
		      expect(subject.can?(:update,@damsProvenanceCollectionPartUnit2)).to be_truthy
		    end
	    end
    	describe "to access a unit1 DamsAssembledCollection" do
    	    before(:all) do
			  @damsAssembledCollectionUnit15 = mod_dams_assembled_collection "ac00000204", @unit1.pid
		    end
    	    after(:all) do
			  @damsAssembledCollectionUnit15.delete
		    end
		    it "should be allowed to show" do
		      expect(subject.can?(:show,@damsAssembledCollectionUnit15)).to be_truthy
		    end
		    it "should be allowed to create" do
		      expect(subject.can?(:create,@damsAssembledCollectionUnit15)).to be_truthy
		    end
		    it "should be allowed edit" do
		      expect(subject.can?(:edit,@damsAssembledCollectionUnit15)).to be_truthy
		    end
		    it "should be allowed to update" do
		      expect(subject.can?(:update,@damsAssembledCollectionUnit15)).to be_truthy
		    end
	    end
    	describe "to access a unit2 DamsAssembledCollection" do
    		before(:all) do
			  @damsAssembledCollectionUnit2 = mod_dams_assembled_collection "ac00000205", @unit2.pid
			  solr_index @damsAssembledCollectionUnit2.pid
		    end
    		after(:all) do
			  @damsAssembledCollectionUnit2.delete
		    end
		    it "should be allowed to show" do
		      expect(subject.can?(:show,@damsAssembledCollectionUnit2)).to be_truthy
		    end
		    it "should be allowed to create" do
		      expect(subject.can?(:create,@damsAssembledCollectionUnit2)).to be_truthy
		    end
		    it "should be allowed edit" do
		      expect(subject.can?(:edit,@damsAssembledCollectionUnit2)).to be_truthy
		    end
		    it "should be allowed to update" do
		      expect(subject.can?(:update,@damsAssembledCollectionUnit2)).to be_truthy
		    end
	    end
	    
	    describe "to access a DamsUnit" do
	       before(:all) do
		      @damsUnit = mod_dams_unit "ac00000300"
		    end
            after(:all) do
              @damsUnit.delete
            end
		    it "should be allowed to show" do
		      expect(subject.can?(:show,@damsUnit)).to be_truthy
		    end
		    it "should be allowed to create" do
		      expect(subject.can?(:create,@damsUnit)).to be_truthy
		    end
		    it "should be allowed edit" do
		      expect(subject.can?(:edit,@damsUnit)).to be_truthy
		    end
		    it "should be allowed to update" do
		      expect(subject.can?(:update,@damsUnit)).to be_truthy
		    end
		end
	    describe "to access a DamsCopyright" do
	        before(:all) do
	        	@damsCopyright = mod_dams_copyright "ac00000301"
		    end
	        after(:all) do
	        	@damsCopyright.delete
		    end
		    it "should be allowed to show" do
		      expect(subject.can?(:show,@damsCopyright)).to be_truthy
		    end
		    it "should be allowed to create" do
		      expect(subject.can?(:create,@damsCopyright)).to be_truthy
		    end
		    it "should be allowed edit" do
		      expect(subject.can?(:edit,@damsCopyright)).to be_truthy
		    end
		    it "should be allowed to update" do
		      expect(subject.can?(:update,@damsCopyright)).to be_truthy
		    end
		end
		
	    describe "to access a MadsName" do
	        before(:all) do
			  @madsName = mod_mads_name "ac00000400"
		    end
	        after(:all) do
			  @madsName.delete
		    end
		    it "should be allowed to show" do
		      expect(subject.can?(:show,@madsName)).to be_truthy
		    end
		    it "should be allowed to create" do
		      expect(subject.can?(:create,@madsName)).to be_truthy
		    end
		    it "should be allowed edit" do
		      expect(subject.can?(:edit,@madsName)).to be_truthy
		    end
		    it "should be allowed to update" do
		      expect(subject.can?(:update,@madsName)).to be_truthy
		    end
		end		
	    describe "to access a MadsPersonalName" do
	        before(:all) do
			  @madsPersonalName = mod_mads_personal_name "ac00000401"
		    end
	        after(:all) do
			  @madsPersonalName.delete
		    end
		    it "should be allowed to show" do
		      expect(subject.can?(:show,@madsPersonalName)).to be_truthy
		    end
		    it "should be allowed to create" do
		      expect(subject.can?(:create,@madsPersonalName)).to be_truthy
		    end
		    it "should be allowed edit" do
		      expect(subject.can?(:edit,@madsPersonalName)).to be_truthy
		    end
		    it "should be allowed to update" do
		      expect(subject.can?(:update,@madsPersonalName)).to be_truthy
		    end
		end
	    describe "to access a MadsTopic" do
	        before(:all) do
			  @madsTopic = mod_mads_topic "ac00000402"
		    end
	        after(:all) do
			  @madsTopic.delete
		    end
		    it "should be allowed to show" do
		      expect(subject.can?(:show,@madsTopic)).to be_truthy
		    end
		    it "should be allowed to create" do
		      expect(subject.can?(:create,@madsTopic)).to be_truthy
		    end
		    it "should be allowed edit" do
		      expect(subject.can?(:edit,@madsTopic)).to be_truthy
		    end
		    it "should be allowed to update" do
		      expect(subject.can?(:update,@madsTopic)).to be_truthy
		    end
		end
		
	    after do
	    	@user_groups.clear
		  	@bak_user_groups.each do |g|
	    		@user_groups << g
	    	end
		  	logger.debug("[CANCAN rspec user roles reset: #{@user.groups.inspect}]")
	    end
    end
    
    describe "with a dams-curator (unit1 curator) role" do
    	subject do
	      @user = User.create!
	  	  @user_groups = @user.groups
	      logger.debug("[CANCAN rspec user roles default: #{@user.groups.inspect}]")	    
	      @bak_user_groups = [];
	      @user_groups.each do |g|
	      	@bak_user_groups << g
	      end
	      @user.groups.clear
	      @user.groups << "dams-curator"
	      Ability.new(@user)
	    end  
	    
    	describe "to access a RCI DamsObject" do
    		before(:all) do
		      @damsObjectUnit2 = mod_dams_object "ac00000101", @unit2.pid, @copy.pid
		    end
    		after(:all) do
		      @damsObjectUnit2.delete
		    end
    		it "should be allowed to show" do
		      expect(subject.can?(:show,@damsObjectUnit2)).to be_truthy
		    end
		    it "should not be allowed to create" do
		      expect(subject.can?(:create,@damsObjectUnit2)).to be_falsey
		    end
		    it "should not be allowed to edit" do
		      expect(subject.can?(:edit,@damsObjectUnit2)).to be_falsey
		    end
		    it "should not be allowed to update" do
		      expect(subject.can?(:update,@damsObjectUnit2)).to be_falsey
		    end
    	end
    	describe "to access a unit1 DamsObject" do
    		before(:all) do
		      @damsObjectUnit1 = mod_dams_object "ac00000100", @unit1.pid, @copy.pid
		    end
    		after(:all) do
		      @damsObjectUnit1.delete
		    end
		    it "should be allowed to show" do
		      expect(subject.can?(:show,@damsObjectUnit1)).to be_truthy
		    end
		    it "should not be allowed to create" do
		      expect(subject.can?(:create,@damsObjectUnit1)).to be_falsey
		    end
		    it "should not be allowed to edit" do
		      expect(subject.can?(:edit,@damsObjectUnit1)).to be_falsey
		    end
		    it "should not be allowed to update" do
		      expect(subject.can?(:update,@damsObjectUnit1)).to be_falsey
		    end
	    end
	    
	    describe "to access a unit2 DamsProvenanceCollection" do
	    	before(:all) do
			  @damsProvenanceCollectionUnit2 = mod_dams_provenance_collection "ac00000201", @unit2.pid
		    end
	    	after(:all) do
			  @damsProvenanceCollectionUnit2.delete
		    end
	    	it "should be allowed to show record ac00000201" do
		      expect(subject.can?(:show,@damsProvenanceCollectionUnit2)).to be_truthy
		    end
		    it "should not be allowed to create" do
		      expect(subject.can?(:create,@damsProvenanceCollectionUnit2)).to be_falsey
		    end
		    it "should not be allowed to edit" do
		      expect(subject.can?(:edit,@damsProvenanceCollectionUnit2)).to be_falsey
		    end
		    it "should not be allowed to update" do
		      expect(subject.can?(:update,@damsProvenanceCollectionUnit2)).to be_falsey
		    end
    	end
    	
    	describe "to access a unit2 DamsProvenanceCollectionPart" do
    		before(:all) do
			  @damsProvenanceCollectionPartUnit2 = mod_dams_provenance_collection_part "ac00000203", @unit2.pid
		    end
    		after(:all) do
			  @damsProvenanceCollectionPartUnit2.delete
		    end
		    it "should be allowed to show record ac00000203" do
		      expect(subject.can?(:show,@damsProvenanceCollectionPartUnit2)).to be_truthy
		    end
		    it "should not be allowed to create" do
		      expect(subject.can?(:create,@damsProvenanceCollectionPartUnit2)).to be_falsey
		    end
		    it "should not be allowed to edit" do
		      expect(subject.can?(:edit,@damsProvenanceCollectionPartUnit2)).to be_falsey
		    end
		    it "should not be allowed to update" do
		      expect(subject.can?(:update,@damsProvenanceCollectionPartUnit2)).to be_falsey
		    end
    	end
    	
    	describe "to access a unit2 DamsAssembledCollection" do
    		before(:all) do
			  @damsAssembledCollectionUnit2 = mod_dams_assembled_collection "ac00000205", @unit2.pid
		    end
    		after(:all) do
			  @damsAssembledCollectionUnit2.delete
		    end
		    it "should be allowed to show record ac00000205" do
		      expect(subject.can?(:show,@damsAssembledCollectionUnit2)).to be_truthy
		    end
		    it "should not be allowed to create" do
		      expect(subject.can?(:create,@damsAssembledCollectionUnit2)).to be_falsey
		    end
		    it "should not be allowed to edit" do
		      expect(subject.can?(:edit,@damsAssembledCollectionUnit2)).to be_falsey
		    end
		    it "should not be allowed to update" do
		      expect(subject.can?(:update,@damsAssembledCollectionUnit2)).to be_falsey
		    end
    	end
    	
    	describe "to access a unit1 DamsProvenanceCollection" do
    		before(:all) do
			  @damsProvenanceCollectionUnit1 = mod_dams_provenance_collection "ac00000200", @unit1.pid
		    end
    		after(:all) do
			  @damsProvenanceCollectionUnit1.delete
		    end
		    it "should be allowed to show" do
		      expect(subject.can?(:show,@damsProvenanceCollectionUnit1)).to be_truthy
		    end
		    it "should not be allowed to create" do
		      expect(subject.can?(:create,@damsProvenanceCollectionUnit1)).to be_falsey
		    end
		    it "should not be allowed edit" do
		      expect(subject.can?(:edit,@damsProvenanceCollectionUnit1)).to be_falsey
		    end
		    it "should not be allowed to update" do
		      expect(subject.can?(:update,@damsProvenanceCollectionUnit1)).to be_falsey
		    end
	    end
	    
	    describe "to access a unit1 DamsProvenanceCollectionPart" do
	    	before(:all) do
			  @damsProvenanceCollectionPartUnit1 = mod_dams_provenance_collection_part "ac00000204", @unit1.pid
		    end
            after(:all) do
			  @damsProvenanceCollectionPartUnit1.delete
            end
		    it "should be allowed to show" do
		      expect(subject.can?(:show,@damsProvenanceCollectionPartUnit1)).to be_truthy
		    end
		    it "should not be allowed to create" do
		      expect(subject.can?(:create,@damsProvenanceCollectionPartUnit1)).to be_falsey
		    end
		    it "should not be allowed edit" do
		      expect(subject.can?(:edit,@damsProvenanceCollectionPartUnit1)).to be_falsey
		    end
		    it "should not be allowed to update" do
		      expect(subject.can?(:update,@damsProvenanceCollectionPartUnit1)).to be_falsey
		    end
	    end
	    
    	describe "to access a unit1 DamsAssembledCollection" do
    	    before(:all) do
			  @damsAssembledCollectionUnit16 = mod_dams_assembled_collection "ac00000204", @unit1.pid
		    end
    	    after(:all) do
			  @damsAssembledCollectionUnit16.delete
		    end
		    it "should be allowed to show" do
		      expect(subject.can?(:show,@damsAssembledCollectionUnit16)).to be_truthy
		    end
		    it "should not be allowed to create" do
		      expect(subject.can?(:create,@damsAssembledCollectionUnit16)).to be_falsey
		    end
		    it "should not be allowed edit" do
		      expect(subject.can?(:edit,@damsAssembledCollectionUnit16)).to be_falsey
		    end
		    it "should not be allowed to update" do
		      expect(subject.can?(:update,@damsAssembledCollectionUnit16)).to be_falsey
		    end
	    end
	    
	    describe "to access a DamsUnit" do
	        before(:all) do
		      @damsUnit = mod_dams_unit "ac00000300"
              solr_index @damsUnit.pid
		    end
	        after(:all) do
		      @damsUnit.delete
		    end
		    it "should be allowed to show" do
		      expect(subject.can?(:show,@damsUnit)).to be_truthy
		    end
		    it "should not be allowed to create" do
		      expect(subject.can?(:create,@damsUnit)).to be_falsey
		    end
		    it "should not be allowed edit" do
		      expect(subject.can?(:edit,@damsUnit)).to be_falsey
		    end
		    it "should not be allowed to update" do
		      expect(subject.can?(:update,@damsUnit)).to be_falsey
		    end
	    end
	    describe "to access a DamsCopyright" do
	        before(:all) do
	        	@damsCopyright = mod_dams_copyright "ac00000301"
		    end
	        before(:all) do
	        	@damsCopyright.delete
		    end
		    it "should be allowed to show" do
		      expect(subject.can?(:show,@damsCopyright)).to be_truthy
		    end
		    it "should be allowed to create" do
		      expect(subject.can?(:create,@damsCopyright)).to be_truthy
		    end
		    it "should be allowed edit" do
		      expect(subject.can?(:edit,@damsCopyright)).to be_truthy
		    end
		    it "should be allowed to update" do
		      expect(subject.can?(:update,@damsCopyright)).to be_truthy
		    end
		end
		
		describe "to access a MadsName" do
		    before(:all) do
			  @madsName = mod_mads_name "ac00000400"
		    end
		    before(:all) do
			  @madsName.delete
		    end
		    it "should be allowed to show" do
		      expect(subject.can?(:show,@madsName)).to be_truthy
		    end
		    it "should be allowed to create" do
		      expect(subject.can?(:create,@madsName)).to be_truthy
		    end
		    it "should be allowed edit record ac00000400" do
		      expect(subject.can?(:edit,@madsName)).to be_truthy
		    end
		    it "should be allowed to update record ac00000400" do
		      expect(subject.can?(:update,@madsName)).to be_truthy
		    end
		end	    
		describe "to access a MadsPersonalName" do
		    before(:all) do
			  @madsPersonalName = mod_mads_personal_name "ac00000401"
		    end
		    it "should be allowed to show" do
		      expect(subject.can?(:show,@madsPersonalName)).to be_truthy
		    end
		    it "should be allowed to create" do
		      expect(subject.can?(:create,@madsPersonalName)).to be_truthy
		    end
		    it "should be allowed edit record ac00000401" do
		      expect(subject.can?(:edit,@madsPersonalName)).to be_truthy
		    end
		    it "should be allowed to update record ac00000401" do
		      expect(subject.can?(:update,@madsPersonalName)).to be_truthy
		    end
		end
	    describe "to access a MadsTopic" do
	        before(:all) do
			  @madsTopic = mod_mads_topic "ac00000402"
		    end	    
		    it "should be allowed to show" do
		      expect(subject.can?(:show,@madsTopic)).to be_truthy
		    end
		    it "should be allowed to create" do
		      expect(subject.can?(:create,@madsTopic)).to be_truthy
		    end
		    it "should be allowed edit record ac00000402" do
		      expect(subject.can?(:edit,@madsTopic)).to be_truthy
		    end
		    it "should be allowed to update record ac00000402" do
		      expect(subject.can?(:update,@madsTopic)).to be_truthy
		    end
		end
	    	        
	    after do
	    	@user_groups.clear
		  	@bak_user_groups.each do |g|
	    		@user_groups << g
	    	end
		  	logger.debug("[CANCAN rspec user roles reset: #{@user.groups.inspect}]")
	    end
    end
    
    describe "with a dams-editor role" do
    	subject do
	      @user = User.create!
	  	  @user_groups = @user.groups
	      logger.debug("[CANCAN rspec user roles default: #{@user.groups.inspect}]")	    
	      @bak_user_groups = [];
	      @user_groups.each do |g|
	      	@bak_user_groups << g
	      end
	      @user.groups.clear
	      @user.groups << "dams-editor"
	      Ability.new(@user)
	    end  
	    
    	describe "to access a unit2 DamsObject" do
    	    before(:all) do
		      @damsObjectUnit2 = mod_dams_object "ac00000101", @unit2.pid, @copy.pid
		    end
    		it "should be allowed to show" do
		      expect(subject.can?(:show,@damsObjectUnit2)).to be_truthy
		    end
		    it "should be allowed to create" do
		      expect(subject.can?(:create,@damsObjectUnit2)).to be_truthy
		    end
		    it "should be allowed to edit" do
		      expect(subject.can?(:edit,@damsObjectUnit2)).to be_truthy
		    end
		    it "should be allowed to update" do
		      expect(subject.can?(:update,@damsObjectUnit2)).to be_truthy
		    end
    	end
    	describe "to access a unit1 DamsObject" do
    		before(:all) do
		      @damsObjectUnit1 = mod_dams_object "ac00000100", @unit1.pid, @copy.pid
		    end
		    it "should be allowed to show" do
		      expect(subject.can?(:show,@damsObjectUnit1)).to be_truthy
		    end
		    it "should be allowed to create" do
		      expect(subject.can?(:create,@damsObjectUnit1)).to be_truthy
		    end
		    it "should be allowed to edit" do
		      expect(subject.can?(:edit,@damsObjectUnit1)).to be_truthy
		    end
		    it "should be allowed to update" do
		      expect(subject.can?(:update,@damsObjectUnit1)).to be_truthy
		    end
	    end
	    
	    describe "to access a unit2 DamsProvenanceCollection" do
	    	before(:all) do
			  @damsProvenanceCollectionUnit2 = mod_dams_provenance_collection "ac00000201", @unit2.pid
		    end
	    	it "should be allowed to show" do
		      expect(subject.can?(:show,@damsProvenanceCollectionUnit2)).to be_truthy
		    end
		    it "should be allowed to create" do
		      expect(subject.can?(:create,@damsProvenanceCollectionUnit2)).to be_truthy
		    end
		    it "should be allowed to edit" do
		      expect(subject.can?(:edit,@damsProvenanceCollectionUnit2)).to be_truthy
		    end
		    it "should be allowed to update" do
		      expect(subject.can?(:update,@damsProvenanceCollectionUnit2)).to be_truthy
		    end
    	end
    	
    	describe "to access a unit2 DamsProvenanceCollectionPart" do
    		before(:all) do
			  @damsProvenanceCollectionPartUnit2 = mod_dams_provenance_collection_part "ac00000203", @unit2.pid
		    end
		   it "should be allowed to show" do
		      expect(subject.can?(:show,@damsProvenanceCollectionPartUnit2)).to be_truthy
		    end
		    it "should be allowed to create" do
		      expect(subject.can?(:create,@damsProvenanceCollectionPartUnit2)).to be_truthy
		    end
		    it "should be allowed to edit" do
		      expect(subject.can?(:edit,@damsProvenanceCollectionPartUnit2)).to be_truthy
		    end
		    it "should be allowed to update" do
		      expect(subject.can?(:update,@damsProvenanceCollectionPartUnit2)).to be_truthy
		    end
    	end
    	
    	describe "to access a unit2 DamsAssembledCollection" do
    		before(:all) do
			  @damsAssembledCollectionUnit2 = mod_dams_assembled_collection "ac00000205", @unit2.pid
		    end
		    it "should be allowed to show" do
		      expect(subject.can?(:show,@damsAssembledCollectionUnit2)).to be_truthy
		    end
		    it "should be allowed to create" do
		      expect(subject.can?(:create,@damsAssembledCollectionUnit2)).to be_truthy
		    end
		    it "should be allowed to edit" do
		      expect(subject.can?(:edit,@damsAssembledCollectionUnit2)).to be_truthy
		    end
		    it "should be allowed to update" do
		      expect(subject.can?(:update,@damsAssembledCollectionUnit2)).to be_truthy
		    end
    	end
    	
    	describe "to access a unit1 DamsProvenanceCollection" do
    	    before(:all) do
			  @damsAssembledCollectionUnit12 = mod_dams_assembled_collection "ac00000204", @unit1.pid
			  @damsProvenanceCollectionUnit1 = mod_dams_provenance_collection "ac00000200", @unit1.pid
		    end
    		after(:all) do
			  @damsAssembledCollectionUnit12.delete
			  @damsProvenanceCollectionUnit1.delete
		    end
		    it "should be allowed to show" do
		      expect(subject.can?(:show,@damsProvenanceCollectionUnit1)).to be_truthy
		    end
		    it "should be allowed to create" do
		      expect(subject.can?(:create,@damsProvenanceCollectionUnit1)).to be_truthy
		    end
		    it "should be allowed edit" do
		      expect(subject.can?(:edit,@damsProvenanceCollectionUnit1)).to be_truthy
		    end
		    it "should be allowed to update" do
		      expect(subject.can?(:update,@damsProvenanceCollectionUnit1)).to be_truthy
		    end
	    end
	    
	    describe "to access a unit1 DamsProvenanceCollectionPart" do
	    	before(:all) do
			  @damsProvenanceCollectionPartUnit1 = mod_dams_provenance_collection_part "ac00000204", @unit1.pid
		    end
	    	after(:all) do
			  @damsProvenanceCollectionPartUnit1.delete
		    end
		    it "should be allowed to show" do
		      expect(subject.can?(:show,@damsProvenanceCollectionPartUnit1)).to be_truthy
		    end
		    it "should be allowed to create" do
		      expect(subject.can?(:create,@damsProvenanceCollectionPartUnit1)).to be_truthy
		    end
		    it "should be allowed edit" do
		      expect(subject.can?(:edit,@damsProvenanceCollectionPartUnit1)).to be_truthy
		    end
		    it "should be allowed to update" do
		      expect(subject.can?(:update,@damsProvenanceCollectionPartUnit1)).to be_truthy
		    end
	    end
	    
    	describe "to access a unit1 DamsAssembledCollection" do
    	    before(:all) do
			  @damsAssembledCollectionUnit13 = mod_dams_assembled_collection "ac00000204", @unit1.pid
		    end
    	    after(:all) do
			  @damsAssembledCollectionUnit13.delete
		    end
		    it "should be allowed to show" do
		      expect(subject.can?(:show,@damsAssembledCollectionUnit13)).to be_truthy
		    end
		    it "should be allowed to create" do
		      expect(subject.can?(:create,@damsAssembledCollectionUnit13)).to be_truthy
		    end
		    it "should be allowed edit" do
		      expect(subject.can?(:edit,@damsAssembledCollectionUnit13)).to be_truthy
		    end
		    it "should be allowed to update" do
		      expect(subject.can?(:update,@damsAssembledCollectionUnit13)).to be_truthy
		    end
	    end
	    
	    describe "to access a DamsUnit" do
	       before(:all) do
		      @damsUnit = mod_dams_unit "ac00000300"
              solr_index @damsUnit.pid
		   end
	       after(:all) do
		      @damsUnit.delete
		    end
		    it "should be allowed to show" do
		      expect(subject.can?(:show,@damsUnit)).to be_truthy
		    end
		    it "should not be allowed to create" do
		      expect(subject.can?(:create,@damsUnit)).to be_falsey
		    end
		    it "should not be allowed edit" do
		      expect(subject.can?(:edit,@damsUnit)).to be_falsey
		    end
		    it "should not be allowed to update" do
		      expect(subject.can?(:update,@damsUnit)).to be_falsey
		    end
	    end
	    describe "to access a DamsCopyright" do
	        before(:all) do
	        	@damsCopyright = mod_dams_copyright "ac00000301"
		    end
	        after(:all) do
	        	@damsCopyright.delete
		    end
		    it "should be allowed to show" do
		      expect(subject.can?(:show,@damsCopyright)).to be_truthy
		    end
		    it "should be allowed to create" do
		      expect(subject.can?(:create,@damsCopyright)).to be_truthy
		    end
		    it "should be allowed edit" do
		      expect(subject.can?(:edit,@damsCopyright)).to be_truthy
		    end
		    it "should be allowed to update" do
		      expect(subject.can?(:update,@damsCopyright)).to be_truthy
		    end
		end
		
		describe "to access a MadsName" do
		    before(:all) do
			  @madsName = mod_mads_name "ac00000400"
		    end
		    after(:all) do
			  @madsName.delete
		    end
		    it "should be allowed to show" do
		      expect(subject.can?(:show,@madsName)).to be_truthy
		    end
		    it "should be allowed to create" do
		      expect(subject.can?(:create,@madsName)).to be_truthy
		    end
		    it "should be allowed edit" do
		      expect(subject.can?(:edit,@madsName)).to be_truthy
		    end
		    it "should be allowed to update" do
		      expect(subject.can?(:update,@madsName)).to be_truthy
		    end
		end	    
		describe "to access a MadsPersonalName" do
		    before(:all) do
			  @madsPersonalName = mod_mads_personal_name "ac00000401"
		    end
		    after(:all) do
			  @madsPersonalName.delete
		    end
		    it "should be allowed to show" do
		      expect(subject.can?(:show,@madsPersonalName)).to be_truthy
		    end
		    it "should be allowed to create" do
		      expect(subject.can?(:create,@madsPersonalName)).to be_truthy
		    end
		    it "should be allowed edit" do
		      expect(subject.can?(:edit,@madsPersonalName)).to be_truthy
		    end
		    it "should be allowed to update" do
		      expect(subject.can?(:update,@madsPersonalName)).to be_truthy
		    end
		end
	    describe "to access a MadsTopic" do
	    	before(:all) do
			  @madsTopic = mod_mads_topic "ac00000402"
		    end
	    	after(:all) do
			  @madsTopic.delete
		    end
		    it "should be allowed to show" do
		      expect(subject.can?(:show,@madsTopic)).to be_truthy
		    end
		    it "should be allowed to create" do
		      expect(subject.can?(:create,@madsTopic)).to be_truthy
		    end
		    it "should be allowed edit" do
		      expect(subject.can?(:edit,@madsTopic)).to be_truthy
		    end
		    it "should be allowed to update" do
		      expect(subject.can?(:update,@madsTopic)).to be_truthy
		    end
		end
	    	        
	    after do
	    	@user_groups.clear
		  	@bak_user_groups.each do |g|
	    		@user_groups << g
	    	end
		  	logger.debug("[CANCAN rspec user roles reset: #{@user.groups.inspect}]")
	    end
    end
    
    describe "with no curator roles assigned" do 
    	subject do
	      @user = User.create!
	  	  @user_groups = @user.groups
	      logger.debug("[CANCAN rspec user roles default: #{@user.groups.inspect}]")	    
	      @bak_user_groups = [];
	      @user_groups.each do |g|
	      	@bak_user_groups << g
	      end
	      @user.groups.clear
	      Ability.new(@user)
	    end
	    
    	describe "to access a RCI DamsObject" do
    	    before(:all) do
		      @damsObjectUnit2 = mod_dams_object "ac00000101", @unit2.pid, @copy.pid
		    end
    	    after(:all) do
		      @damsObjectUnit2.delete
		    end
    		it "should not be allowed to show" do
		      expect(subject.can?(:show,@damsObjectUnit2)).to be_falsey
		    end
		    it "should not be allowed to create" do
		      expect(subject.can?(:create,@damsObjectUnit2)).to be_falsey
		    end
		    it "should not be allowed to edit" do
		      expect(subject.can?(:edit,@damsObjectUnit2)).to be_falsey
		    end
		    it "should not be allowed to update" do
		      expect(subject.can?(:update,@damsObjectUnit2)).to be_falsey
		    end
    	end
    	describe "to access a unit1 DamsObject" do
    		before(:all) do
		      @damsObjectUnit1 = mod_dams_object "ac00000100", @unit1.pid, @copy.pid
		    end
    		after(:all) do
		      @damsObjectUnit1.delete
		    end
		    it "should not be allowed to show" do
		      expect(subject.can?(:show,@damsObjectUnit1)).to be_falsey
		    end
		    it "should not be allowed to create" do
		      expect(subject.can?(:create,@damsObjectUnit1)).to be_falsey
		    end
		    it "should not be allowed to edit" do
		      expect(subject.can?(:edit,@damsObjectUnit1)).to be_falsey
		    end
		    it "should not be allowed to update" do
		      expect(subject.can?(:update,@damsObjectUnit1)).to be_falsey
		    end
	    end
	    
	    describe "to access a unit2 DamsProvenanceCollection" do
	    	before(:all) do
			  @damsProvenanceCollectionUnit2 = mod_dams_provenance_collection "ac00000201", @unit2.pid
		    end
	    	after(:all) do
			  @damsProvenanceCollectionUnit2.delete
		    end
		    it "should not be allowed to show" do
		      expect(subject.can?(:show,@damsProvenanceCollectionUnit2)).to be_falsey
		    end
		    it "should not be allowed to create" do
		      expect(subject.can?(:create,@damsProvenanceCollectionUnit2)).to be_falsey
		    end
		    it "should not be allowed to edit" do
		      expect(subject.can?(:edit,@damsProvenanceCollectionUnit2)).to be_falsey
		    end
		    it "should not be allowed to update" do
		      expect(subject.can?(:update,@damsProvenanceCollectionUnit2)).to be_falsey
		    end
    	end
    	
    	describe "to access a unit2 DamsProvenanceCollectionPart" do
    		before(:all) do
			  @damsProvenanceCollectionPartUnit2 = mod_dams_provenance_collection_part "ac00000203", @unit2.pid
		    end
    		after(:all) do
			  @damsProvenanceCollectionPartUnit2.delete
		    end
		    it "should not be allowed to show" do
		      expect(subject.can?(:show,@damsProvenanceCollectionPartUnit2)).to be_falsey
		    end
		    it "should not be allowed to create" do
		      expect(subject.can?(:create,@damsProvenanceCollectionPartUnit2)).to be_falsey
		    end
		    it "should not be allowed to edit" do
		      expect(subject.can?(:edit,@damsProvenanceCollectionPartUnit2)).to be_falsey
		    end
		    it "should not be allowed to update" do
		      expect(subject.can?(:update,@damsProvenanceCollectionPartUnit2)).to be_falsey
		    end
    	end
    	
    	describe "to access a unit2 DamsAssembledCollection" do
    		before(:all) do
			  @damsAssembledCollectionUnit2 = mod_dams_assembled_collection "ac00000205", @unit2.pid
		    end
    		after(:all) do
			  @damsAssembledCollectionUnit2.delete
		    end
    		it "should not be allowed to show" do
		      expect(subject.can?(:show,@damsAssembledCollectionUnit2)).to be_falsey
		    end
		    it "should not be allowed to create" do
		      expect(subject.can?(:create,@damsAssembledCollectionUnit2)).to be_falsey
		    end
		    it "should not be allowed to edit" do
		      expect(subject.can?(:edit,@damsAssembledCollectionUnit2)).to be_falsey
		    end
		    it "should not be allowed to update" do
		      expect(subject.can?(:update,@damsAssembledCollectionUnit2)).to be_falsey
		    end
    	end
    	
    	describe "to access a unit1 DamsProvenanceCollection" do
    		before(:all) do
			  @damsProvenanceCollectionUnit1 = mod_dams_provenance_collection "ac00000200", @unit1.pid
		    end
    		after(:all) do
			  @damsProvenanceCollectionUnit1.delete
		    end
		    it "should not be allowed to show" do
		      expect(subject.can?(:show,@damsProvenanceCollectionUnit1)).to be_falsey
		    end
		    it "should not be allowed to create" do
		      expect(subject.can?(:create,@damsProvenanceCollectionUnit1)).to be_falsey
		    end
		    it "should not be allowed edit" do
		      expect(subject.can?(:edit,@damsProvenanceCollectionUnit1)).to be_falsey
		    end
		    it "should not be allowed to update" do
		      expect(subject.can?(:update,@damsProvenanceCollectionUnit1)).to be_falsey
		    end
	    end
	    
	    describe "to access a unit1 DamsProvenanceCollectionPart" do
	    	before(:all) do
			  @damsProvenanceCollectionPartUnit1 = mod_dams_provenance_collection_part "ac00000204", @unit1.pid
		    end
	    	after(:all) do
			  @damsProvenanceCollectionPartUnit1.delete
		    end
		    it "should not be allowed to show" do
		      expect(subject.can?(:show,@damsProvenanceCollectionPartUnit1)).to be_falsey
		    end
		    it "should not be allowed to create" do
		      expect(subject.can?(:create,@damsProvenanceCollectionPartUnit1)).to be_falsey
		    end
		    it "should not be allowed edit" do
		      expect(subject.can?(:edit,@damsProvenanceCollectionPartUnit1)).to be_falsey
		    end
		    it "should not be allowed to update" do
		      expect(subject.can?(:update,@damsProvenanceCollectionPartUnit1)).to be_falsey
		    end
	    end
	    
    	describe "to access a unit1 DamsAssembledCollection" do
    	    before(:all) do
			  @damsAssembledCollectionUnit14 = mod_dams_assembled_collection "ac00000204", @unit1.pid
		    end
    	    after(:all) do
			  @damsAssembledCollectionUnit14.delete
		    end
		    it "should not be allowed to show" do
		      expect(subject.can?(:show,@damsAssembledCollectionUnit14)).to be_falsey
		    end
		    it "should not be allowed to create" do
		      expect(subject.can?(:create,@damsAssembledCollectionUnit14)).to be_falsey
		    end
		    it "should not be allowed edit" do
		      expect(subject.can?(:edit,@damsAssembledCollectionUnit14)).to be_falsey
		    end
		    it "should not be allowed to update" do
		      expect(subject.can?(:update,@damsAssembledCollectionUnit14)).to be_falsey
		    end
	    end
	    
	    describe "to access a DamsUnit" do
	       before(:all) do
		      @damsUnit = mod_dams_unit "ac00000300"
		    end
	       after(:all) do
		      @damsUnit.delete
		    end
		    it "should be allowed to show" do
		      expect(subject.can?(:show,@damsUnit)).to be_truthy
		    end
		    it "should not be allowed to create" do
		      expect(subject.can?(:create,@damsUnit)).to be_falsey
		    end
		    it "should not be allowed edit" do
		      expect(subject.can?(:edit,@damsUnit)).to be_falsey
		    end
		    it "should not be allowed to update" do
		      expect(subject.can?(:update,@damsUnit)).to be_falsey
		    end
		end
	    describe "to access a DamsCopyright" do
	        before(:all) do
	        	@damsCopyright = mod_dams_copyright "ac00000301"
		    end
	        after(:all) do
	        	@damsCopyright.delete
		    end
		    it "should be allowed to show" do
		      expect(subject.can?(:show,@damsCopyright)).to be_truthy
		    end
		    it "should not be allowed to create" do
		      expect(subject.can?(:create,@damsCopyright)).to be_falsey
		    end
		    it "should not be allowed edit" do
		      expect(subject.can?(:edit,@damsCopyright)).to be_falsey
		    end
		    it "should not be allowed to update" do
		      expect(subject.can?(:update,@damsCopyright)).to be_falsey
		    end
		end		

		describe "to access a MadsName" do
		    before(:all) do
			  @madsName = mod_mads_name "ac00000400"
		    end
		    after(:all) do
			  @madsName.delete
		    end
		    it "should be allowed to show" do
		      expect(subject.can?(:show,@madsName)).to be_truthy
		    end
		    it "should not be allowed to create" do
		      expect(subject.can?(:create,@madsName)).to be_falsey
		    end
		    it "should not be allowed edit" do
		      expect(subject.can?(:edit,@madsName)).to be_falsey
		    end
		    it "should not be allowed to update" do
		      expect(subject.can?(:update,@madsName)).to be_falsey
		    end
		end
		describe "to access a MadsPersonalName" do
		    before(:all) do
			  @madsPersonalName = mod_mads_personal_name "ac00000401"
		    end
		    after(:all) do
			  @madsPersonalName.delete
		    end
		    it "should be allowed to show" do
		      expect(subject.can?(:show,@madsPersonalName)).to be_truthy
		    end
		    it "should not be allowed to create" do
		      expect(subject.can?(:create,@madsPersonalName)).to be_falsey
		    end
		    it "should not be allowed edit" do
		      expect(subject.can?(:edit,@madsPersonalName)).to be_falsey
		    end
		    it "should not be allowed to update" do
		      expect(subject.can?(:update,@madsPersonalName)).to be_falsey
		    end
		end
	    describe "to access a MadsTopic" do
	    	before(:all) do
			  @madsTopic = mod_mads_topic "ac00000402"
		    end
	    	after(:all) do
			  @madsTopic.delete
		    end
		    it "should be allowed to show" do
		      expect(subject.can?(:show,@madsTopic)).to be_truthy
		    end
		    it "should not be allowed to create" do
		      expect(subject.can?(:create,@madsTopic)).to be_falsey
		    end
		    it "should not be allowed edit" do
		      expect(subject.can?(:edit,@madsTopic)).to be_falsey
		    end
		    it "should not be allowed to update" do
		      expect(subject.can?(:update,@madsTopic)).to be_falsey
		    end
		end
			        
	    after do
	    	@user_groups.clear
		  	@bak_user_groups.each do |g|
	    		@user_groups << g
	    	end
		  	logger.debug("[CANCAN rspec user roles reset: #{@user.groups.inspect}]")
	    end
    end
  end
end
