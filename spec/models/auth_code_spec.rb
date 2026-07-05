# frozen_string_literal: true

require "rails_helper"

describe AuthCode, type: :model do
  let(:user) { User.create!(username: "testuser", email_address: "test@example.com") }

  subject { AuthCode.create!(user: user) }

  it { is_expected.to belong_to(:user) }

  describe "validations" do
    describe "code" do
      it "is required" do
        auth_code = AuthCode.create!(user: user)
        auth_code.code = nil
        expect(auth_code).not_to be_valid
        expect(auth_code.errors[:code]).to include("can't be blank")
      end

      it "must be unique" do
        is_expected.to validate_uniqueness_of(:code)
      end
    end
  end

  describe ".consume" do
    context "when an active code matches" do
      it "destroys the record and returns it" do
        auth_code = AuthCode.create!(user: user)
        result = AuthCode.consume(auth_code.code)
        expect(result).to eq(auth_code)
        expect(AuthCode.exists?(auth_code.id)).to be false
      end

      it "applies code sanitization before lookup" do
        auth_code = AuthCode.create!(user: user)
        # Substitute a character that sanitize() normalizes (lowercase → uppercase)
        lowercased = auth_code.code.downcase
        expect(AuthCode.consume(lowercased)).to eq(auth_code)
      end
    end

    context "when the code is expired" do
      it "returns nil and does not destroy the record" do
        auth_code = AuthCode.create!(user: user, expires_at: 1.minute.ago)
        expect(AuthCode.consume(auth_code.code)).to be_nil
        expect(AuthCode.exists?(auth_code.id)).to be true
      end
    end

    context "when the code does not exist" do
      it "returns nil" do
        expect(AuthCode.consume("DOESNOTEXIST")).to be_nil
      end
    end
  end

  describe ".cleanup" do
    it "deletes stale records" do
      stale = AuthCode.create!(user: user, expires_at: 1.minute.ago)
      AuthCode.cleanup
      expect(AuthCode.exists?(stale.id)).to be false
    end

    it "leaves active records untouched" do
      active = AuthCode.create!(user: user)
      AuthCode.cleanup
      expect(AuthCode.exists?(active.id)).to be true
    end
  end

  describe "#consume" do
    it "destroys the record" do
      auth_code = AuthCode.create!(user: user)
      auth_code.consume
      expect(AuthCode.exists?(auth_code.id)).to be false
    end

    it "returns self" do
      auth_code = AuthCode.create!(user: user)
      expect(auth_code.consume).to eq(auth_code)
    end
  end
end
