class DamsStatuteDatastream < ActiveFedora::RdfxmlRDFDatastream
  include Dams::DamsHelper
  include Dams::DamsStatute
end
