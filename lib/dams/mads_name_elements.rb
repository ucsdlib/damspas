module Dams
  module MadsNameElements
    # = MADS Name Element and subclasses
    class MadsNameElement
      include Dams::MadsElement
      rdf_type MADS.NameElement
    end
    class MadsDateNameElement
      include Dams::MadsElement
      rdf_type MADS.DateNameElement
    end
    class MadsFamilyNameElement
      include Dams::MadsElement
      rdf_type MADS.FamilyNameElement
    end
    class MadsFullNameElement
      include Dams::MadsElement
      rdf_type MADS.FullNameElement
    end
    class MadsGivenNameElement
      include Dams::MadsElement
      rdf_type MADS.GivenNameElement
    end
    class MadsTermsOfAddressNameElement
      include Dams::MadsElement
      rdf_type MADS.TermsOfAddressNameElement
    end
  end
end
