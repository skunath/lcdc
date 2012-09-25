# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Lcdc::Application.initialize!


#Lcdc::Application.config.LCDC_File_Location = "/projects/lcdc_support/data/"
#Lcdc::Application.config.LCDC_New_File_Location = "/projects/lcdc_support/data-holder/"

Lcdc::Application.config.LCDC_File_Location = "/var/www/html/lcdc-data/"
Lcdc::Application.config.LCDC_New_File_Location = "/var/www/html/lcdc-data/data-holder/"
