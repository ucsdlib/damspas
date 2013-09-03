class DamsLicenseDatastream < ActiveFedora::RdfxmlRDFDatastream
  include DamsHelper
  include Dams::DamsLicense
end
