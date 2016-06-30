ignore %r{^(node_modules|public|logs/|db/|config/|.gems/|.bundle/)}

guard :minitest, all_on_start: false do
  watch(%r{^lib/(.+)\.rb$}) { |m| "test/lib/#{m[1]}_test.rb" }
  watch(%r{^test/.+_test\.rb$})
  watch(%r{^test/test_helper\.rb$}) { 'test' }
end
