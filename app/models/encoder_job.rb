#start beanstalkd using beanstalkd
require 'rubygems'
require 'stalker'
class EncodeVideo
	FFMPEG_PATH = 'ffmpeg'
	FFMPEGTHEORA_PATH = 'fmpeg2theora'

	def self.convert_to_mp4(file_name)
		#command ="#{FFMPEG_PATH} -i #{file_name} -vcodec libx264 -vpre hq -vpre ipod640 -b 250k -bt 50k -acodec libfaac -ab 56k -ac 2 -s 480x320  #{file_name}.mp4"
#ffmpeg -i 002_dynamic_find_by_methods.mov -acodec libfaac -ab 128k -ac 2 -vcodec libx264 -vpre slow -crf 22 test.mp4
		#ffmpeg -i input.wmv -acodec libfaac -ab 128k -ac 2 -vcodec libx264 -vpre slow -crf 22 -threads 0 output.mp4
		command ="#{FFMPEG_PATH} -i #{file_name} -acodec libfaac -ab 128k -ac 2 -vcodec libx264 -vpre slow -crf 22 -threads 0  #{file_name}.mp4"
		system(command)
	end

	def self.convert_to_ogg(file_name)
		#filename is abc.mp4
		command ="#{FFMPEGTHEORA_PATH} #{file_name} #{file_name}.ogv"
	end

end
include Stalker

job 'convert_video.to_mp4' do |args|
	EncodeVideo.convert_to_mp4(args['file'])
end

#Stalker.enqueue('convert_video.to_mp4', :file => "path_of_file")
