class Post::ImagePolicy < PostPolicy
  def new?
    create?
  end

  def create?
    user&.premium?
  end

  def edit?
    update?
  end

  def update?
    false
  end
end
