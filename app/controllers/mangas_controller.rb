class MangasController < ApplicationController
	def index
		@mangas = Manga.all	
		if params[:text_query].present?
			@qry = Jikan::Query.new
			@results = @qry.search(params[:text_query]).result
		end
	end

	def show
		@manga = Manga.find(params[:id])
		@qry = Jikan::Query.new
		@mal_info = @qry.manga_id @manga.mal_id

		@qry2 = Jikan::Query.new
		@search = @qry2.search(@mal_info.title)
		@resume = @search.result.first(5)
	end

	def new
		@manga = Manga.new
	end

	def edit
		@manga = Manga.find(params[:id])
	end

	def create
		@manga = Manga.new(manga_params)
		if @manga.save
			redirect_to @manga
		else
			render 'new'
		end
	end

	def update
		@manga = Manga.find(params[:id])
		if @manga.update(manga_params)
			redirect_to @manga
		else
			render 'edit'
		end
	end

	def destroy
		@manga = Manga.find(params[:id])
		@manga.destroy
		redirect_to mangas_path
	end

	private
	def manga_params
		params.require(:manga).permit(:title, :mal_id, :img)
	end
end