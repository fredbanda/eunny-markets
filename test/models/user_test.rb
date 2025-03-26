require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "requires a name" do
    @user = User.new(name: "", email: "johndoe@example.com", password: "password123")
    assert_not @user.valid?

    @user.name = "John"
    assert @user.valid?
  end

  test "requires a valid email" do
    @user = User.new(name: "John Doe", email: "", password: "password123")
    assert_not @user.valid?

    @user.email = "johndoe@example"
    assert_not @user.invalid?

    @user.email = "johndoe@example.com"
    assert @user.valid?
  end

  test "requires a unique email" do
    @existing_user = User.create!(
      name: "John Doe",
      email: "johndoe@example.com",
      password: "password123"  # Ensure password is valid
    )

    assert @existing_user.persisted?

    @user = User.new(name: "John Doe", email: "johndoe@example.com", password: "password123")

    @user.valid?
    puts @user.errors.full_messages # Debugging step

    assert_not @user.valid?
  end


  test "name and email is stripped of spaces before saving" do
    @user = User.create(name: "  John Doe  ", email: "  johndoe@example.com  ", password: "password123")
    assert_equal "John Doe", @user.name
    assert_equal "johndoe@example.com", @user.email
  end

  test "password length must be at least 6 characters and ActiveModel's maximum " do
    @user = User.new(name: "John Doe", email: "johndoe@example.com", password: "")
    assert_not @user.valid?

    @user.password = "password"
    assert @user.valid?

    max_length = ActiveModel::SecurePassword::MAX_PASSWORD_LENGTH_ALLOWED
    @user.password = "a" * (max_length + 1)
    assert_not @user.valid?
  end
end
