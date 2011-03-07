class VideosController < ApplicationController
  # GET /videos
  # GET /videos.xml
  def index
    @videos = Video.all
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
    @video.set_nginx_video(params[:video])
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

  def download
   @video = Video.find(params[:id])
   response.headers['X-Accel-Redirect'] = "/attachments"+@video.asset.url.split("?").first
   response.headers['Content-Type']  = @video.asset_content_type
   response.headers['Content-Disposition'] = "attachment;filename=#{@video.asset_file_name}"
	 redirect_to video_url(@video)
  end
end
