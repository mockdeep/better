Factory.define :user do |f|
  f.sequence(:login) { |n| "username#{n.to_s.rjust(5, '0')}" }
  f.password "password"
  f.sequence(:mail) { |n| "username#{n.to_s.rjust(5, '0')}@testing.com" }
  f.sequence(:firstname) { |n| "first-#{n.to_s.rjust(5, '0')}" }
  f.sequence(:lastname) { |n| "last-#{n.to_s.rjust(5, '0')}" }
end

Factory.define :admin_user, :parent => :user do |u|
  u.admin true
end
