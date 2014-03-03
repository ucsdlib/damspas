module Dams
  module MadsNameElements
    # = MADS Name Element and subclasses
    class MadsNameElement < ActiveFedora::Rdf::Resource
      include Dams::MadsElement
      rdf_type MADS.NameElement
    end
    class MadsDateNameElement < ActiveFedora::Rdf::Resource
      include Dams::MadsElement
      rdf_type MADS.DateNameElement
    end
    class MadsFamilyNameElement < ActiveFedora::Rdf::Resource
      include Dams::MadsElement
      rdf_type MADS.FamilyNameElement
    end
    class MadsFullNameElement < ActiveFedora::Rdf::Resource
      include Dams::MadsElement
      rdf_type MADS.FullNameElement
    end
    class MadsGivenNameElement < ActiveFedora::Rdf::Resource
      include Dams::MadsElement
      rdf_type MADS.GivenNameElement
    end
    class MadsTermsOfAddressNameElement < ActiveFedora::Rdf::Resource
      include Dams::MadsElement
      rdf_type MADS.TermsOfAddressNameElement
    end
  end
end
