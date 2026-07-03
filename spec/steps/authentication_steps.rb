module AuthenticationSteps
  include FactoryBot::Syntax::Methods

  step ":user is signed in" do |user|
    user = User.find_by_username!(user)
    session = user.sessions.create!(user_agent: "Turnip", ip_address: "127.0.0.1")

    request = ActionDispatch::TestRequest.create
    jar = ActionDispatch::Cookies::CookieJar.build(request, {})
    jar.signed[:session_id] = { value: session.id, httponly: true, same_site: :lax }

    visit root_path

    if page.driver.respond_to?(:set_cookie)
      page.driver.set_cookie("session_id", jar[:session_id], path: "/")
    else
      page.driver.browser.set_cookie("session_id=#{jar[:session_id]}")
    end
  end

  step "user with :email email address and :username username exists" do |email, username|
    @user = create(:user, email_address: email, username: username, private: false)
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
