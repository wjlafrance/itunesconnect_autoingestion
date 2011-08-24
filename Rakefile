task :default => [:clean, :compilejava, :javadoc, :rspec]

task :clean do
  puts ":clean.."
  system("rm *.txt.gz > /dev/null 2>&1")
  system("rm *.class > /dev/null 2>&1")
  system("rm -rf javadoc > /dev/null 2>&1");
  system("rm *txt *txt.gz *html > /dev/null 2>&1")
end

task :compilejava do
  puts ":compilejava.."
  system("javac Autoingestion.java")
end

task :javadoc do
  puts ":javadoc.."
  system("javadoc Autoingestion.java -d javadoc > /dev/null")
end

task :rspec do
  puts ":rspec.."
  system("rspec autoingestion_spec.rb")
end


