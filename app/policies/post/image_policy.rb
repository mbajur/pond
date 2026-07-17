class Post::ImagePolicy < PostPolicy
  def new?
    create?
  end

  def create?
    user&.premium?
  end

  def update?
    false
  end

  def edit?
    user.present? && record.user_id == user.id
  end

  def update_image?
    edit?
  end
end
