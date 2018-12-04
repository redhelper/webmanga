class MangasController < ApplicationController
  	before_action :authenticate_user!, except: [:index, :show]


	def index
		@mangas = Manga.all	
		if params[:search].present?
			@qry = Jikan::Query.new
			@results = @qry.search(params[:search]).result
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
		@manga = current_user.mangas.build
	end

	def edit
		@manga = Manga.find(params[:id])
	end

	def create
		@manga = current_user.mangas.build(manga_params)

		respond_to do |format|
			if @manga.save
			  format.html { redirect_to @manga, notice: 'Movie was successfully created.' }
			  format.json { render :show, status: :created, location: @manga }
			else
			  format.html { render :new }
			  format.json { render json: @manga.errors, status: :unprocessable_entity }
			end
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