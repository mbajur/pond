module ProfileSteps
  step "I visit :username profile page" do |username|
    visit user_path(username)
  end

  step "I should see :button button" do |button|
    expect(page).to have_button(button)
  end
end
