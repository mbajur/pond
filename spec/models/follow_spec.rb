# frozen_string_literal: true

require 'rails_helper'

xdescribe Follow, type: :model do
  it { is_expected.to belong_to(:actor).class_name("User") }
  it { is_expected.to belong_to(:target) }
end
