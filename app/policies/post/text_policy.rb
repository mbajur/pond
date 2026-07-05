class Post::TextPolicy < PostPolicy
  def new?
    create?
  end

  def create?
    user&.premium?
  end

  def edit?
    user.present? && record.user_id == user.id
  end

  def update_text?
    edit?
  end
end
