require 'iron_hammer/utils/zipper'

module IronHammer
  module Utils
    describe Zipper do
      before :each do
        TempHelper::cleanup
        @file0  = TempHelper::touch '', 'file0'
        @file1  = TempHelper::touch 'folder1', 'file1'
        @file2  = TempHelper::touch 'folder2', 'file2'
        @file3  = TempHelper::touch 'folder2/folder3', 'file3'
      end
      
      it 'should properly zip the contents of the current working folder' do
        file = 'macskeptic.zip'.inside_temp_dir
        Dir.chdir(TempHelper::TEMP_FOLDER) { Zipper::zip_current_working_folder_into_this file }

        Zip::ZipFile::open(file, true) do |zip| 
          zip.find_entry(@file0).should_not be_nil
          zip.find_entry(@file1).should_not be_nil
          zip.find_entry(@file2).should_not be_nil
          zip.find_entry(@file3).should_not be_nil
        end
      end
    end
  end
end
