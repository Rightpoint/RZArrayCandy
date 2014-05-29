
namespace :test do
  
  task :install do
    sh("brew update && brew upgrade xctool") rescue nil
  end
  
  task :iOS do
    run_tests('iOS Tests', 'iphonesimulator')
  end
  
  task :OSX do
    run_tests('OSX Tests', 'macosx')
  end
  
end


private

def run_tests(scheme, sdk)
  sh("xctool -workspace RZArrayCandy.xcworkspace -scheme '#{scheme}' -sdk '#{sdk}' clean test") rescue nil
end