defmodule Footem.Accounts.UserTest do
  use Footem.DataCase, async: true
  alias Footem.Accounts.User

  describe "registration_changeset/2" do
    test "valid changeset with valid data" do
      attrs = %{
        email: "test@example.com",
        first_name: "John",
        last_name: "Doe",
        msisdn: "1234567890",
        password: "@Password123!"
      }

      changeset = User.registration_changeset(%User{}, attrs)

      assert changeset.valid?
    end

    test "invalid changeset with short password" do
      attrs = %{
        email: "test@example.com",
        first_name: "John",
        last_name: "Doe",
        msisdn: "1234567890",
        password: "short"
      }

      changeset = User.registration_changeset(%User{}, attrs)

      refute changeset.valid?

      assert "at least one digit or punctuation character" in errors_on(changeset).password
      assert "at least one upper case character" in errors_on(changeset).password
      assert "should be at least 12 character(s)" in errors_on(changeset).password
    end


    test "invalid changeset with invalid email" do
      attrs = %{
        email: "invalidemail",
        first_name: "John",
        last_name: "Doe",
        msisdn: "1234567890",
        password: "@Password123!"
      }

      changeset = User.registration_changeset(%User{}, attrs)

      refute changeset.valid?
      assert "must have the @ sign and no spaces" in errors_on(changeset).email
    end
  end

  describe "wallet_changeset/2" do
    test "valid changeset with valid wallet amount" do
      attrs = %{wallet: 500.0}
      changeset = User.wallet_changeset(%User{}, attrs)

      assert changeset.valid?
    end

    test "invalid changeset with negative wallet amount" do
      attrs = %{wallet: -10.0}
      changeset = User.wallet_changeset(%User{}, attrs)

      refute changeset.valid?
      assert "must be greater than or equal to 0" in errors_on(changeset).wallet
    end
  end

  describe "has_permission?/2" do
    test "valid permission for 'admin' role" do
      user = %User{role: "admin"}

      assert User.has_permission?(user, "view_users")
      assert User.has_permission?(user, "configure_games")
    end

    test "invalid permission for 'admin' role" do
      user = %User{role: "admin"}

      refute User.has_permission?(user, "revoke_admin_access")
    end

    test "valid permission for 'user' role" do
      user = %User{role: "user"}

      assert User.has_permission?(user, "view_users")
      refute User.has_permission?(user, "configure_games")
    end
  end

  describe "valid_password?/2" do
    test "valid password" do
      user = %User{hashed_password: Bcrypt.hash_pwd_salt("Password123!")}

      assert User.valid_password?(user, "Password123!")
    end

    test "invalid password" do
      user = %User{hashed_password: Bcrypt.hash_pwd_salt("Password123!")}

      refute User.valid_password?(user, "wrongpassword")
    end
  end

  describe "email_changeset/2" do
    test "valid email change" do
      attrs = %{email: "newemail@example.com"}
      user = %User{email: "oldemail@example.com"}

      changeset = User.email_changeset(user, attrs)

      assert changeset.valid?
    end

    test "email did not change" do
      attrs = %{email: "oldemail@example.com"}
      user = %User{email: "oldemail@example.com"}

      changeset = User.email_changeset(user, attrs)

      refute changeset.valid?
      assert "did not change" in errors_on(changeset).email
    end
  end

  describe "confirm_changeset/1" do
    test "confirm account" do
      user = %User{confirmed_at: nil}
      changeset = User.confirm_changeset(user)

      assert changeset.valid?
      assert changeset.changes[:confirmed_at]
    end
  end
end
