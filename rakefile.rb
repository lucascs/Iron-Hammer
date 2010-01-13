namespace 'spec' do
  desc 'runs the unit test suite'
  task :unit do
    sh 'spec -c -f o specs'
  end

  desc 'runs the integration test suite'
  task :integration do
    sh 'spec -c -f n integration_specs'
  end

  desc 'runs all test suites'
  task :all => [:unit, :integration]
end

