require 'rails_helper'

RSpec.describe 'Project Show Page' do
  context 'User Story 1' do
    it "can see that projects name and material" do
      recycled_material_challenge = Challenge.create(theme: "Recycled Material", project_budget: 1000)
      news_chic = recycled_material_challenge.projects.create(name: "News Chic", material: "Newspaper")
      boardfit = recycled_material_challenge.projects.create(name: "Boardfit", material: "Cardboard Boxes")

      visit "/projects/#{news_chic.id}"

      expect(page).to have_content("News Chic")
      expect(page).to have_content("Material: Newspaper")
      expect(page).to_not have_content("Boardfit")
      expect(page).to_not have_content("Material: Cardboard Boxes")
      expect(page).to have_content("Challenge Theme: Recycled Material")
    end
  end
end
