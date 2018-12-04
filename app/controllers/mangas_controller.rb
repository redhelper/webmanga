class MangasController < ApplicationController
  	before_action :authenticate_user!, except: [:index, :show]


	def index
		@mangas = Manga.all	
		if params[:search].present?
			@qry = Jikan::Query.new
			@results = @qry.search(params[:search]).result
			@results = @results.first(8)
		end
	end

	def show
		@manga = Manga.find(params[:id])
		if @manga.m_type = 'Manga'
			@mal_info = Jikan::manga @manga.mal_id
		else
			@mal_info = Jikan::anime @manga.mal_id
		end
		@related = @mal_info.raw['related']
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
		if @manga.m_type = 'Manga'
			@mal_info = Jikan::manga @manga.mal_id
		else
			@mal_info = Jikan::anime @manga.mal_id
		end
		mp = manga_params
		mp[:user_id] = current_user.id
		mp[:title] = @mal_info.title
		mp[:img] = @mal_info.image
		mp[:m_type] = @mal_info.type
		
		if @manga.update(mp)
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
		params.require(:manga).permit(:title, :mal_id, :img, :m_type)
	end
end