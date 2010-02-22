
namespace :iron do
  namespace :test do

    desc 'Runs the unit tests'
    task :unit => [:build] do
      command = @hammer.test *@anvil.unit_test_projects
      puts "There are no unit tests to run" unless command
      sh command if command
    end

    desc 'Runs the integration tests'
    task :integration => [:build] do
      command = @hammer.test *@anvil.test_projects
      puts "There are no integration tests to run" unless command
      sh command if command
    end
  end
end

