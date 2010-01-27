module ProjectFileData
  def self.asp_net; DataHelper::read 'project_file', 'asp.net.csproj'; end
  def self.asp_net_mvc; DataHelper::read 'project_file', 'asp.net.mvc.csproj'; end
  def self.test; DataHelper::read 'project_file', 'test.csproj'; end
  def self.dll; DataHelper::read 'project_file', 'dll.csproj'; end
  def self.wcf; DataHelper::read 'project_file', 'wcf.csproj'; end
  def self.with_dependencies; DataHelper::read 'project_file', 'with_dependencies.csproj'; end
end unless defined? ProjectFileData
