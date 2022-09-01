
class UserController
  def initialize(req)
    @req = req
  end

  def save_user
    par_hash = JSON.parse(@req.body.read)
    user = User.new(par_hash)
    begin
      user.save
      [200, {}, ['Data was saved']]
    rescue ArgumentsError => e
      [422, {}, [e.message]]
    rescue ExistingError => e
      [409, {}, [e.message]]
    end
  end

  def get_user_page
    key = @req.path.gsub('/user/', '')
    begin
      user = User.new_from_redis(key)
      user.user_get
      [200, {}, [user.data]]
    rescue ArgumentsError => e
      [422, {}, [e.message]]
    rescue ExistingError => e
      [404, {}, [e.message]]
    end
  end
end