class VideosController < ApplicationController
	# GET /videos
	# GET /videos.xml
	load_and_authorize_resource
	def index
		@videos = Video.by_name_or_description(params[:search]).paginate(:page => params[:page], :per_page => 15)
		respond_to do |format|
			format.html # index.html.erb
			format.xml  { render :xml => @videos }
		end
	end

	def new
		@video = Video.new
		respond_to do |format|
			format.html # new.html.erb
			format.xml  { render :xml => @video }
		end
	end

	def create

		@video = Video.new
		# FOR NGINX
		puts params
		@video.set_nginx_video(params)
		respond_to do |format|
			if @video.save
				puts @video.temp_file_path
				@video.move_to_path
				format.html { redirect_to(videos_path, :notice => 'Video was successfully created.') }
				format.xml  { render :xml => @video, :status => :created, :location => @video }
			else
				format.html { render :action => "new" }
				format.xml  { render :xml => @video.errors, :status => :unprocessable_entity }
			end
		end
	end

	# DELETE /videos/1
	# DELETE /videos/1.xml
	def destroy
		@video = Video.find(params[:id])
		@video.destroy

		respond_to do |format|
			format.html { redirect_to(videos_url) }
			format.xml  { head :ok }
		end
	end

	def show
		@video = Video.find(params[:id])
	end

	def	play
		@video = Video.find(params[:id])
		if @video.asset_content_type !='video/mp4'
			response.headers['X-Accel-Redirect'] = "/attachments/videos/#{@video.id}/#{@video.asset_file_name}.mp4"
		else
			response.headers['X-Accel-Redirect'] = "/attachments/videos/#{@video.id}/#{@video.asset_file_name}"
		end
		response.headers['Content-Type']  = 'video/mp4'
		response.headers['Content-Disposition'] = "inline;filename=#{@video.asset_file_name}"
		render :nothing => true

	end
	def download
		@video = Video.find(params[:id])
		response.headers['X-Accel-Redirect'] = "/attachments"+@video.asset.url.split("?").first
		response.headers['Content-Type']  = @video.asset_content_type
		response.headers['Content-Disposition'] = "attachment;filename=#{@video.asset_file_name}"
		redirect_to video_url(@video)
	end
end
