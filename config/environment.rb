# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Lcdc::Application.initialize!

Lcdc::Application.config.LCDC_File_Location = "/projects/lcdc_support/data/"

