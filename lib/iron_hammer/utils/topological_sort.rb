class Array

  def topological_sort
    graph = {}
    refs = {}
    set = []
    list = []
    self.each {|e| set << e.name if e.project_references.empty?}
    self.each {|e| graph[e.name] = []; refs[e.name] = []}
    self.each {|e| e.project_references.each {|r| graph[r] << e.name; refs[r] << e.name}}

    until set.empty?
      n = set.pop
      list << n
      until graph[n].empty?
        m = graph[n].pop
        refs[m].delete n
        set << m if refs[m].empty? && !set.include?(m)
      end
    end

    list.map {|e| self.find {|p| p.name == e}}
  end

end

