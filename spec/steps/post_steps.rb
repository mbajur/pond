module PostSteps
  step ":url URL post is created by :user on :collection_name collection" do |url, user, collection_name|
    user = User.find_by_username!(user)
    collection = Collection.find_by!(name: collection_name, user: user)
    post = create(:post, url: url, user: user)
    create(:pin, collection: collection, user: user, pinable: post)
  end
end
