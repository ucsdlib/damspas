require 'spec_helper'
require 'rack/test'

describe "complex object view" do
  before do
    @damsComplexObj = DamsObject.create!(pid: "xx97626129", titleValue: "PPTU04WT-027D (dredge, rock)")
  end
  after do
    @damsComplexObj.delete
  end
  it "should see the component hierarchy view" do
    @damsComplexObj.damsMetadata.content = File.new('spec/fixtures/damsComplexObject3.rdf.xml').read
    @damsComplexObj.save!
    solr_index (@damsComplexObj.pid)
    sign_in_developer
    visit dams_object_path(@damsComplexObj.pid)
    expect(page).to have_selector('h1:first',:text=>'PPTU04WT-027D (dredge, rock)')
    expect(page).to have_selector('h1[1]',:text=>'Interval 1 (dredge, rock)')
    expect(page).to have_selector('button#node-btn-1',:text => 'Interval 1 (dredge, rock)')
    expect(page).to have_selector('button#node-btn-2',:text => 'Files')
    
    #click on grand child link
    click_on 'Image 001'
    expect(page).to have_selector('h1:first',:text=>'PPTU04WT-027D (dredge, rock)')
    expect(page).to have_selector('h1[1]',:text=>'Image 001')
        
    #return to the top level record
    click_on 'Components of "PPTU04WT-027D (dredge, rock)"'
    expect(page).to have_selector('h1:first',:text=>'PPTU04WT-027D (dredge, rock)')
    expect(page).to have_selector('h1[1]',:text=>'Interval 1 (dredge, rock)')         
  end     
end