ignore %r{^(node_modules|public|logs/|db/|config/|.gems/|.bundle/)}

guard :minitest, all_on_start: false, all_env: { 'COVERAGE' => true }, env: { 'COVERAGE' => true } do
  watch(%r{^lib/(.+)\.rb$}) { |m| "test/lib/#{m[1]}_test.rb" }
  watch(%r{^app/(.+)\.rb$}) { |m| "test/app/#{m[1]}_test.rb" }
  watch(%r{^test/.+_test\.rb$})
  watch(%r{^test/test_helper\.rb$}) { 'test' }
end

guard :yard do
  watch(%r{^lib/(.+)\.rb$})
  watch(%r{^app/(.+)\.rb$})
end
