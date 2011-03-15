class Video < ActiveRecord::Base
	has_attached_file :asset,
	                 :url => '/:class/:id/:basename.:extension',
                    :path => ':rails_root/attachments/:class/:id/:basename.:extension'
#	validates_attachment_presence :video
  #validates_attachment_content_type :video,
	# :content_type => ['application/x-shockwave-flash', 'application/x-shockwave-flash', 'application/flv', 'video/x-flv','video/quicktime','video/mp4']
	#after_create :move_to_path
  attr_accessor :temp_file_path
	scope :by_name_or_description, lambda{|search_param| where("name = ? or asset_file_name = ? or description = ?",search_param,search_param,search_param) unless search_param.blank?}
 
	def convert_to_mp4
		if self.asset_content_type != "video/mp4"
			Stalker.enqueue('convert_video.to_mp4', :file => self.asset.path)
		end
	end
	
  # handle new param
  def set_nginx_video(video)

   asset = video['asset']
    if asset && asset.respond_to?('[]')
      self.asset = File.new(asset['filepath'])
      self.temp_file_path =asset['filepath']
      self.asset_file_name = asset["original_name"]
      self.asset_content_type = asset["content_type"]
      self.name = video["name"]
      self.description = video["description"]
    end
  end    

  # clean tmp directory used and set new param
  def move_to_path
   if File.exist?(self.asset.path)
    ##MOve to path
    paper_clip_path = "#{Rails.root}/attachments/videos/#{self.id}/"
    FileUtils.mkdir_p(paper_clip_path)
    actual_path = paper_clip_path+self.asset_file_name
    FileUtils.mv(self.temp_file_path,actual_path)
    self.asset = File.new(actual_path)
    self.save!
    #self.convert_to_mp4
   end
 end 
end
