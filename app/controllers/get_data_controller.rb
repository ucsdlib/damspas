require 'net/http'
require 'json'

class GetDataController < ApplicationController

  def get_linked_data 	
  	#http://localhost:3000/get_data/get_data/get_data?q=dog&fl=suggestall
	uri = URI('http://fast.oclc.org/fastSuggest/select')
    if(!params[:q].nil? && params[:q] != '' && !params[:fl].nil? && params[:fl] != '')		
		#res = Net::HTTP.post_form(uri, 'q' => 'suggestall :cats', 'fl' => 'suggestall', 'wt' => 'json')
		res = Net::HTTP.post_form(uri, 'q' => "#{params[:fl]} :#{params[:q]}", 'fl' => params[:fl], 'wt' => 'json')
		json = JSON.parse(res.body)
		if(json.fetch("response").fetch("numFound") > 0 && json.fetch("response").fetch("numFound") < 1000)
			res = Net::HTTP.post_form(uri, 'q' => "#{params[:fl]} :#{params[:q]}", 'fl' => params[:fl], 'wt' => 'json', 'rows' => json.fetch("response").fetch("numFound"), 'sort' => 'usage desc')
			json = JSON.parse(res.body)		
		elsif(json.fetch("response").fetch("numFound") > 0 && json.fetch("response").fetch("numFound") > 1000)
			res = Net::HTTP.post_form(uri, 'q' => "#{params[:fl]} :#{params[:q]}", 'fl' => params[:fl], 'wt' => 'json', 'rows' => 1000, 'sort' => 'usage desc')
			json = JSON.parse(res.body)							
		end
		@jdoc = json.fetch("response").fetch("docs")
		puts json
		render :layout => false
	else
		res = Net::HTTP.post_form(uri, 'q' => 'suggestall :*', 'fl' => 'suggestall', 'wt' => 'json', 'rows' => 1000)	
		json = JSON.parse(res.body)
		@jdoc = json.fetch("response").fetch("docs")
		render :layout => false
	end
  end

  def get_name 	
  	#http://localhost:3000/get_data/get_name/get_name?q=PersonalName
  	if(!params[:q].nil? && params[:q] != '' && params[:q] == 'CorporateName')
		@names = MadsCorporateName.all( :order=>"system_create_dtsi asc" )
  	elsif(!params[:q].nil? && params[:q] != '' && params[:q] == 'PersonalName')
		@names = MadsPersonalName.all( :order=>"system_create_dtsi asc" )	
  	elsif(!params[:q].nil? && params[:q] != '' && params[:q] == 'Name')
		@names = MadsName.all( :order=>"system_create_dtsi asc" )		
  	elsif(!params[:q].nil? && params[:q] != '' && params[:q] == 'ConferenceName')
		@names = MadsConferenceName.all( :order=>"system_create_dtsi asc" )		
  	elsif(!params[:q].nil? && params[:q] != '' && params[:q] == 'FamilyName')
		@names = MadsFamilyName.all( :order=>"system_create_dtsi asc" )					
	else
		@names = MadsCorporateName.all( :order=>"system_create_dtsi asc" )
	end
	
	render :layout => false
  end
    
  def show
	redirect_to :action => 'get_linked_data'
  end
end
