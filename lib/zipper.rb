require 'zip/zipfilesystem'

module Zipper
  def self.zip_current_working_folder_into_this file
    Zip::ZipFile::open(destination = file, true) do |zip|
      Dir[File.join('**', '*')].each { |source| zip.add(entry = source, source) }
    end
  end
end unless defined? ZipUtils
