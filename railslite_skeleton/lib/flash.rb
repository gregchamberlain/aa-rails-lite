require 'json'

class Flash

  COOKIE_NAME = "_rails_lite_app_flash"

  def initialize(req)
    @req = req
    cookie = req.cookies[COOKIE_NAME]
    @store = cookie ? JSON.parse(cookie) : {}
    puts @store
    @store.reject! { |k, v| v["expired"] }
    # require 'byebug'
    # debugger
    @store.keys.each do |key|
      @store[key]["expired"] = true
    end
  end

  def [](key)
    @store[key.to_s] ? @store[key.to_s]["value"] : now[key]
  end

  def []=(key, val)
    @store[key.to_s] = {"value" => val, "expired" => false}
  end

  def now
    @store_now ||= {}
  end

  def store_flash(res)
    res.set_cookie(COOKIE_NAME, {path: "/", value: @store.to_json })
  end
end
