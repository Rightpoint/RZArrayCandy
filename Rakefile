
namespace :test do
  
  task :prepare do
    sh("brew update && brew upgrade xctool") rescue nil
  end
  
  task :iOS => :prepare do
    run_tests('iOS Tests', 'iphonesimulator')
  end
end


private

def run_tests(scheme, sdk)
  sh("xctool -workspace RZArrayCandy.workspace -scheme '#{scheme}' -sdk '#{sdk}' clean test") rescue nil
end