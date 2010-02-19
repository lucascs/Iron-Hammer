
namespace :iron do
  namespace :analyze do
    desc 'Analyzes the code using fxcop'
    task :fxcop do
      sh @hammer.analyze *@anvil.projects do |ok, response|
        puts response
      end
    end
  end
end

