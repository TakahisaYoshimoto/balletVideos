class RegistrationsController < Devise::RegistrationsController
  def after_sign_up_path_for(resource)
    # admin_user_mail_sent_message_path
    root_path
  end

  def after_inactive_sign_up_path_for(resource)
    # admin_user_mail_sent_message_path
    sign_up_mail_bits_path
  end
end
