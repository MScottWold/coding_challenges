require 'json'

class Flash
  def initialize(req)
    flash = req.cookies["_rails_lite_app_flash"]
    if flash
      @flash = { session: JSON.parse(flash, :symbolize_names => true), now: Hash.new }
      @new_flash = false
    else
      @flash = { session: Hash.new, now: Hash.new }
    end
  end

  def [](key)
    @flash[:session][key.to_sym] || @flash[:now][key]
  end

  def []=(key, val)
    @new_flash = true
    @flash[:session][key.to_sym] = val
  end
  
  def now
    @flash[:now]
  end

  def store_flash(res)
    if @new_flash
      res.set_cookie(:_rails_lite_app_flash, path: "/", value: @flash[:session].to_json)
    else
      res.set_cookie(:_rails_lite_app_flash, path: "/", max_age: -1, value: {})
    end
  end
end