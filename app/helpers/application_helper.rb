module ApplicationHelper
  def s3_image_tag(file_name)
    "<img src='https://s3.eu-central-1.amazonaws.com/watkins-prod/assets/#{file_name}' />".html_safe
  end
end
