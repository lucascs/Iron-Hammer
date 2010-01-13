require File.dirname(__FILE__) + '/../helpers/spec_helper.rb'

describe Anvil, ' - full stack integration'  do
  describe 'loading a solution from a path' do
    it 'should properly load the information about the projects in it' do
      TempHelper::cleanup
      solution_root = SolutionData::all_kinds_of_projects_to_temp_dir
      solution_name = 'MACSkeptic.Iron.Hammer.All.Kinds.Of.Projects'  
      anvil = Anvil.load_solution_from *(solution_root.split('/'))
    end
  end  
end
