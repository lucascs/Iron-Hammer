require 'iron_hammer/projects/asp_net_project'
require 'iron_hammer/projects/asp_net_mvc_project'
require 'iron_hammer/projects/test_project'
require 'iron_hammer/projects/dll_project'

module IronHammer
  module Projects
    module ProjectTypes
      GUIDS = {
        TestProject => '{3AC096D0-A1C2-E12C-1390-A8335801FDAB}',
        AspNetMvcProject => '{603C0E0B-DB56-11DC-BE95-000D561079B0}',
        AspNetProject => '{349C5851-65DF-11DA-9384-00065B846F21}'
      }

      TYPES = GUIDS.inject({}) { |buffer, tuple| buffer.merge(tuple.pop => tuple.first) }
      
      def self.type_of guid
        TYPES[guid.to_s.upcase]
      end
      
      def self.guid_for type
        GUIDS[type]
      end
    end unless defined? ProjectTypes
  end
end
