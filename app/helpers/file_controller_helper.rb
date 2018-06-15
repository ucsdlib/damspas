# Helper methods for the File controller
module FileControllerHelper
  # Construct a relative filepath for send_file's use of nginx
  # An expected path would be like the following:
  # Given source_path is /pub/data2/dams/localStore/bb/37/89/62/8p
  # Given source_filename is 20775-bb3789628p-0-4.jpg
  # Given Rails.root is /full/app/path
  # Then return value is: /full/app/path/localStore/20775-bb3789628p-0-4.jpg
  def localstore_filename(source_path, source_filename)
    String(Rails.root) + '/' + source_path.split('dams/')[1] + '/' + source_filename
  end
  # Determine http content type for a file download
  # We have added our own localized logic when a mimeType doesn't exist, such as checking the filename suffix for xml
  # files. This ideally should not be necessary.
  def http_content_type(datastream, filename)
    return 'application/octet-stream' unless datastream && filename

    if datastream.mimeType
      datastream.mimeType
    elsif filename.include?('.xml')
      'application/xml'
    else
      'application/octet-stream'
    end
  end
end
