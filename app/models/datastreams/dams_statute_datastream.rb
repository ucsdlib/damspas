class DamsStatuteDatastream < ActiveFedora::RdfxmlRDFDatastream
  include DamsHelper
  include Dams::DamsStatute
end
