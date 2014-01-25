# -*- encoding: utf-8 -*-
require 'spec_helper'
require 'rdf'

describe Ability do
  describe "Anonymous user" do
  	subject do
      Ability.new(User.new)
    end
    
  	describe "to access a DamsObject" do
	    before do
	      @obj = DamsObject.create!(pid: "ac00000001", titleValue: "Test Title")
	 	  # reindex the record
		  solr_index @obj.id
	    end
	
	    it "should not be able to show damsObject" do
	      subject.can?(:show,@obj).should be_false
	    end
	    it "should not be able to create damsObject" do
	      subject.can?(:create,@obj).should be_false
	    end
	    
	    it "should not be able to edit damsObject" do
	      subject.can?(:edit,@obj).should be_false
	    end
	    
	    it "should not be able to update damsObject" do
	      subject.can?(:update,@obj).should be_false
	    end
    end
    
    describe "to access a DamsProvenanceCollection" do
		before do
	      	@damsProvenanceCollection = DamsProvenanceCollection.create!(pid: "ac00000011", titleValue: "Test ProvenanceCollection Title", visibility: "curator", resource_type: "text")
			solr_index @damsProvenanceCollection.id
	    end
	    it "should not allow to show" do
	      subject.can?(:show,@damsProvenanceCollection).should be_false
	    end
	    it "should allow to create" do
	      subject.can?(:create,@damsProvenanceCollectionDlp).should be_false
	    end
	    it "should allow edit" do
	      subject.can?(:edit,@damsProvenanceCollectionDlp).should be_false
	    end
	    it "should allow to update" do
	      subject.can?(:update,@damsProvenanceCollectionDlp).should be_false
	    end
    end

    describe "to access a DamsCopyright" do
        before do
        	@damsCopyright = mod_dams_copyright "ac00000021"
	    end
	    it "should allow to show" do
	      subject.can?(:show,@damsCopyright).should be_true
	    end
	    it "should not allow to create" do
	      subject.can?(:create,@damsCopyright).should be_false
	    end
	    it "should not allow edit" do
	      subject.can?(:edit,@damsCopyright).should be_false
	    end
	    it "should not allow to update" do
	      subject.can?(:update,@damsCopyright).should be_false
	    end
	end	
	    
    describe "to access a MadsTopic" do
    	before do
		  @madsTopic = mod_mads_topic "ac00000031"
	    end
	    it "should allow to show" do
	      subject.can?(:show,@madsTopic).should be_true
	    end
	    it "should not allow to create" do
	      subject.can?(:create,@madsTopic).should be_false
	    end
	    it "should not allow edit" do
	      subject.can?(:edit,@madsTopic).should be_false
	    end
	    it "should not allow to update" do
	      subject.can?(:update,@madsTopic).should be_false
	    end
	end
  end
  
  describe "Anonymous ucsd local user" do
    let(:params) {
	    { basis: "fair use", 
	      note: "Educationally important works unavailable due to unknown copyright holders",
	      uri: "http://library.ucsd.edu/lisn/policy/4123412341/",
	      permission_node_attributes: [type: "localDisplay"],
	      relationship_attributes: [name: RDF::Resource.new("#{Rails.configuration.id_namespace}bd7509406v"),role: RDF::Resource.new("#{Rails.configuration.id_namespace}bd0785823z")]
  	}}
	subject do
      Ability.new(User.anonymous("137.110.0.10"))
    end
    describe "to access a ucsd local display DamsObject" do
    	before do
			damsOtherRight = DamsOtherRight.new(pid: 'ac00000041')
		    damsOtherRight.tap do |t|
		      t.attributes = params
		    end
			damsOtherRight.save
	    	@obj = DamsObject.create!(pid: "ac00000051", titleValue: "Test UCSD Local Title", unitURI: "bb02020202", copyrightURI: "bb05050505", otherRights: [RDF::Resource.new("#{Rails.configuration.id_namespace}ac10000000")])
	 	 	# reindex the record
			solr_index @obj.id
	    end
	  	pending "should be able to show record ac00000051" do   
		    subject.can?(:show,@obj).should be_true
		 end
	 end
	 describe "to access a ucsd local display DamsProvenanceCollection" do
	 	before do
	    	@obj = DamsProvenanceCollection.create!(pid: "ac00000061", titleValue: "Test UCSD Local Provanence Collection Title", unitURI: "bb02020202", visibility: "local")
	 	 	# reindex the record
			solr_index @obj.id
	    end
		 pending "should be able to show record ac00000061" do   
		    subject.can?(:show,@obj).should be_true
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
		    before do
		      # DLP unit: bb02020202
		      @damsObjectDlp = mod_dams_object "ac00000100", "bb02020202" 
		      solr_index "bb02020202"
		    end
		    it "should be able to show" do
		      subject.can?(:show,@damsObjectDlp).should be_true
		    end
		    it "should be able to create" do
		      subject.can?(:create,@damsObjectDlp).should be_true
		    end
		    it "should be able to edit" do
		      subject.can?(:edit,@damsObjectDlp).should be_true
		    end
		    it "should be able to update" do
		      subject.can?(:update,@damsObjectDlp).should be_true
		    end
	    end
	    describe "to access a RCI DamsObject" do
	    	before do
		      # RCI unit: bb48484848
		      @damsObjectRci = mod_dams_object "ac00000101", "bb48484848" 
		      solr_index "bb48484848"
		    end
		    it "should be able to show" do
		      subject.can?(:show,@damsObjectRci).should be_true
		    end
		    it "should allow to create" do
		      subject.can?(:create,@damsObjectRci).should be_true
		    end
		    it "should allow to edit" do
		      subject.can?(:edit,@damsObjectRci).should be_true
		    end
		    it "should allow to update" do
		      subject.can?(:update,@damsObjectRci).should be_true
		    end
    	end
    	describe "to access a dlp DamsProvenanceCollection" do
    		before do
		      # DLP unit: bb02020202
			  @damsProvenanceCollectionDlp = mod_dams_provenance_collection "ac00000200", "bb02020202"
		    end
		    it "should allow to show" do
		      subject.can?(:show,@damsProvenanceCollectionDlp).should be_true
		    end
		    it "should allow to create" do
		      subject.can?(:create,@damsProvenanceCollectionDlp).should be_true
		    end
		    it "should allow edit" do
		      subject.can?(:edit,@damsProvenanceCollectionDlp).should be_true
		    end
		    it "should allow to update" do
		      subject.can?(:update,@damsProvenanceCollectionDlp).should be_true
		    end
	    end
    	describe "to access a rci DamsProvenanceCollection" do
    		before do
		      # RCI unit: bb48484848
			  @damsProvenanceCollectionRci = mod_dams_provenance_collection "ac00000201", "bb48484848"
		    end
		    it "should allow to show" do
		      subject.can?(:show,@damsProvenanceCollectionRci).should be_true
		    end
		    it "should allow to create" do
		      subject.can?(:create,@damsProvenanceCollectionRci).should be_true
		    end
		    it "should allow edit" do
		      subject.can?(:edit,@damsProvenanceCollectionRci).should be_true
		    end
		    it "should allow to update" do
		      subject.can?(:update,@damsProvenanceCollectionRci).should be_true
		    end
	    end
    	describe "to access a dlp DamsProvenanceCollectionPart" do
    		before do
		      # DLP unit: bb02020202
			  @damsProvenanceCollectionPartDlp = mod_dams_provenance_collection_part "ac00000204", "bb02020202"
		    end
		    it "should allow to show" do
		      subject.can?(:show,@damsProvenanceCollectionPartDlp).should be_true
		    end
		    it "should allow to create" do
		      subject.can?(:create,@damsProvenanceCollectionPartDlp).should be_true
		    end
		    it "should allow edit" do
		      subject.can?(:edit,@damsProvenanceCollectionPartDlp).should be_true
		    end
		    it "should allow to update" do
		      subject.can?(:update,@damsProvenanceCollectionPartDlp).should be_true
		    end
	    end
    	describe "to access a rci DamsProvenanceCollectionPart" do
    		before do
		      # RCI unit: bb48484848
			  @damsProvenanceCollectionPartRci = mod_dams_provenance_collection_part "ac00000203", "bb48484848"
		    end
		    it "should allow to show" do
		      subject.can?(:show,@damsProvenanceCollectionPartRci).should be_true
		    end
		    it "should allow to create" do
		      subject.can?(:create,@damsProvenanceCollectionPartRci).should be_true
		    end
		    it "should allow edit" do
		      subject.can?(:edit,@damsProvenanceCollectionPartRci).should be_true
		    end
		    it "should allow to update" do
		      subject.can?(:update,@damsProvenanceCollectionPartRci).should be_true
		    end
	    end
    	describe "to access a dlp DamsAssembledCollection" do
    	    before do
		      # DLP unit: bb02020202
			  @damsAssembledCollectionDlp = mod_dams_assembled_collection "ac00000204", "bb02020202"
		    end
		    it "should allow to show" do
		      subject.can?(:show,@damsAssembledCollectionDlp).should be_true
		    end
		    it "should allow to create" do
		      subject.can?(:create,@damsAssembledCollectionDlp).should be_true
		    end
		    it "should allow edit" do
		      subject.can?(:edit,@damsAssembledCollectionDlp).should be_true
		    end
		    it "should allow to update" do
		      subject.can?(:update,@damsAssembledCollectionDlp).should be_true
		    end
	    end
    	describe "to access a rci DamsAssembledCollection" do
    		before do
		      # RCI unit: bb48484848
			  @damsAssembledCollectionRci = mod_dams_assembled_collection "ac00000205", "bb48484848"
		    end
		    it "should allow to show" do
		      subject.can?(:show,@damsAssembledCollectionRci).should be_true
		    end
		    it "should allow to create" do
		      subject.can?(:create,@damsAssembledCollectionRci).should be_true
		    end
		    it "should allow edit" do
		      subject.can?(:edit,@damsAssembledCollectionRci).should be_true
		    end
		    it "should allow to update" do
		      subject.can?(:update,@damsAssembledCollectionRci).should be_true
		    end
	    end
	    
	    describe "to access a DamsUnit" do
	       before do
		      @damsUnit = mod_dams_unit "ac00000300"
		    end
		    it "should allow to show" do
		      subject.can?(:show,@damsUnit).should be_true
		    end
		    it "should allow to create" do
		      subject.can?(:create,@damsUnit).should be_true
		    end
		    it "should allow edit" do
		      subject.can?(:edit,@damsUnit).should be_true
		    end
		    it "should allow to update" do
		      subject.can?(:update,@damsUnit).should be_true
		    end
		end
	    describe "to access a DamsCopyright" do
	        before do
	        	@damsCopyright = mod_dams_copyright "ac00000301"
		    end
		    it "should allow to show" do
		      subject.can?(:show,@damsCopyright).should be_true
		    end
		    it "should allow to create" do
		      subject.can?(:create,@damsCopyright).should be_true
		    end
		    it "should allow edit" do
		      subject.can?(:edit,@damsCopyright).should be_true
		    end
		    it "should allow to update" do
		      subject.can?(:update,@damsCopyright).should be_true
		    end
		end
		
	    describe "to access a MadsName" do
	        before do
			  @madsName = mod_mads_name "ac00000400"
		    end
		    it "should allow to show" do
		      subject.can?(:show,@madsName).should be_true
		    end
		    it "should allow to create" do
		      subject.can?(:create,@madsName).should be_true
		    end
		    it "should allow edit" do
		      subject.can?(:edit,@madsName).should be_true
		    end
		    it "should allow to update" do
		      subject.can?(:update,@madsName).should be_true
		    end
		end		
	    describe "to access a MadsPersonalName" do
	        before do
			  @madsPersonalName = mod_mads_personal_name "ac00000401"
		    end
		    it "should allow to show" do
		      subject.can?(:show,@madsPersonalName).should be_true
		    end
		    it "should allow to create" do
		      subject.can?(:create,@madsPersonalName).should be_true
		    end
		    it "should allow edit" do
		      subject.can?(:edit,@madsPersonalName).should be_true
		    end
		    it "should allow to update" do
		      subject.can?(:update,@madsPersonalName).should be_true
		    end
		end
	    describe "to access a MadsTopic" do
	        before do
			  @madsTopic = mod_mads_topic "ac00000402"
		    end
		    it "should allow to show" do
		      subject.can?(:show,@madsTopic).should be_true
		    end
		    it "should allow to create" do
		      subject.can?(:create,@madsTopic).should be_true
		    end
		    it "should allow edit" do
		      subject.can?(:edit,@madsTopic).should be_true
		    end
		    it "should allow to update" do
		      subject.can?(:update,@madsTopic).should be_true
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
    
    describe "with a dams-curator (dlp curator) role" do
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
    		before do
		      # RCI unit: bb48484848
		      @damsObjectRci = mod_dams_object "ac00000101", "bb48484848"
		    end
    		it "should not allow to show" do
		      subject.can?(:show,@damsObjectRci).should be_false
		    end
		    it "should not allow to create" do
		      subject.can?(:create,@damsObjectRci).should be_false
		    end
		    it "should not allow to edit" do
		      subject.can?(:edit,@damsObjectRci).should be_false
		    end
		    it "should not allow to update" do
		      subject.can?(:update,@damsObjectRci).should be_false
		    end
    	end
    	describe "to access a dlp DamsObject" do
    		before do
		      # DLP unit: bb02020202
		      @damsObjectDlp = mod_dams_object "ac00000100", "bb02020202"
		    end
		    it "should allow to show" do
		      subject.can?(:show,@damsObjectDlp).should be_true
		    end
		    it "should allow to create" do
		      subject.can?(:create,@damsObjectDlp).should be_true
		    end
		    it "should allow to edit" do
		      subject.can?(:edit,@damsObjectDlp).should be_true
		    end
		    it "should allow to update" do
		      subject.can?(:update,@damsObjectDlp).should be_true
		    end
	    end
	    
	    describe "to access a rci DamsProvenanceCollection" do
	    	before do
		      # RCI unit: bb48484848
			  @damsProvenanceCollectionRci = mod_dams_provenance_collection "ac00000201", "bb48484848"
		    end
	    	pending "should not allow to show record ac00000201" do
		      subject.can?(:show,@damsProvenanceCollectionRci).should be_false
		    end
		    it "should not allow to create" do
		      subject.can?(:create,@damsProvenanceCollectionRci).should be_false
		    end
		    it "should not allow to edit" do
		      subject.can?(:edit,@damsProvenanceCollectionRci).should be_false
		    end
		    it "should not allow to update" do
		      subject.can?(:update,@damsProvenanceCollectionRci).should be_false
		    end
    	end
    	
    	describe "to access a rci DamsProvenanceCollectionPart" do
    		before do
		      # RCI unit: bb48484848
			  @damsProvenanceCollectionPartRci = mod_dams_provenance_collection_part "ac00000203", "bb48484848"
		    end
		    pending "should not allow to show record ac00000203" do
		      subject.can?(:show,@damsProvenanceCollectionPartRci).should be_false
		    end
		    it "should not allow to create" do
		      subject.can?(:create,@damsProvenanceCollectionPartRci).should be_false
		    end
		    it "should not allow to edit" do
		      subject.can?(:edit,@damsProvenanceCollectionPartRci).should be_false
		    end
		    it "should not allow to update" do
		      subject.can?(:update,@damsProvenanceCollectionPartRci).should be_false
		    end
    	end
    	
    	describe "to access a rci DamsAssembledCollection" do
    		before do
		      # RCI unit: bb48484848
			  @damsAssembledCollectionRci = mod_dams_assembled_collection "ac00000205", "bb48484848"
		    end
		    pending "should not allow to show record ac00000205" do
		      subject.can?(:show,@damsAssembledCollectionRci).should be_false
		    end
		    it "should not allow to create" do
		      subject.can?(:create,@damsAssembledCollectionRci).should be_false
		    end
		    it "should not allow to edit" do
		      subject.can?(:edit,@damsAssembledCollectionRci).should be_false
		    end
		    it "should not allow to update" do
		      subject.can?(:update,@damsAssembledCollectionRci).should be_false
		    end
    	end
    	
    	describe "to access a dlp DamsProvenanceCollection" do
    		before do
		      # DLP unit: bb02020202
			  @damsProvenanceCollectionDlp = mod_dams_provenance_collection "ac00000200", "bb02020202"
		    end
		    it "should allow to show" do
		      subject.can?(:show,@damsProvenanceCollectionDlp).should be_true
		    end
		    it "should allow to create" do
		      subject.can?(:create,@damsProvenanceCollectionDlp).should be_true
		    end
		    it "should allow edit" do
		      subject.can?(:edit,@damsProvenanceCollectionDlp).should be_true
		    end
		    it "should allow to update" do
		      subject.can?(:update,@damsProvenanceCollectionDlp).should be_true
		    end
	    end
	    
	    describe "to access a dlp DamsProvenanceCollectionPart" do
	    	before do
		      # DLP unit: bb02020202
			  @damsProvenanceCollectionPartDlp = mod_dams_provenance_collection_part "ac00000204", "bb02020202"
		    end
		    it "should allow to show" do
		      subject.can?(:show,@damsProvenanceCollectionPartDlp).should be_true
		    end
		    it "should allow to create" do
		      subject.can?(:create,@damsProvenanceCollectionPartDlp).should be_true
		    end
		    it "should allow edit" do
		      subject.can?(:edit,@damsProvenanceCollectionPartDlp).should be_true
		    end
		    it "should allow to update" do
		      subject.can?(:update,@damsProvenanceCollectionPartDlp).should be_true
		    end
	    end
	    
    	describe "to access a dlp DamsAssembledCollection" do
    	    before do
		      # DLP unit: bb02020202
			  @damsAssembledCollectionDlp = mod_dams_assembled_collection "ac00000204", "bb02020202"
		    end
		    it "should allow to show" do
		      subject.can?(:show,@damsAssembledCollectionDlp).should be_true
		    end
		    it "should allow to create" do
		      subject.can?(:create,@damsAssembledCollectionDlp).should be_true
		    end
		    it "should allow edit" do
		      subject.can?(:edit,@damsAssembledCollectionDlp).should be_true
		    end
		    it "should allow to update" do
		      subject.can?(:update,@damsAssembledCollectionDlp).should be_true
		    end
	    end
	    
	    describe "to access a DamsUnit" do
	        before do
		      @damsUnit = mod_dams_unit "ac00000300"
		    end
		    it "should allow to show" do
		      subject.can?(:show,@damsUnit).should be_true
		    end
		    it "should not allow to create" do
		      subject.can?(:create,@damsUnit).should be_false
		    end
		    it "should not allow edit" do
		      subject.can?(:edit,@damsUnit).should be_false
		    end
		    it "should not allow to update" do
		      subject.can?(:update,@damsUnit).should be_false
		    end
	    end
	    describe "to access a DamsCopyright" do
	        before do
	        	@damsCopyright = mod_dams_copyright "ac00000301"
		    end
		    it "should allow to show" do
		      subject.can?(:show,@damsCopyright).should be_true
		    end
		    it "should not allow to create" do
		      subject.can?(:create,@damsCopyright).should be_false
		    end
		    it "should not allow edit" do
		      subject.can?(:edit,@damsCopyright).should be_false
		    end
		    it "should not allow to update" do
		      subject.can?(:update,@damsCopyright).should be_false
		    end
		end
		
		describe "to access a MadsName" do
		    before do
			  @madsName = mod_mads_name "ac00000400"
		    end
		    it "should allow to show" do
		      subject.can?(:show,@madsName).should be_true
		    end
		    it "should not allow to create" do
		      subject.can?(:create,@madsName).should be_false
		    end
		    pending "should not allow edit record ac00000400" do
		      subject.can?(:edit,@madsName).should be_false
		    end
		    pending "should not allow to update record ac00000400" do
		      subject.can?(:update,@madsName).should be_false
		    end
		end	    
		describe "to access a MadsPersonalName" do
		    before do
			  @madsPersonalName = mod_mads_personal_name "ac00000401"
		    end
		    it "should allow to show" do
		      subject.can?(:show,@madsPersonalName).should be_true
		    end
		    it "should not allow to create" do
		      subject.can?(:create,@madsPersonalName).should be_false
		    end
		    pending "should not allow edit record ac00000401" do
		      subject.can?(:edit,@madsPersonalName).should be_false
		    end
		    pending "should not allow to update record ac00000401" do
		      subject.can?(:update,@madsPersonalName).should be_false
		    end
		end
	    describe "to access a MadsTopic" do
	        before do
			  @madsTopic = mod_mads_topic "ac00000402"
		    end	    
		    it "should allow to show" do
		      subject.can?(:show,@madsTopic).should be_true
		    end
		    it "should not allow to create" do
		      subject.can?(:create,@madsTopic).should be_false
		    end
		    pending "should not allow edit record ac00000402" do
		      subject.can?(:edit,@madsTopic).should be_false
		    end
		    pending "should not allow to update record ac00000402" do
		      subject.can?(:update,@madsTopic).should be_false
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
    
    describe "with a dams-rci (rci curator) role" do
    	subject do
	      @user = User.create!
	  	  @user_groups = @user.groups
	      logger.debug("[CANCAN rspec user roles default: #{@user.groups.inspect}]")	    
	      @bak_user_groups = [];
	      @user_groups.each do |g|
	      	@bak_user_groups << g
	      end
	      @user.groups.clear
	      @user.groups << "dams-rci"
	      Ability.new(@user)
	    end  
	    
    	describe "to access a rci DamsObject" do
    	    before do
		      # RCI unit: bb48484848
		      @damsObjectRci = mod_dams_object "ac00000101", "bb48484848" 
		      solr_index "bb48484848"
		    end
    		it "should allow to show" do
		      subject.can?(:show,@damsObjectRci).should be_true
		    end
		    it "should allow to create" do
		      subject.can?(:create,@damsObjectRci).should be_true
		    end
		    it "should allow to edit" do
		      subject.can?(:edit,@damsObjectRci).should be_true
		    end
		    it "should allow to update" do
		      subject.can?(:update,@damsObjectRci).should be_true
		    end
    	end
    	describe "to access a dlp DamsObject" do
    		before do
		      # DLP unit: bb02020202
		      @damsObjectDlp = mod_dams_object "ac00000100", "bb02020202" 
		    end
		    it "should not allow to show" do
		      subject.can?(:show,@damsObjectDlp).should be_false
		    end
		    it "should not allow to create" do
		      subject.can?(:create,@damsObjectDlp).should be_false
		    end
		    it "should not allow to edit" do
		      subject.can?(:edit,@damsObjectDlp).should be_false
		    end
		    it "should not allow to update" do
		      subject.can?(:update,@damsObjectDlp).should be_false
		    end
	    end
	    
	    describe "to access a rci DamsProvenanceCollection" do
	    	before do
		      # RCI unit: bb48484848
			  @damsProvenanceCollectionRci = mod_dams_provenance_collection "ac00000201", "bb48484848"
		    end
	    	it "should allow to show" do
		      subject.can?(:show,@damsProvenanceCollectionRci).should be_true
		    end
		    it "should allow to create" do
		      subject.can?(:create,@damsProvenanceCollectionRci).should be_true
		    end
		    it "should allow to edit" do
		      subject.can?(:edit,@damsProvenanceCollectionRci).should be_true
		    end
		    it "should allow to update" do
		      subject.can?(:update,@damsProvenanceCollectionRci).should be_true
		    end
    	end
    	
    	describe "to access a rci DamsProvenanceCollectionPart" do
    		before do
		      # RCI unit: bb48484848
			  @damsProvenanceCollectionPartRci = mod_dams_provenance_collection_part "ac00000203", "bb48484848"
		    end
		   it "should allow to show" do
		      subject.can?(:show,@damsProvenanceCollectionPartRci).should be_true
		    end
		    it "should allow to create" do
		      subject.can?(:create,@damsProvenanceCollectionPartRci).should be_true
		    end
		    it "should allow to edit" do
		      subject.can?(:edit,@damsProvenanceCollectionPartRci).should be_true
		    end
		    it "should allow to update" do
		      subject.can?(:update,@damsProvenanceCollectionPartRci).should be_true
		    end
    	end
    	
    	describe "to access a rci DamsAssembledCollection" do
    		before do
		      # RCI unit: bb48484848
			  @damsAssembledCollectionRci = mod_dams_assembled_collection "ac00000205", "bb48484848"
		    end
		    it "should allow to show" do
		      subject.can?(:show,@damsAssembledCollectionRci).should be_true
		    end
		    it "should allow to create" do
		      subject.can?(:create,@damsAssembledCollectionRci).should be_true
		    end
		    it "should allow to edit" do
		      subject.can?(:edit,@damsAssembledCollectionRci).should be_true
		    end
		    it "should allow to update" do
		      subject.can?(:update,@damsAssembledCollectionRci).should be_true
		    end
    	end
    	
    	describe "to access a dlp DamsProvenanceCollection" do
    	    before do
		      # DLP unit: bb02020202
			  @damsAssembledCollectionDlp = mod_dams_assembled_collection "ac00000204", "bb02020202"
		    end
    		before do
		      # DLP unit: bb02020202
			  @damsProvenanceCollectionDlp = mod_dams_provenance_collection "ac00000200", "bb02020202"
		    end
		    it "should not allow to show" do
		      subject.can?(:show,@damsProvenanceCollectionDlp).should be_false
		    end
		    it "should not allow to create" do
		      subject.can?(:create,@damsProvenanceCollectionDlp).should be_false
		    end
		    it "should not allow edit" do
		      subject.can?(:edit,@damsProvenanceCollectionDlp).should be_false
		    end
		    it "should not allow to update" do
		      subject.can?(:update,@damsProvenanceCollectionDlp).should be_false
		    end
	    end
	    
	    describe "to access a dlp DamsProvenanceCollectionPart" do
	    	before do
		      # DLP unit: bb02020202
			  @damsProvenanceCollectionPartDlp = mod_dams_provenance_collection_part "ac00000204", "bb02020202"
		    end
		    it "should not allow to show" do
		      subject.can?(:show,@damsProvenanceCollectionPartDlp).should be_false
		    end
		    it "should not allow to create" do
		      subject.can?(:create,@damsProvenanceCollectionPartDlp).should be_false
		    end
		    it "should not allow edit" do
		      subject.can?(:edit,@damsProvenanceCollectionPartDlp).should be_false
		    end
		    it "should not allow to update" do
		      subject.can?(:update,@damsProvenanceCollectionPartDlp).should be_false
		    end
	    end
	    
    	describe "to access a dlp DamsAssembledCollection" do
    	    before do
		      # DLP unit: bb02020202
			  @damsAssembledCollectionDlp = mod_dams_assembled_collection "ac00000204", "bb02020202"
		    end
		    it "should not allow to show" do
		      subject.can?(:show,@damsAssembledCollectionDlp).should be_false
		    end
		    it "should not allow to create" do
		      subject.can?(:create,@damsAssembledCollectionDlp).should be_false
		    end
		    it "should not allow edit" do
		      subject.can?(:edit,@damsAssembledCollectionDlp).should be_false
		    end
		    it "should not allow to update" do
		      subject.can?(:update,@damsAssembledCollectionDlp).should be_false
		    end
	    end
	    
	    describe "to access a DamsUnit" do
	       before do
		      @damsUnit = mod_dams_unit "ac00000300"
		    end
		    it "should allow to show" do
		      subject.can?(:show,@damsUnit).should be_true
		    end
		    it "should not allow to create" do
		      subject.can?(:create,@damsUnit).should be_false
		    end
		    it "should not allow edit" do
		      subject.can?(:edit,@damsUnit).should be_false
		    end
		    it "should not allow to update" do
		      subject.can?(:update,@damsUnit).should be_false
		    end
	    end
	    describe "to access a DamsCopyright" do
	        before do
	        	@damsCopyright = mod_dams_copyright "ac00000301"
		    end
		    it "should allow to show" do
		      subject.can?(:show,@damsCopyright).should be_true
		    end
		    it "should not allow to create" do
		      subject.can?(:create,@damsCopyright).should be_false
		    end
		    it "should not allow edit" do
		      subject.can?(:edit,@damsCopyright).should be_false
		    end
		    it "should not allow to update" do
		      subject.can?(:update,@damsCopyright).should be_false
		    end
		end
		
		describe "to access a MadsName" do
		    before do
			  @madsName = mod_mads_name "ac00000400"
		    end
		    it "should allow to show" do
		      subject.can?(:show,@madsName).should be_true
		    end
		    it "should not allow to create" do
		      subject.can?(:create,@madsName).should be_false
		    end
		    it "should not allow edit" do
		      subject.can?(:edit,@madsName).should be_false
		    end
		    it "should not allow to update" do
		      subject.can?(:update,@madsName).should be_false
		    end
		end	    
		describe "to access a MadsPersonalName" do
		    before do
			  @madsPersonalName = mod_mads_personal_name "ac00000401"
		    end
		    it "should allow to show" do
		      subject.can?(:show,@madsPersonalName).should be_true
		    end
		    it "should not allow to create" do
		      subject.can?(:create,@madsPersonalName).should be_false
		    end
		    it "should not allow edit" do
		      subject.can?(:edit,@madsPersonalName).should be_false
		    end
		    it "should not allow to update" do
		      subject.can?(:update,@madsPersonalName).should be_false
		    end
		end
	    describe "to access a MadsTopic" do
	    	before do
			  @madsTopic = mod_mads_topic "ac00000402"
		    end
		    it "should allow to show" do
		      subject.can?(:show,@madsTopic).should be_true
		    end
		    it "should not allow to create" do
		      subject.can?(:create,@madsTopic).should be_false
		    end
		    it "should not allow edit" do
		      subject.can?(:edit,@madsTopic).should be_false
		    end
		    it "should not allow to update" do
		      subject.can?(:update,@madsTopic).should be_false
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
    	    before do
		      # RCI unit: bb48484848
		      @damsObjectRci = mod_dams_object "ac00000101", "bb48484848" 
		    end
    		it "should not allow to show" do
		      subject.can?(:show,@damsObjectRci).should be_false
		    end
		    it "should not allow to create" do
		      subject.can?(:create,@damsObjectRci).should be_false
		    end
		    it "should not allow to edit" do
		      subject.can?(:edit,@damsObjectRci).should be_false
		    end
		    it "should not allow to update" do
		      subject.can?(:update,@damsObjectRci).should be_false
		    end
    	end
    	describe "to access a dlp DamsObject" do
    		before do
		      # DLP unit: bb02020202
		      @damsObjectDlp = mod_dams_object "ac00000100", "bb02020202" 
		    end
		    it "should not allow to show" do
		      subject.can?(:show,@damsObjectDlp).should be_false
		    end
		    it "should not allow to create" do
		      subject.can?(:create,@damsObjectDlp).should be_false
		    end
		    it "should not allow to edit" do
		      subject.can?(:edit,@damsObjectDlp).should be_false
		    end
		    it "should not allow to update" do
		      subject.can?(:update,@damsObjectDlp).should be_false
		    end
	    end
	    
	    describe "to access a rci DamsProvenanceCollection" do
	    	before do
		      # RCI unit: bb48484848
			  @damsProvenanceCollectionRci = mod_dams_provenance_collection "ac00000201", "bb48484848"
		    end
		    it "should not allow to show" do
		      subject.can?(:show,@damsProvenanceCollectionRci).should be_false
		    end
		    it "should not allow to create" do
		      subject.can?(:create,@damsProvenanceCollectionRci).should be_false
		    end
		    it "should not allow to edit" do
		      subject.can?(:edit,@damsProvenanceCollectionRci).should be_false
		    end
		    it "should not allow to update" do
		      subject.can?(:update,@damsProvenanceCollectionRci).should be_false
		    end
    	end
    	
    	describe "to access a rci DamsProvenanceCollectionPart" do
    		before do
		      # RCI unit: bb48484848
			  @damsProvenanceCollectionPartRci = mod_dams_provenance_collection_part "ac00000203", "bb48484848"
		    end
		    it "should not allow to show" do
		      subject.can?(:show,@damsProvenanceCollectionPartRci).should be_false
		    end
		    it "should not allow to create" do
		      subject.can?(:create,@damsProvenanceCollectionPartRci).should be_false
		    end
		    it "should not allow to edit" do
		      subject.can?(:edit,@damsProvenanceCollectionPartRci).should be_false
		    end
		    it "should not allow to update" do
		      subject.can?(:update,@damsProvenanceCollectionPartRci).should be_false
		    end
    	end
    	
    	describe "to access a rci DamsAssembledCollection" do
    		before do
		      # RCI unit: bb48484848
			  @damsAssembledCollectionRci = mod_dams_assembled_collection "ac00000205", "bb48484848"
		    end
    		it "should not allow to show" do
		      subject.can?(:show,@damsAssembledCollectionRci).should be_false
		    end
		    it "should not allow to create" do
		      subject.can?(:create,@damsAssembledCollectionRci).should be_false
		    end
		    it "should not allow to edit" do
		      subject.can?(:edit,@damsAssembledCollectionRci).should be_false
		    end
		    it "should not allow to update" do
		      subject.can?(:update,@damsAssembledCollectionRci).should be_false
		    end
    	end
    	
    	describe "to access a dlp DamsProvenanceCollection" do
    		before do
		      # DLP unit: bb02020202
			  @damsProvenanceCollectionDlp = mod_dams_provenance_collection "ac00000200", "bb02020202"
		    end
		    it "should not allow to show" do
		      subject.can?(:show,@damsProvenanceCollectionDlp).should be_false
		    end
		    it "should not allow to create" do
		      subject.can?(:create,@damsProvenanceCollectionDlp).should be_false
		    end
		    it "should not allow edit" do
		      subject.can?(:edit,@damsProvenanceCollectionDlp).should be_false
		    end
		    it "should not allow to update" do
		      subject.can?(:update,@damsProvenanceCollectionDlp).should be_false
		    end
	    end
	    
	    describe "to access a dlp DamsProvenanceCollectionPart" do
	    	before do
		      # DLP unit: bb02020202
			  @damsProvenanceCollectionPartDlp = mod_dams_provenance_collection_part "ac00000204", "bb02020202"
		    end
		    it "should not allow to show" do
		      subject.can?(:show,@damsProvenanceCollectionPartDlp).should be_false
		    end
		    it "should not allow to create" do
		      subject.can?(:create,@damsProvenanceCollectionPartDlp).should be_false
		    end
		    it "should not allow edit" do
		      subject.can?(:edit,@damsProvenanceCollectionPartDlp).should be_false
		    end
		    it "should not allow to update" do
		      subject.can?(:update,@damsProvenanceCollectionPartDlp).should be_false
		    end
	    end
	    
    	describe "to access a dlp DamsAssembledCollection" do
    	    before do
		      # DLP unit: bb02020202
			  @damsAssembledCollectionDlp = mod_dams_assembled_collection "ac00000204", "bb02020202"
		    end
		    it "should not allow to show" do
		      subject.can?(:show,@damsAssembledCollectionDlp).should be_false
		    end
		    it "should not allow to create" do
		      subject.can?(:create,@damsAssembledCollectionDlp).should be_false
		    end
		    it "should not allow edit" do
		      subject.can?(:edit,@damsAssembledCollectionDlp).should be_false
		    end
		    it "should not allow to update" do
		      subject.can?(:update,@damsAssembledCollectionDlp).should be_false
		    end
	    end
	    
	    describe "to access a DamsUnit" do
	       before do
		      @damsUnit = mod_dams_unit "ac00000300"
		    end
		    it "should allow to show" do
		      subject.can?(:show,@damsUnit).should be_true
		    end
		    it "should not allow to create" do
		      subject.can?(:create,@damsUnit).should be_false
		    end
		    it "should not allow edit" do
		      subject.can?(:edit,@damsUnit).should be_false
		    end
		    it "should not allow to update" do
		      subject.can?(:update,@damsUnit).should be_false
		    end
		end
	    describe "to access a DamsCopyright" do
	        before do
	        	@damsCopyright = mod_dams_copyright "ac00000301"
		    end
		    it "should allow to show" do
		      subject.can?(:show,@damsCopyright).should be_true
		    end
		    it "should not allow to create" do
		      subject.can?(:create,@damsCopyright).should be_false
		    end
		    it "should not allow edit" do
		      subject.can?(:edit,@damsCopyright).should be_false
		    end
		    it "should not allow to update" do
		      subject.can?(:update,@damsCopyright).should be_false
		    end
		end		

		describe "to access a MadsName" do
		    before do
			  @madsName = mod_mads_name "ac00000400"
		    end
		    it "should allow to show" do
		      subject.can?(:show,@madsName).should be_true
		    end
		    it "should not allow to create" do
		      subject.can?(:create,@madsName).should be_false
		    end
		    it "should not allow edit" do
		      subject.can?(:edit,@madsName).should be_false
		    end
		    it "should not allow to update" do
		      subject.can?(:update,@madsName).should be_false
		    end
		end
		describe "to access a MadsPersonalName" do
		    before do
			  @madsPersonalName = mod_mads_personal_name "ac00000401"
		    end
		    it "should allow to show" do
		      subject.can?(:show,@madsPersonalName).should be_true
		    end
		    it "should not allow to create" do
		      subject.can?(:create,@madsPersonalName).should be_false
		    end
		    it "should not allow edit" do
		      subject.can?(:edit,@madsPersonalName).should be_false
		    end
		    it "should not allow to update" do
		      subject.can?(:update,@madsPersonalName).should be_false
		    end
		end
	    describe "to access a MadsTopic" do
	    	before do
			  @madsTopic = mod_mads_topic "ac00000402"
		    end
		    it "should allow to show" do
		      subject.can?(:show,@madsTopic).should be_true
		    end
		    it "should not allow to create" do
		      subject.can?(:create,@madsTopic).should be_false
		    end
		    it "should not allow edit" do
		      subject.can?(:edit,@madsTopic).should be_false
		    end
		    it "should not allow to update" do
		      subject.can?(:update,@madsTopic).should be_false
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
