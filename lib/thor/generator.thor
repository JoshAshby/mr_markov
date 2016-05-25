class Generator < Thor::Group
  include Thor::Actions

  argument :name

  def self.source_root
    File.dirname(__FILE__)
  end

  def create_lib_file
    template('templates/new_file.tt', "lib/#{name}.rb")
  end

  def create_test_file
    template('templates/new_test.tt', "test/#{name}_test.rb")
  end
end
