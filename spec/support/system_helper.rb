# frozen_string_literal: true

require 'capybara/cuprite'

Capybara.register_driver(:cuprite) do |app|
  Capybara::Cuprite::Driver.new(app, window_size: [1600, 800])
end
Capybara.javascript_driver = :cuprite

RSpec.configure do |config|
  # Ensure correct webdriver for systems specs
  config.before(:each, type: :system) do
    driven_by Capybara.javascript_driver
  end

  # Asset precompilation
  config.before(:suite) do
    examples = RSpec.world.filtered_examples.values.flatten
    has_no_system_tests = examples.none? { |example| example.metadata[:type] == :system }

    if has_no_system_tests
      $stdout.puts "\n🚀️️  No system test selected. Skip assets compilation.\n"
      next
    end

    if Webpacker.dev_server.running?
      $stdout.puts "\n⚙️  Webpack dev server is running! Skip assets compilation.\n"
      next
    else
      $stdout.puts "\n🐢  Precompiling assets.\n"
      original_stdout = $stdout.clone

      start = Time.current
      begin
        # Silence Webpacker output
        $stdout.reopen(File.new('/dev/null', 'w'))

        require 'rake'
        Rails.application.load_tasks
        Rake::Task['webpacker:compile'].execute
      ensure
        $stdout.reopen(original_stdout)
        $stdout.puts "Finished in #{(Time.current - start).round(2)} seconds"
      end
    end
  end
end
