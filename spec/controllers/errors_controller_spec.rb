require 'rails_helper'

RSpec.describe ErrorsController, type: :controller do

  describe "GET #show404" do
    it "returns http success" do
      get :show404
      expect(response).to have_http_status(:success)
    end
  end

end
