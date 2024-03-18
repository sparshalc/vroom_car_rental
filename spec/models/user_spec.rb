require 'rails_helper'

RSpec.describe User, type: :model do

  let(:user) { create(:user) }

  describe 'full_name validation' do
    it "returns full name" do
      user = User.new(full_name: "Krisam Byanju")
      assert_equal "Krisam Byanju", user.full_name
    end

    it "returns errors without full_name" do
      user = User.new(full_name: "")
      user.save
      expect(user.errors[:full_name]).to include("can't be blank")
    end

    it "is invalid with a non-unique full_name" do
      user_name = User.new(full_name: user.full_name)
      user_name.valid?
      expect(user_name.errors[:full_name]).to include("has already been taken try again with a new one")
    end
  end

  describe 'enums' do
    it 'defines roles enum' do
      user = User.new

      expect(User.roles).to eq({ "user" => 0, "seller" => 1, "admin" => 2 })

      expect(user).to respond_to(:role)
      expect(user).to respond_to(:user?)
      expect(user).to respond_to(:seller?)
      expect(user).to respond_to(:admin?)

      expect(user.role).to eq('user')
      expect(user).to be_user

      user.role = :admin
      expect(user.role).to eq('admin')
      expect(user).to be_admin

      user.role = :seller
      expect(user.role).to eq('seller')
      expect(user).to be_seller
    end
  end

  describe 'associations' do
    it "is attached" do
      user.avatar.attach(
        io: File.open(Rails.root.join('app', 'assets', 'images', 'avatar.png')),
        filename: 'avatar.png',
        content_type: 'image/png'
      )
      expect(user.avatar).to be_attached
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:full_name) }

    it "validates the format of phone number" do
      user = User.new(phone_number: "123456789")
      user.valid?

      expect(user.errors[:phone_number]).to include("must be 10 digits")

      user.phone_number = "1234567890"
      user.valid?

      expect(user.errors[:phone_number]).to be_empty
    end

    it "validates the content type of avatar" do
      user = User.new

      user.avatar.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'avatar.png')), filename: 'avatar.jpg', content_type: 'image/jpeg')

      user.valid?
      expect(user.errors[:avatar]).to be_empty

      user.avatar.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'avatar.txt')), filename: 'avatar.txt', content_type: 'text/plain')

      user.valid?
      expect(user.errors[:avatar]).to include("Invalid file format. Plese select avatar with (JPEG/PNG) format.")
    end
  end

  describe "#users" do
    context "when a new user is created with all valid attribues" do
      it "saves the user to the database" do
        expect(User.count).to eq(0)
      end
    end

    context "when " do
      it "saves the user to the database" do
        expect(User.count).to eq(0)
      end
    end
  end

end
