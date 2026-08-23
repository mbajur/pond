class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def announcable?
    false
  end
end
