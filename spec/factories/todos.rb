Factory.define :todo do |f|
  f.association :author, :factory => :user
  f.association :owner, :factory => :user
  f.association :issue, :factory => :issue
end


