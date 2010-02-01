module SolutionFileData
  def self.multiproject; DataHelper::read 'solution_file', 'multiproject.sln'; end
  def self.with_installer; DataHelper::read 'solution_file', 'with_installer.sln'; end
end unless defined? SolutionFileData

