class MangasController < ApplicationController
  	before_action :authenticate_user!, except: [:index, :show]

	def index
		if user_signed_in?
			@mangas = Manga.where user_id: current_user.id
		else
			@mangas = Manga.all
		end
		if params[:search].present?
			@type = /type:(\w+)/.match(params[:search])
			@qry = Jikan::Query.new
			if @type != nil
				params[:search].slice!(" type:"+@type[1])
				case @type[1]
				when "manga"
					@results = @qry.search(params[:search], :manga).result
				when "anime"
					@results = @qry.search(params[:search], :anime).result
				when "character"
					result = RestClient.get 'https://api.jikan.moe/v3/search/character/?q='+params[:search]
					@results = JSON.parse(result)['results']
				when "person"
					result = RestClient.get 'https://api.jikan.moe/v3/search/person/?q='+params[:search]
					@results = JSON.parse(result)['results']
				else
					@results = @qry.search(params[:search]).result
				end
			else 
				@results = @qry.search(params[:search]).result
			end
			@results = @results.first(8)
		end
	end

	def friends
		@users = User.where("id != "+current_user.id.to_s )
		@friends = current_user.friends
		@pending_invited_by = current_user.pending_invited_by
		@pending_invited = current_user.pending_invited
	end

	def friend_invite
		@friend = User.find(params[:friend_id])
		@friendship_created = current_user.invite(@friend)
		if @friendship_created
			flash.now[:notice] = "Friend request sent to #{@friend.email}"
		end
		redirect_to mangas_friends_url
	end

	def approve_friend
		@Friend = User.find(params[:user_id])
		@friendship_approved = current_user.approve(@Friend)
		@friends = current_user.friends
		@pending_invited_by = current_user.pending_invited_by
		flash.now[:notice] = "Accepted request from #{@friend.email}"
	end
	
	def remove_friend
		@Friend = User.find(params[:user_id])
		@friendship = current_user.send(:find_any_friendship_with, @Friend)
		if @friendship
		  @friendship.delete
		  @removed = true
		  flash.now[:notice] = "Friendship with #{@friend.email} ended, now u hate each other"
		end
	end

	def show
		@manga = Manga.find(params[:id])
		if @manga.m_type == 'Manga'
			@mal_info = Jikan::manga @manga.mal_id
		else
			@mal_info = Jikan::anime @manga.mal_id
		end
		@related = @mal_info.raw['related']
		@reviews = Review.where(manga_id: @manga.id).order("created_at DESC")
		if @reviews.blank?
			@avg_review = 0
		else
			@avg_review = @reviews.average(:rating).round(2)
		end
		#binding.pry
	end

	def new
		@manga = current_user.mangas.build
	end

	def edit
		@manga = Manga.find(params[:id])
	end

	def create
		params.permit(:manga)
		p = params[:manga]
		if p['m_type'] == 'Manga'
			@mal_info = Jikan::manga p['mal_id']
		elsif p['m_type'] == 'Anime'
			@mal_info = Jikan::anime p['mal_id']
		end
		mp = manga_params
		mp[:user_id] = current_user.id
		mp[:title] = @mal_info.title
		mp[:img] = @mal_info.image
		mp[:m_type] = @mal_info.type

		@manga = current_user.mangas.build(mp)
		respond_to do |format|
			if @manga.save
			  format.html { redirect_to @manga, notice: 'Successfully created.' }
			  format.json { render :show, status: :created, location: @manga }
			else
			  format.html { render :new }
			  format.json { render json: @manga.errors, status: :unprocessable_entity }
			end
	  	end
	end

	def update
		@manga = Manga.find(params[:id])
		p = params[:manga].permit("mal_id", "m_type")
		if p['m_type'] == 'Manga'
			@mal_info = Jikan::manga p['mal_id']
		elsif p['m_type'] == 'Anime'
			@mal_info = Jikan::anime p['mal_id']
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