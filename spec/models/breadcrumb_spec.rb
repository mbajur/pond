# frozen_string_literal: true

require "rails_helper"

describe Breadcrumb do
  subject(:breadcrumb) { described_class.new("Home", "/") }

  describe "#link?" do
    context "when path is present" do
      it "returns true" do
        expect(breadcrumb.link?).to be true
      end
    end

    context "when path is nil" do
      subject(:breadcrumb) { described_class.new("Current Page", nil) }

      it "returns false" do
        expect(breadcrumb.link?).to be false
      end
    end

    context "when path is an empty string" do
      subject(:breadcrumb) { described_class.new("Current Page", "") }

      it "returns false" do
        expect(breadcrumb.link?).to be false
      end
    end
  end
end
