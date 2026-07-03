module UserSteps
  step ":user has :collection_name collection" do |user, collection_name|
    user = User.find_by_username!(user)
    create(:collection, name: collection_name, user: user)
  end

  step ":user has private :collection_name collection" do |user, collection_name|
    user = User.find_by_username!(user)
    create(:collection, name: collection_name, user: user, private: true)
  end
end
