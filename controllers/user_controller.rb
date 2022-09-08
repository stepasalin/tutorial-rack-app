
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

  def user_page_get
    key = @req.path.gsub('/user/', '')
    begin
      user = User.new_from_redis(key)
      page = UserView.new(user).html_get
      [200, {}, [page]]
    rescue ArgumentsError => e
      [422, {}, [e.message]]
    rescue ExistingError => e
      [404, {}, [e.message]]
    end
  end

  def edit_user
    par_hash = JSON.parse(@req.body.read)
    user = User.new(par_hash)
    begin
      user.update_record_in_redis
      [200, {}, ["New data for user #{user.name} was saved"]]
    rescue ArgumentsError => e
      [422, {}, [e.message]]
    rescue ExistingError => e
      [404, {}, [e.message]]
    end
  end

  def user_delete
    par_hash = JSON.parse(@req.body.read)
    begin
      User.delete_from_redis(par_hash['name'])
      [200, {}, ['User was deleted']]
    rescue ExistingError => e
      [404, {}, [e.message]]
    end
  end
end
