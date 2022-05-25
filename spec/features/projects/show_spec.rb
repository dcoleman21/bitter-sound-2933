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

  context 'User Story 3' do
    it "can see a count of the number of contestants on this project" do
      recycled_material_challenge = Challenge.create(theme: "Recycled Material", project_budget: 1000)

      news_chic = recycled_material_challenge.projects.create(name: "News Chic", material: "Newspaper")
      boardfit = recycled_material_challenge.projects.create(name: "Boardfit", material: "Cardboard Boxes")

      jay = Contestant.create(name: "Jay McCarroll", age: 40, hometown: "LA", years_of_experience: 13)
      gretchen = Contestant.create(name: "Gretchen Jones", age: 36, hometown: "NYC", years_of_experience: 12)
      kentaro = Contestant.create(name: "Kentaro Kameyama", age: 30, hometown: "Boston", years_of_experience: 8)

      ContestantProject.create(contestant_id: jay.id, project_id: news_chic.id)
      ContestantProject.create(contestant_id: gretchen.id, project_id: news_chic.id)

      visit "/projects/#{news_chic.id}"

      expect(page).to have_content("News Chic")
      expect(page).to have_content("Material: Newspaper")
      expect(page).to have_content("Challenge Theme: Recycled Material")

      expect(page).to have_content("Number of Contestants: 2")
      expect(page).to_not have_content("Number of Contestants: 3")
    end
  end

  context 'Extenstion 1' do
    it "see the average years of experience for the contestants that worked on that project" do
      recycled_material_challenge = Challenge.create(theme: "Recycled Material", project_budget: 1000)

      news_chic = recycled_material_challenge.projects.create(name: "News Chic", material: "Newspaper")
      boardfit = recycled_material_challenge.projects.create(name: "Boardfit", material: "Cardboard Boxes")

      jay = Contestant.create(name: "Jay McCarroll", age: 40, hometown: "LA", years_of_experience: 13)
      gretchen = Contestant.create(name: "Gretchen Jones", age: 36, hometown: "NYC", years_of_experience: 12)
      kentaro = Contestant.create(name: "Kentaro Kameyama", age: 30, hometown: "Boston", years_of_experience: 8)

      ContestantProject.create(contestant_id: jay.id, project_id: news_chic.id)
      ContestantProject.create(contestant_id: gretchen.id, project_id: news_chic.id)

      visit "/projects/#{news_chic.id}"

      expect(page).to have_content("News Chic")
      expect(page).to have_content("Material: Newspaper")
      expect(page).to have_content("Challenge Theme: Recycled Material")

      expect(page).to have_content("Number of Contestants: 2")
      expect(page).to have_content("Average Contestant Experience: 12.5 Years")
      expect(page).to_not have_content("Average Contestant Experience: Sorry There Are No Contestants On This Project")
    end
  end

  context 'Extenstion 2' do
    it "can see a form to add a contestant to this project" do
      recycled_material_challenge = Challenge.create(theme: "Recycled Material", project_budget: 1000)
      furniture_challenge = Challenge.create(theme: "Apartment Furnishings", project_budget: 1000)

      news_chic = recycled_material_challenge.projects.create(name: "News Chic", material: "Newspaper")
      boardfit = recycled_material_challenge.projects.create(name: "Boardfit", material: "Cardboard Boxes")
      upholstery_tux = furniture_challenge.projects.create(name: "Upholstery Tuxedo", material: "Couch")

      jay = Contestant.create(name: "Jay McCarroll", age: 40, hometown: "LA", years_of_experience: 13)
      gretchen = Contestant.create(name: "Gretchen Jones", age: 36, hometown: "NYC", years_of_experience: 12)
      kentaro = Contestant.create(name: "Kentaro Kameyama", age: 30, hometown: "Boston", years_of_experience: 8)
      erin = Contestant.create(name: "Erin Robertson", age: 44, hometown: "Denver", years_of_experience: 15)

      ContestantProject.create(contestant_id: jay.id, project_id: news_chic.id)

      ContestantProject.create(contestant_id: gretchen.id, project_id: news_chic.id)
      ContestantProject.create(contestant_id: gretchen.id, project_id: upholstery_tux.id)

      ContestantProject.create(contestant_id: kentaro.id, project_id: upholstery_tux.id)
      ContestantProject.create(contestant_id: kentaro.id, project_id: boardfit.id)

      ContestantProject.create(contestant_id: erin.id, project_id: boardfit.id)

      visit "/projects/#{news_chic.id}"

      expect(page).to have_content("Add Contestant To Project")
      expect(page).to have_content("Number of Contestants: 2")
      expect(page).to have_content("Average Contestant Experience: 12.5 Years")

      fill_in :contestant_id, with: erin.id

      click_on "Add Contestant To Project"

      expect(current_path).to eq("/projects/#{news_chic.id}")
      expect(page).to have_content("Number of Contestants: 3")
      expect(page).to have_content("Average Contestant Experience: 13.33 Years")

      visit '/contestants'

      within("#contestant-#{erin.id}") do
        expect(page).to have_content("Projects: News Chic, Boardfit")
      end
    end
  end
end
