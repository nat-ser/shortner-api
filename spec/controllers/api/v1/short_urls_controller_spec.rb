# frozen_string_literal: true

require "rails_helper"

RSpec.describe Api::V1::ShortUrlsController, type: :controller do
  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    it "returns http success" do
      get :show
      expect(response).to have_http_status(:moved_permanently)
    end
  end

  describe "POST #index" do
    it "returns http success" do
      post :index
      expect(response).to have_http_status(:success)
    end
  end
end
