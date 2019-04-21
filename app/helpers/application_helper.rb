module ApplicationHelper
  def avatar_url(user)
    if user.image
      "http://graph.facebook.com/v2.10/#{user.uid}/picture?type=large"
      # raise
    else
    gravatar_id = Digest::MD5::hexdigest(user.email).downcase
    "https://www.gravatar.com/avatar/#{gravatar_id}.jpg?d=identical&s=150"
    end
  end
end


# taking user object -> his email, convert to "string of numbers" (MD5)
# http://graph.facebook.com/v2.10/xxxxxxxxxxxxxx/picture
