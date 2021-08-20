class Post < SQLObject
  validate_presence_of :title, :body

  has_many :comments,
  foreign_key: :post_id
  
  belongs_to :author
  
  def author_name
    if self.author
      self.author.username
    else
      "anonymous"
    end
  end

  self.finalize!
end