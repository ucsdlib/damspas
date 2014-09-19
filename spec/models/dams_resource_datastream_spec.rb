require 'spec_helper'

describe DamsResourceDatastream do
  subject { DamsResourceDatastream.new }
  describe "date_clean" do
    it "should handle nil dates" do
      subject.clean_date(nil).should == ''
    end
    it "should leave non-ISO8601 values alone" do
      d = "May 24, 1975"
      subject.clean_date(d).should == d
    end
    it "should leave valid ISO8601 dates alone" do
      d1 = "2014-09-19T12:44:00Z"
      subject.clean_date(d1).should == d1
      d2 = "2014-09-19T12:44:00-0800"
      subject.clean_date(d2).should == d2
    end
    it "should remove non-ISO8601 content from quasi-ISO8601 values" do
      subject.clean_date("2014-09-19 2:00-3:30pm").should == "2014-09-19"
    end
    it "should convert years and year/month dates to ISO8601" do
      subject.clean_date("1999").should == "1999-01-01"
      subject.clean_date("1999-01").should == "1999-01-01"
    end
  end
end
