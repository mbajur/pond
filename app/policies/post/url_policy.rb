class Post::UrlPolicy < PostPolicy
  def edit?
    update?
  end

  def update?
    false
  end
end
