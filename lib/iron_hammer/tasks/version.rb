class ProjectVersion
  include Comparable

	attr_accessor :major
	attr_accessor :minor
	attr_accessor :revision
	attr_accessor :build

	def self.parse v
		splitted = v.split '.'
		version = ProjectVersion.new
		version.major = splitted[0].to_i
		version.minor = splitted[1].to_i
		version.revision = splitted[2].to_i
		version.build = splitted[3].to_i
		version
	end

	def <=> other
	  return @major <=> other.major unless @major == other.major
	  return @minor <=> other.minor unless @minor == other.minor
	  return @revision <=> other.revision unless @revision == other.revision
	  return @build <=> other.build
	end

	def self.greatest_from projects
	  greatest = parse '1.0.0.0'
    projects.each do |project|
      current = parse project.version
      greatest = current if current > greatest
    end
    greatest
	end

	def to_s
		"#{@major}.#{@minor}.#{@revision}.#{@build}"
	end
end

namespace :iron do
	namespace :version do
		desc 'back to 1.0.0.*'
		task :reset do
			@anvil.projects.each do |project|
				new_version = ProjectVersion.parse project.version
				new_version.major = 1
				new_version.minor = 0
				new_version.revision = 0
				project.version = v.to_s
			end
		end

		desc 'changes a reference to a dll in all csprojs to a version'
		task :change_to, :reference, :version do |t, args|
			Dir['*/*.csproj'].each do |arg|
			  f = File.open(arg)
			  working_file = f.read
			  working_file.gsub!(/Include=(\"|\')#{args.reference}, Version=\d+\.\d+\.\d+\.\d+,/, "Include=\\1#{args.reference}, Version=#{args.version},")
			  f = File.new(arg, "w")
			  f.print(working_file)
			  f.close
			end
		end

    desc 'updates version of AssemblyInfo based on BUILD_NUMBER environment variable'
    task :update_build do
      @anvil.projects.each do |project|
        new_version = project.version
        project.version = new_version.gsub /\.\d+$/, ".#{build_number}"
      end
    end

    def build_number
      ENV['BUILD_NUMBER'] || '0'
    end

		namespace :bump do
			desc 'bumps the major version'
			task :major do
			  new_version = ProjectVersion.greatest_from @anvil.projects
			  new_version.major += 1
			  new_version.minor = 0
			  new_version.revision = 0

				@anvil.projects.each do |project|
				  change_version project, new_version
				end
			end

			def change_version project, version
			  from = project.version
			  to = version.to_s
			  puts "Changing version of #{project.name} from #{from} to #{to}"
			  project.version = version.to_s
			end

			desc 'bumps the minor version'
			task :minor do
			  new_version = ProjectVersion.greatest_from @anvil.projects
			  new_version.minor += 1
			  new_version.revision = 0

				@anvil.projects.each do |project|
				  change_version project, new_version
				end
			end

			desc 'bumps the revision version'
			task :revision do
			  new_version = ProjectVersion.greatest_from @anvil.projects
			  new_version.revision += 1

				@anvil.projects.each do |project|
				  change_version project, new_version
				end
			end
		end
	end
end

