Factory.define :journal do |f|
  f.association :journalized, :factory => :issue
end
