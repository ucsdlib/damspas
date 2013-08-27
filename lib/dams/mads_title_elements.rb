module Dams
  module MadsTitleElements
    # = MADS Title Element and subclasses
    class MadsNonSortElement
      include Dams::MadsElement
      rdf_type MADS.NonSortElement
    end
    class MadsMainTitleElement
      include Dams::MadsElement
      rdf_type MADS.MainTitleElement
    end
    class MadsPartNameElement
      include Dams::MadsElement
      rdf_type MADS.PartNameElement
    end
    class MadsPartNumberElement
      include Dams::MadsElement
      rdf_type MADS.PartNumberElement
    end
    class MadsSubTitleElement
      include Dams::MadsElement
      rdf_type MADS.SubTitleElement
    end
  end
end
