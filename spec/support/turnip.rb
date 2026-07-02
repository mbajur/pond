Dir.glob("spec/steps/**/*steps.rb") { |f| load f }

RSpec.configure { |c| c.include AuthenticationSteps }
