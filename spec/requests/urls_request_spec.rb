require 'rails_helper'

RSpec.describe "Urls", type: :request do
	describe 'GET /urls' do
		before(:all) do
			@url = create(:random_url)
			get '/urls'
		end

		it 'returns http success' do
			expect(response).to have_http_status(:success)
		end

		it "JSON body response contains expected attributes" do
			json_response = JSON.parse(response.body)[0]
			expect(json_response['long_url']).to eq(@url['long_url'])
			expect(json_response['slug']).to eq(@url['slug'])
			expect(json_response['deleted_at']).to eq(nil)
		end
	end

	describe 'GET /urls/<slug>' do
		before(:all) do
			@url = create(:random_url)
			get '/urls/' + @url['slug']
		end

		it 'returns http success' do
			expect(response).to have_http_status(302)
		end

		it 'Response redirects to expected URL' do
			expected_body = "<html><body>You are being <a href=\"" + @url['long_url'] + "\">redirected</a>.</body></html>"
			expect(response.body).to eq(expected_body)
		end
	end

	describe 'POST /urls' do
		it 'create new shortened url with defined slug' do
			@long_url = "http://gist.github.com"
			@slug = "gist"

			post "/urls", params: {long_url: @long_url, slug: @slug}

			expect(response).to have_http_status(:success)

			json_response = JSON.parse(response.body)
			expect(json_response['long_url']).to eq(@long_url)
			expect(json_response['slug']).to eq(@slug)
		end

		it 'create new shortened url with random slug' do
			@long_url = "http://gist.github.com"

			post "/urls", params: {long_url: @long_url}

			expect(response).to have_http_status(:success)

			json_response = JSON.parse(response.body)
			expect(json_response['long_url']).to eq(@long_url)
			expect(json_response['slug'].length).to eq(8)	
		end
	end

	describe 'DELETE /urls/<slug>' do
		before(:all) do
			@url = create(:random_url)
			delete '/urls/' + @url['slug']
		end

		it 'returns http success with no content' do
			expect(response).to have_http_status(:success)
			expect(response.body.length).to eq(0)
		end

		it 'cannot find url for slug' do
			get '/urls/' + @url['slug']
			expect(response).to have_http_status(500)
		end
	end
end
