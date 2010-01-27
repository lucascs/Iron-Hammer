require 'iron_hammer/utils/file_system'

module IronHammer
  module Utils
    describe FileSystem do
      before :each do 
        TempHelper::cleanup
      end
      
      describe 'copying files' do
        before :each do 
          TempHelper::cleanup
        end
        
        it 'should call create_path and cp' do
          File.should_receive('directory?').with('source/file').and_return(false)
          FileSystem::should_receive('create_path!').with('my')
          FileUtils.should_receive(:cp).with('source/file', 'my/destination')
          FileSystem::copy_file! 'source/file', 'my/destination'
        end
        
        it 'should raise an error if the source is a directory' do 
          File.should_receive('directory?').with('source/file').and_return(true)
          lambda { FileSystem::copy_file!('source/file', 'my/destination') }.should raise_error(ArgumentError)
        end
      end
      
      describe 'copying directories' do
        before :each do 
          TempHelper::cleanup
        end
        
        it 'should call cp_r, but not create_path' do
          File.should_receive('directory?').with('source/file').and_return(true)
          FileSystem::should_not_receive('create_path!')
          FileUtils.should_receive(:cp_r).with('source/file', 'my/destination')
          FileSystem::copy_directory! 'source/file', 'my/destination'
        end
        
        it 'should raise an error if the source is not a directory' do 
          File.should_receive('directory?').with('source/file').and_return(false)
          lambda { FileSystem::copy_directory!('source/file', 'my/destination') }.should raise_error(ArgumentError)
        end
      end
      
      describe 'writing files' do
        before :each do 
          TempHelper::cleanup
        end
        
        it 'should call create_path for the path and open a file for writing, writing the content on it' do
          class DummyFile; def write content; end; end
          (file = DummyFile.new).should_receive(:write).with('content')
          FileSystem::should_receive('create_path!').with('path/to')
          File.should_receive(:open).with('path/to/file', 'w').and_yield(file)
          FileSystem::write! :path => 'path/to', :name => 'file', :content => 'content'
        end
      end
      
      describe 'reading files' do
        before :each do 
          TempHelper::cleanup
        end
        
        it 'should call open with r and yield to the file that should be read' do
          class DummyFile; def read; end; end
          (file = DummyFile.new).should_receive(:read).and_return(content = 'the content')
          File.should_receive(:open).with('path/to/file', 'r').and_yield(file)
          FileSystem::read_file('path/to', 'file').should be_eql(content)
        end
      end
      
      describe 'reading file lines' do
        before :each do 
          TempHelper::cleanup
        end
        
        it 'should call open with r and yield to the file that should be read' do
          class DummyFile; def readlines; end; end
          (file = DummyFile.new).should_receive(:readlines).and_return(lines = ['a', 'b', 'c'])
          File.should_receive(:open).with('path/to/file', 'r').and_yield(file)
          FileSystem::read_lines('path/to', 'file').should be_eql(lines)
        end
      end
      
      describe 'creating paths' do
        before :each do 
          TempHelper::cleanup
        end
        
        it 'should call mkpath' do
          FileUtils.should_receive(:mkpath).with('path/to/my/path')
          FileSystem::create_path! 'path', 'to/my', 'path'
        end
      end
    end
  end
end
