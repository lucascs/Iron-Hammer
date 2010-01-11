task :spec do
  sh 'spec -c -f o specs'
end

task :spectacular do
  sh 'spec -c -f n specs'
end
