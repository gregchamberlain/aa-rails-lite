require 'json'

class Session

  COOKIE_NAME = "_rails_lite_app"
  # find the cookie for this app
  # deserialize the cookie into a hash
  def initialize(req)
    cookie = req.cookies[COOKIE_NAME]
    @session = cookie ? JSON.parse(cookie) : {}
  end

  def [](key)
    @session[key]
  end

  def []=(key, val)
    @session[key] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
    res.set_cookie(COOKIE_NAME, {path: "/", value: @session.to_json })
  end
end
