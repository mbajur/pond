module CollectionSteps
  step "I visit :collection_name collection by :user" do |collection_name, user|
    user = User.find_by_username!(user)
    collection = Collection.find_by!(name: collection_name, user: user)
    visit user_collection_path(user, collection)
  end
end
