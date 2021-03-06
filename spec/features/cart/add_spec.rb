require 'rails_helper'

RSpec.describe 'Cart creation' do
  describe 'When I visit an items show page' do

    before(:each) do
      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 25)
      @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
      @mug = @mike.items.create(name: "Mug", description: "This mug is ugly and chipped", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 3)
    end

    it "I see a link to add this item to my cart" do
      visit "/items/#{@paper.id}"
      expect(page).to have_button("Add To Cart")
    end

    it "I can add this item to my cart" do
      visit "/items/#{@paper.id}"
      click_on "Add To Cart"

      expect(page).to have_content("#{@paper.name} was successfully added to your cart")
      expect(current_path).to eq("/items")

      within 'nav' do
        expect(page).to have_content("Cart: 1")
      end

      visit "/items/#{@pencil.id}"
      click_on "Add To Cart"

      within 'nav' do
        expect(page).to have_content("Cart: 2")
      end
    end
    it "I can increment the count of items I want to purchase" do

      visit "/items/#{@pencil.id}"
      click_on "Add To Cart"

      visit '/cart'

      click_link "+"
      click_link "+"
      click_link "+"
      click_link "+"
      expect(page).to have_content("5")
    end
    it "I can decrement the count of items I want to purchase" do

      visit "/items/#{@pencil.id}"
      click_on "Add To Cart"

      visit '/cart'

      click_link "+"
      click_link "+"
      click_link "+"
      click_link "+"
      click_link "+"
      click_link "+"
      click_link "+"
      click_link "+"
      click_link "+"
      expect(page).to have_content("10")

      click_link "-"
      expect(page).to have_content("9")
    end
    it "I can increment the count of items I want to purchase unless it is more than the inventory" do
      visit "/items/#{@mug.id}"
      click_on "Add To Cart"

      visit '/cart'

      click_link "+"
      click_link "+"
      click_link "+"
      expect(page).to have_content("3")
      click_link "+"
      expect(page).to have_content("3")
    end
    it "If I decrement item to 0 it is removed from my cart" do
      visit "/items/#{@mug.id}"
      click_on "Add To Cart"

      visit '/cart'
      click_link "+"
      expect(page).to have_content("2")
      click_link "-"
      expect(page).to have_content("1")
      click_link "-"
      expect(page).to have_content("Cart is currently empty")
    end
  end
end
