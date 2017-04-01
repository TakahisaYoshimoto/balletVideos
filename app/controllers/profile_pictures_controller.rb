class ProfilePicturesController < ApplicationController

  AWS.config(access_key_id: ENV["ACCESS_KEY_ID"], secret_access_key: ENV["SECRET_ACCESS_KEY"], region: 'ap-northeast-1')

  def upload
    
  end

  def upload_process
    if Rails.env == 'production'
      upload_production
    else
      upload_develop
    end
  end

  def upload_develop
    file = params[:croppedImage]
    file = file.gsub('data:image/jpeg;base64,','')
    plain = Base64.decode64(file)
    name = current_user.id.to_s + params[:size].to_s
    File.open("public/docs/#{name}.jpeg", 'wb') { |f| f.write(plain) }
  end

  def upload_production
    s3 = AWS::S3.new
    bucket = s3.buckets[ENV["AWS_S3_BUCKET"]]

    file = params[:croppedImage]
    file = file.gsub('data:image/jpeg;base64,','')
    plain = Base64.decode64(file)
    name = current_user.id.to_s + params[:size].to_s

    file_full_path="images/"+name.to_s
    object = bucket.objects[file_full_path]
    object.write(file ,:acl => :public_read)
  end
end
