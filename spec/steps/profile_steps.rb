module ProfileSteps
  step "I visit :username profile page" do |username|
    visit user_path(username)
  end

  step "I click on the follow button" do
    click_button "Follow"
  end

  step "I click on the unfollow button" do
    click_button "Unfollow"
  end

  step "I should see unfollow button" do
    expect(page).to have_button("Unfollow")
  end
end
