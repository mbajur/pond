require "capybara/cuprite"

Capybara.javascript_driver = :cuprite
Capybara.register_driver(:cuprite) do |app|
  opts = {
    window_size: [ 1200, 800 ],
    timeout: 60,
    inspector: true
  }

  if ENV["DEBUG"]
    opts[:headless] = false
    opts[:slowmo] = 0.3
  end

  Capybara::Cuprite::Driver.new(app, opts)
end
