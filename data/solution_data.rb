module SolutionData
  def self.all_kinds_of_projects_to_temp_dir
    TempHelper::copy_directory(
      :from => File.join(DataHelper::DATA_FOLDER, 'solutions', 'MACSkeptic.Iron.Hammer.All.Kinds.Of.Projects')
    )
    'MACSkeptic.Iron.Hammer.All.Kinds.Of.Projects'.inside_temp_dir
  end
end unless defined? SolutionData
