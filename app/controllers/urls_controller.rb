class UrlsController < ApplicationController
	include Response, ExceptionHandler

	before_action :set_url, only: [:show, :update, :destroy]

	# GET /urls
	def index
		@urls = Url.all
		json_response(@urls)
	end

	# GET /urls/:slug
	def show
		if @url
			redirect_to @url[:long_url]
		else
			json_response({error: "Slug not found"}, 500)
		end
	end

	# POST /urls
	def create
		if params.has_key?(:slug)
			if Url.exists?(slug: params[:slug])
				json_response({error: "Slug already exists"}, 500)
				return
			end
		else
			params[:slug] = ('a'...'z').to_a.shuffle[0,8].join
		end

		@url = Url.create(url_params)
		json_response(@url, :created)
	end

	# DELETE /urls/:slug
	def destroy
		if @url
			@url.destroy
			head :no_content
		else
			json_response({error: "No URL found for that slug"}, 500)
		end
	end

	private

	def url_params
		params.permit(:long_url, :slug)
	end

	def set_url
		@url = Url.find_by slug: params[:slug]
	end
end
