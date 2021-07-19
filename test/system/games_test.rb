require "application_system_test_case"

class GamesTest < ApplicationSystemTestCase
  # test "visiting the index" do
  #   visit games_url
  #
  #   assert_selector "h1", text: "Game"
  # end
  test "visiting /new displays a random grid" do
    visit new_url
    assert test: "New game"
    assert_selector ".card", count: 10
  end

  test "providing random english word will result in error that cannot be built" do
    visit new_url
    fill_in "answer", with: "hippopotamus"
    click_on "submit"

    take_screenshot

    assert_text "Sorry but HIPPOPOTAMUS can't be built"
  end

  test "providing short word will result in word not valid error" do
    visit new_url
    fill_in "answer", with: "pkm"
    click_on "submit"

    take_screenshot

    assert_text "Sorry but pkm does not seem to be a valid English word."
  end


end
