# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
#ActionController::Streaming::X_SENDFILE_HEADER = 'X-Accel-Redirect'
VideoShare::Application.initialize!
