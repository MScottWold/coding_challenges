class Author < SQLObject
  validate_presence_of :username

  has_many :posts

  self.finalize!
end