class Comment < SQLObject
  validate_presence_of :body, :username, :post_id

  has_one_through :original_poster, :post, :author
  
  belongs_to :post,
  foreign_key: :post_id
  
  self.finalize!

  def post_author
    if self.post.author
      self.original_poster.username
    else
      "anonymous"
    end
  end
end