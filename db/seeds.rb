# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
if Rails.env.development? || Rails.env.test?
  DamsUnit.delete_all
  DamsCopyright.delete_all
  DamsAssembledCollection.delete_all  
  DamsObject.delete_all
    
  DamsUnit.create!(pid: 'xx11111111', name: 'Test Unit', description: "Test Description", code: "tu", uri: "http://example.com/")

  DamsCopyright.create!(pid: 'xx22222222', status: 'Public domain')
  
  DamsAssembledCollection.create!(pid: 'xx33333333', unitURI: 'xx11111111', titleValue: 'Test Bee Collection', visibility: 'public')
  
  DamsObject.create!(pid: 'xx77777777', unitURI: 'xx11111111', titleValue: 'Test Object 1', copyrightURI: 'xx22222222', assembledCollectionURI: [ 'xx33333333' ])

  @obj = DamsObject.find('xx77777777')
  jpeg_content = '/9j/4AAQSkZJRgABAQEAAQABAAD/2wBDAAMCAgICAgMCAgIDAwMDBAYEBAQEBAgGBgUGCQgKCgkICQkKDA8MCgsOCwkJDRENDg8QEBEQCgwSExIQEw8QEBD/wAALCAABAAEBAREA/8QAFAABAAAAAAAAAAAAAAAAAAAACf/EABQQAQAAAAAAAAAAAAAAAAAAAAD/2gAIAQEAAD8AVN//2Q=='
  @obj.add_file( Base64.decode64(jpeg_content), "_1.jpg", "test.jpg" )
  @obj.save
    
  begin
    solrizer = Solrizer::Fedora::Solrizer.new
    solrizer.solrize 'xx11111111'
    solrizer.solrize 'xx22222222'
    solrizer.solrize 'xx33333333'
    solrizer.solrize 'xx77777777'
  rescue Exception => e
    logger.warn "Error indexing #{e}"
  end
    
end