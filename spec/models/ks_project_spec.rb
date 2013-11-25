require 'spec_helper'

describe KsProject do 
  context '#scrape' do 

    before(:all) do 
      # seed test database  
      @user1 = KsUser.create(:url => "profiles/user1")
      @user2 = KsUser.create(:url => "profiles/user2")
      @project1 = KsProject.create(:url => "projects/project1")
      @project2 = KsProject.create(:url => "@projects/project2")

      @project1.ks_project_backers.create(:ks_user => @user1)
      @user2.ks_project_backers.create(:ks_project => @project2)

      user = KsUser.find_or_create_by(:url => "profiles/user1")
      # try to add a user who doesn't back @project2
      @project2.add_user(user)
      user = KsUser.find_or_create_by(:url => "profiles/user2")
      # try to add a user who already backs @project2
      @project2.add_user(user)
    end

    # project 1 has user 1
    # user 2 has project 2

    it 'does not create duplicate ks_projects when scraping' do

      expect(KsProject.all.count).to be(2)

    end

    it 'does not create duplicate ks_users when scraping' do 

      expect(KsUser.all.count).to be(2)

    end

    it 'does not create duplicate associations when scraping' do 

      expect(KsProjectBacker.all.count).to eq(3)
    end


  end
end


# scraping projects 
  # grab a user by url
  # check to see if that user exists in the database
  # if that user does exist, check to see if the association exists with the project
  # if the association exists, do nothing, just add the scraped info to the project 
  # if the association does not exist, but the user does, create the association 
  # if the user does not exist, create the user and the association 



