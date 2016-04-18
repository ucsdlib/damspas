require 'spec_helper'

describe DamsResourceDatastream do
  subject { DamsResourceDatastream.new }
  describe "date_clean" do
    it "should handle nil dates" do
      expect(subject.clean_date(nil)).to eq('')
    end
    it "should remove non-ISO8601 values" do
      d = "May 24, 1975"
      expect(subject.clean_date(d)).to eq('')
    end
    it "should leave valid ISO8601 dates alone" do
      d1 = "2014-09-19T12:44:00Z"
      expect(subject.clean_date(d1)).to eq(d1)
      d2 = "2014-09-19T12:44:00-0800"
      expect(subject.clean_date(d2)).to eq(d2)
    end
    it "should remove non-ISO8601 content from quasi-ISO8601 values" do
      expect(subject.clean_date("2014-09-19 2:00-3:30pm")).to eq("2014-09-19")
    end
    it "should convert years and year/month dates to ISO8601" do
      expect(subject.clean_date("1999")).to eq("1999-01-01")
      expect(subject.clean_date("1999-01")).to eq("1999-01-01")
    end
  end
end
