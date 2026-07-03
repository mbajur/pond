require 'capybara-screenshot/rspec'

Dir.glob("spec/steps/**/*steps.rb") { |f| load f }

RSpec.configure { |c| c.include MiscSteps }
RSpec.configure { |c| c.include AuthenticationSteps }
RSpec.configure { |c| c.include FeedSteps }
RSpec.configure { |c| c.include ProfileSteps }
RSpec.configure { |c| c.include UserSteps }
RSpec.configure { |c| c.include PostSteps }
