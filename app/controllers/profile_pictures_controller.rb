class ProfilePicturesController < ApplicationController

  AWS.config(access_key_id: ENV["ACCESS_KEY_ID"], secret_access_key: ENV["SECRET_ACCESS_KEY"], region: 'ap-northeast-1')

  def upload
    @user = User.find(current_user.id)
  end

  def upload_process
    if Rails.env == 'production'
      upload_production
    else
      upload_develop
    end
  end

  def upload_develop
    user = User.find(current_user.id)
    file = params[:croppedImage]
    file = file.gsub('data:image/jpeg;base64,','')
    plain = Base64.decode64(file)
    name = current_user.id.to_s + '_' + Time.now.strftime('%Y%m%d%H%M%S').to_s + params[:size].to_s
    if params[:size].to_s == 'lg'
      user.picture = name.to_s + '.jpeg'
      user.save
    end
    File.open("public/docs/#{name}.jpeg", 'wb') { |f| f.write(plain) }
  end

  def upload_production
    #s3d = AWS::S3.new
    #s3d.buckets[ENV["AWS_S3_BUCKET"]].objects["images/"+picture.id.to_s+File.extname("#{ picture.picture_name }").downcase].delete

    s3 = AWS::S3.new
    bucket = s3.buckets[ENV["AWS_S3_BUCKET"]]

    file = params[:croppedImage]
    file = file.gsub('data:image/jpeg;base64,','')
    plain = Base64.decode64(file)
    name = current_user.id.to_s + params[:size].to_s + '.jpeg'

    file_full_path="images/"+name.to_s
    object = bucket.objects[file_full_path]
    object.write(plain ,:acl => :public_read)
  end
end
