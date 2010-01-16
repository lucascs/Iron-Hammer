require File.dirname(__FILE__) + '/../helpers/spec_helper.rb'

describe Configuration do
  it 'should provide a method to list the configurations contained on a specfic directory' do
    Configuration::should respond_to(:list)
  end
  
  it 'should raise an error if there is a tentative to list the configurations given no path' do
    lambda { Configuration::list }.should raise_error(ArgumentError)
  end

  describe 'given no specific environment' do
    it 'should be able to list configuration files for a given path' do
      Dir.should_receive('[]').with(File.join(path = '/work/proj/' , Configuration::FILE_PATTERN)).
        and_return(paths = ['/work/proj/file1.config', '/work/proj/file2.config.xml'])

      conf = Configuration::list :path => path
      conf.should be_an_instance_of(Array)
      conf.should have(2).deliverables
      paths.each do |p|
        (conf.select do |d| 
          d.actual_path == path && 
          d.path_on_package == '' && 
          d.name_on_package == (f = p.split('/').last) && 
          d.actual_name == f
        end).should have(1).matching_element
      end
    end
  end
  
  describe 'given a specific environment' do
    it 'should be able to list configuration files for a given path (changing their names)' do
      Dir.should_receive('[]').with(File.join(path = '/work/proj/' , Configuration::FILE_PATTERN + '.production')).
        and_return(paths = ['/work/proj/file1.config.production', '/work/proj/file2.config.xml.production'])

      conf = Configuration::list :path => path, :environment => 'production'
      conf.should be_an_instance_of(Array)
      conf.should have(2).deliverables
      paths.each do |p|
        (conf.select do |d| 
          d.actual_path == path && 
          d.path_on_package == '' && 
          d.actual_name == (f = p.split('/').last) &&
          d.name_on_package == f.sub('.production', '')
        end).should have(1).matching_element
      end
    end
  end
end 
