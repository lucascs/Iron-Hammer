require 'builder'

namespace :iron do
  namespace :analyze do
    desc 'Analyzes the code using fxcop'
    task :fxcop do
      sh @hammer.analyze *@anvil.projects do |ok, response|
        puts response
      end
    end

    desc 'Generates test coverage report using Emma syntax'
    task :coverage do
      home = ENV['IRON_HAMMER_HOME']
      raise "You must set IRON_HAMMER_HOME env variable" unless home
      xml = Builder::XmlMarkup.new(:indent => 2, :target => 'build.proj')
      xml.Project :xmlns=>"http://schemas.microsoft.com/developer/msbuild/2003",
                  :DefaultTargets=>"CoverageReport" do
        xml.Import :Project=>"$(MSBuildExtensionsPath)\MSBuildCommunityTasks\MSBuild.Community.Tasks.Targets"
        xml.UsingTask :AssemblyFile => "C:\Teste\CI.MSBuild.Tasks.dll" :TaskName => "CI.MSBuild.Tasks.ConvertVSCoverageToXml"
        xml.PropertyGroup do
          project_dir = File.join(File.expand_path('.')
          compilation_dir = Dir[project_dir,'TestResults', '*')].first
          xml.CompilationDirectory(compilation_dir.gsub('/','\\'))
          xml.HomeDir(home.gsub('/', '\\'))
          xml.ProjectDir(project_dir.gsub('/','\\'))
        end

        xml.Target :Name=>"CoverageReport" do
           xml.ConvertVSCoverageToXml :CoverageFiles=>"$(CompilationDirectory)\In\$(ComputerName)\data.coverage",
                                      :SymbolsDirectory="$(CompilationDirectory)\Out"

           xml.Xslt :Inputs=>"$(ProjectDir)\data.xml",
                    :Xsl=>"$(HomeDir)\mstestcoverage-to-emma.xsl",
                    :Output=>"$(ProjectDir)\coverage.xml"
        end
      end
    end
  end
end

