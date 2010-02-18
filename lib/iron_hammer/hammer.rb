require 'iron_hammer/utils/windows'
require 'iron_hammer/projects/test_project'
require 'iron_hammer/solutions/solution'
require 'iron_hammer/utils/dot_net_environment'

module IronHammer
  class Hammer
    attr_accessor :dot_net_environment
    attr_accessor :configuration

    def initialize params={}
      @configuration  = params[:configuration] || IronHammer::Defaults::CONFIGURATION_RUN
      @dot_net_environment = IronHammer::Utils::DotNetEnvironment.new params.merge(
        :framework_path => params[:dot_net_path])
      @code_analyzers_environment = CodeAnalyzersEnvironment.new params
    end

    def details
      ['duration', 'errorstacktrace', 'errormessage', 'outcometext'].inject('') do |buffer, detail|
        buffer << "/detail:#{detail} "
      end
    end

    def build solution
      msbuild       = @dot_net_environment.msbuild
      configuration = @configuration
      solution      = solution.solution
      "#{msbuild} /p:Configuration=#{configuration} #{solution} /t:Rebuild"
    end

    def test *projects
      return if projects.nil? || projects.empty?
      parent_dir = File.join(projects.first.path || '.', '..')
      config = ['LocalTestRun', 'TestRunConfig'].find do |config_name|
        File.exists?(File.join(parent_dir, "#{config_name}.testrunconfig"))
      end
      runconfig = "/runconfig:#{config}.testrunconfig " if config
      containers = projects.collect{|project| "/testcontainer:#{project.container @configuration}"}
      results   = projects.first.results_file
      mstest    = @dot_net_environment.mstest
      "#{mstest} #{runconfig || ''}#{containers.join ' '} /resultsfile:#{results} #{details}"
    end

    def analyze *projects
      return if projects.nil? || projects.empty?
      fxcop = @code_analyzers_environment.fxcop
      rules = @code_analyzers_environment.fxcop_rules
      binaries = projects.collect do |project|
        project.artifacts.map {|artifact| "/file:#{File.join(project.path_to_binaries, artifact)}"}
      end.flatten
      results = @code_analyzers_environment.fxcop_result
      "\"#{fxcop}\" /rule:\"#{rules}\" /out:\"#{results}\" #{binaries.join ' '}"
    end

  end unless defined? Hammer
end

