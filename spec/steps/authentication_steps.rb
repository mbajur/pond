module AuthenticationSteps
  include FactoryBot::Syntax::Methods

  step "user with :email email address and :username username exists" do |email, username|
    @user = create(:user, email_address: email, username: username)
  end

  step "I visit the sign-in page" do
    visit join_path
  end

  step "I fill in the sign-in form with email :email" do |email|
    fill_in "email_address", with: email
    click_button "Let's go!"
  end

  step "I should receive a sign-in code" do
    @code = @user.auth_codes.last.code
  end

  step "I fill in the sign-in form with code I received on my email address" do
    fill_in "auth_code", with: @code
    click_button "Verify the code"
  end

  step "I should be signed in" do
    expect(page).to have_content("Signed in successfully")
  end
end
