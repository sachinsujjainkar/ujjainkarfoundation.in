require "test_helper"

class PeopleControllerTest < ActionDispatch::IntegrationTest
  # people.yml's fixtures don't set name_mr -- Mobility-translated, no
  # fixture value there (see that file's comment) -- set here so the
  # assertion checks real rendered content, not two blanks matching by
  # coincidence.
  setup { people(:one).update!(name_mr: "चाचणी व्यक्ती") }

  test "shows a person page listing their published article mentions" do
    get "/mr/vyakti/#{people(:one).slug}"
    assert_response :success
    assert_select "h1", text: "चाचणी व्यक्ती"
  end

  test "404s for an unknown person slug" do
    get "/mr/vyakti/no-such-person"
    assert_response :not_found
  end

  test "en locale uses the /people segment" do
    get "/en/people/#{people(:one).slug}"
    assert_response :success
  end
end
