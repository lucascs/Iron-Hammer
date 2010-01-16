require 'iron_hammer/projects/project_types'

module IronHammer
  module Projects
    describe ProjectTypes do
      it 'should provide a method to get a guid for a type' do
        ProjectTypes::should respond_to(:guid_for)
      end
      
      it 'should provide a method to get a type from a guid' do
        ProjectTypes::should respond_to(:type_of)
      end
      
      it 'should give the correct type for a asp_net guid' do
        ProjectTypes::type_of('{349C5851-65DF-11DA-9384-00065B846F21}').should be_eql(AspNetProject)
        ProjectTypes::type_of('{349c5851-65dF-11Da-9384-00065b846F21}').should be_eql(AspNetProject)
      end
      
      it 'should give the correct type for a asp_net_mvc guid' do
        ProjectTypes::type_of('{603C0E0B-DB56-11DC-BE95-000D561079B0}').should be_eql(AspNetMvcProject)
        ProjectTypes::type_of('{603C0E0B-db56-11DC-BE95-000D561079B0}').should be_eql(AspNetMvcProject)
      end
      
      it 'should give the correct type for a test guid' do
        ProjectTypes::type_of('{3AC096D0-A1C2-E12C-1390-A8335801FDAB}').should be_eql(TestProject)
        ProjectTypes::type_of('{3AC096D0-a1c2-e12c-1390-A8335801FDAB}').should be_eql(TestProject)
      end
    end
  end
end
