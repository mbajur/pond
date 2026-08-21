class User < ApplicationRecord
  include Fedipub::ActorEntity

  has_many :sessions, dependent: :destroy
  has_many :collections, dependent: :destroy
  has_many :auth_codes, dependent: :destroy

  has_many :follows_as_actor, through: :fedipub_actor, source: :following_follows
  has_many :follows_as_target, through: :fedipub_actor, source: :following_followers
  has_many :followers, through: :fedipub_actor, source: :followers, class_name: "Fedipub::Actor"
  has_many :following_actors, through: :follows_as_actor, source: :target_actor
  has_many :following_users, through: :following_actors, source: :entity, source_type: "User"
  has_many :following_collections, through: :following_actors, source: :entity, source_type: "Collection"

  after_create :create_inbox_collection

  acts_as_fedipub_actor username_field: :username,
                        name_field: :name,
                        profile_url_method: :user_url

  def self.find_by_username!(username)
    find_by!(username: username.gsub("@", ""))
  end

  def to_param
    "@#{username}"
  end

  def to_s
    "@#{username}"
  end

  def following?(target)
    Fedipub::Following.where(actor: self.fedipub_actor, target_actor: target.fedipub_actor).exists?
  end

  def premium?
    premium_until.present? && premium_until > Time.current
  end

  private

  # @todo move that out of here
  def create_inbox_collection
    collections.create!(inbox: true, name: "Inbox", private: true)
  end
end
