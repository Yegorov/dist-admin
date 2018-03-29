require 'rails_helper'

RSpec.describe Document::LogsController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    it "returns http success" do
      get :show
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #index_all" do
    it "returns http success" do
      get :index_all
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #index_user" do
    it "returns http success" do
      get :index_user
      expect(response).to have_http_status(:success)
    end
  end

end
