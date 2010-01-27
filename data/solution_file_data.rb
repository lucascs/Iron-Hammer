module SolutionFileData
  def self.multiproject; DataHelper::read 'solution_file', 'multiproject.sln'; end
end unless defined? SolutionFileData
