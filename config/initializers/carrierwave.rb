require 'carrierwave/storage/abstract'
require 'carrierwave/storage/file'
require 'carrierwave/storage/fog'

  CarrierWave.configure do |config|


  

   
      CarrierWave.configure do |config|
        config.storage = :fog
        config.fog_credentials = {
          :provider               => 'AWS',                            # required
          :aws_access_key_id      => ENV['AWS_ID_TWO'],                     # required
          :aws_secret_access_key  => ENV['AWS_KEY_TWO'],
          :region                 => 'us-west-2'
        }
       
        config.fog_directory  = 'goalsdon'                    # required
        config.fog_public     = true                                   # optional, defaults to true
        config.root = Rails.root.join('tmp')
        config.cache_dir = 'files'
        config.permissions = 0777
        config.fog_attributes = {'Cache-Control'=>'max-age=315576000'} 
      end
   

 # optional, defaults to {}
  end
