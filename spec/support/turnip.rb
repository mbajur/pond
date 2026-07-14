require 'capybara-screenshot/rspec'

RSpec.configure do |config|
  config.raise_error_for_unimplemented_steps = true
end

Dir.glob("spec/steps/**/*steps.rb") { |f| load f }

RSpec.configure { |c| c.include MiscSteps }
RSpec.configure { |c| c.include AuthenticationSteps }
RSpec.configure { |c| c.include FeedSteps }
RSpec.configure { |c| c.include ProfileSteps }
RSpec.configure { |c| c.include UserSteps }
RSpec.configure { |c| c.include PostSteps }
RSpec.configure { |c| c.include CollectionSteps }
RSpec.configure { |c| c.include ConnectionSteps }
RSpec.configure { |c| c.include DiscoverSteps }
RSpec.configure { |c| c.include SearchSteps }
