require "test_helper"

# The can_*? matrix itself -- prompts/phase-07-admin-auth.md's role table.
# See test/integration/avo_authorization_test.rb for the controller-level
# enforcement (these methods being correct doesn't prove anything actually
# calls them).
class UserAuthorizationTest < ActiveSupport::TestCase
  test "admin can do everything in the matrix" do
    admin = User.new(role: :admin)
    assert admin.can_edit_others_work?
    assert admin.can_publish?
    assert admin.can_delete?
    assert admin.can_manage_users_and_settings?
  end

  test "editor can edit others' work and publish, but not delete or manage users" do
    editor = User.new(role: :editor)
    assert editor.can_edit_others_work?
    assert editor.can_publish?
    assert_not editor.can_delete?
    assert_not editor.can_manage_users_and_settings?
  end

  test "reporter can do none of the elevated actions" do
    reporter = User.new(role: :reporter)
    assert_not reporter.can_edit_others_work?
    assert_not reporter.can_publish?
    assert_not reporter.can_delete?
    assert_not reporter.can_manage_users_and_settings?
  end

  test "role_label_mr matches the locked labels" do
    assert_equal "प्रशासक", User.new(role: :admin).role_label_mr
    assert_equal "संपादक", User.new(role: :editor).role_label_mr
    assert_equal "वार्ताहर", User.new(role: :reporter).role_label_mr
  end
end
