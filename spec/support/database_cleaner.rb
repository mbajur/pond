RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    # JS specs drive a real browser that talks to the app over its own Puma
    # thread, with ActionCable and ActiveJob's async broadcasts running on
    # further threads of their own. None of those threads can see rows created
    # inside the RSpec thread's open, uncommitted transaction, so broadcasts
    # never reach the browser. Truncation commits for real, making the data
    # visible everywhere.
    #
    # The strategy must be set here, before `cleaning` calls `.start` -
    # a plain before(:each) hook runs too late, since around hooks wrap
    # example.run (and everything before(:each) triggers inside it).
    DatabaseCleaner.strategy = example.metadata[:js] ? :truncation : :transaction

    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
