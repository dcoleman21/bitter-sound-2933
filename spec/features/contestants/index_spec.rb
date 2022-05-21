require 'rails_helper'

RSpec.describe 'Contestants Index Page' do
  context 'User Story 2' do
    it "can see a list of names of all the Contestants" do
      jay = Contestant.create(name: "Jay McCarroll", age: 40, hometown: "LA", years_of_experience: 13)
      gretchen = Contestant.create(name: "Gretchen Jones", age: 36, hometown: "NYC", years_of_experience: 12)
      kentaro = Contestant.create(name: "Kentaro Kameyama", age: 30, hometown: "Boston", years_of_experience: 8)
      erin = Contestant.create(name: "Erin Robertson", age: 44, hometown: "Denver", years_of_experience: 15)

      visit "/contestants"

      within("#contestant-#{jay.id}") do
        expect(page).to have_content("Jay McCarroll")
        expect(page).to_not have_content("Gretchen Jones")
        expect(page).to_not have_content("Kentaro Kameyama")
        expect(page).to_not have_content("Erin Robertson")
      end

      within("#contestant-#{gretchen.id}") do
        expect(page).to have_content("Gretchen Jones")
        expect(page).to_not have_content("Jay McCarroll")
        expect(page).to_not have_content("Kentaro Kameyama")
        expect(page).to_not have_content("Erin Robertson")
      end

      within("#contestant-#{kentaro.id}") do
        expect(page).to have_content("Kentaro Kameyama")
        expect(page).to_not have_content("Gretchen Jones")
        expect(page).to_not have_content("Jay McCarroll")
        expect(page).to_not have_content("Erin Robertson")
      end

      within("#contestant-#{erin.id}") do
        expect(page).to have_content("Erin Robertson")
        expect(page).to_not have_content("Gretchen Jones")
        expect(page).to_not have_content("Kentaro Kameyama")
        expect(page).to_not have_content("Jay McCarroll")
      end
    end

    it "under each contestants name I see a list of the projects (names) that they've been on" do
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

      visit "/contestants"

      within("#contestant-#{jay.id}") do
        expect(page).to have_content("Jay McCarroll")
        expect(page).to_not have_content("Gretchen Jones")
        expect(page).to have_content("Projects: News Chic")
        expect(page).to_not have_content("Projects: Upholstery Tuxedo")
        expect(page).to_not have_content("Projects: Boardfit")
      end

      within("#contestant-#{gretchen.id}") do
        expect(page).to have_content("Gretchen Jones")
        expect(page).to_not have_content("Jay McCarroll")
        expect(page).to have_content("Projects: News Chic, Upholstery Tuxedo")
        expect(page).to_not have_content("Projects: Boardfit")
      end

      within("#contestant-#{kentaro.id}") do
        expect(page).to have_content("Kentaro Kameyama")
        expect(page).to_not have_content("Gretchen Jones")
        expect(page).to have_content("Projects: Boardfit, Upholstery Tuxedo")
        expect(page).to_not have_content("Projects: News Chic")
      end

      within("#contestant-#{erin.id}") do
        expect(page).to have_content("Erin Robertson")
        expect(page).to_not have_content("Gretchen Jones")
        expect(page).to have_content("Projects: Boardfit")
        expect(page).to_not have_content("Projects: News Chic")
        expect(page).to_not have_content("Projects: Upholstery Tuxedo")
      end
    end
  end

  context 'Extension 2' do
    it "can see a project after being added to it" do
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

      fill_in :contestant_id, with: erin.id

      click_on "Add Contestant To Project"

      visit '/contestants'

      within("#contestant-#{erin.id}") do
        expect(page).to have_content("Erin Robertson")
        expect(page).to_not have_content("Gretchen Jones")
        expect(page).to have_content("Projects: News Chic, Boardfit")
        expect(page).to_not have_content("Projects: Upholstery Tuxedo")
      end
    end
  end
end
