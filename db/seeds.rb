# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts 'EMPTY THE MONGODB DATABASE'
Mongoid.master.collections.reject { |c| c.name =~ /^system/}.each(&:drop)

puts 'SETTING UP DEFAULT USER LOGIN'
user = User.create!(first_name: 'First', last_name: 'User', user_name: 'first_user',
                    email: 'user@test.com', password: 'please', password_confirmation: 'please')
puts 'New user created: ' << user.user_name

group = user.groups.create!(name: 'First Group', owner_id: user.id, admin_ids: [user.id])
puts 'New group created: ' << group.name

user2 =User.create!(first_name: 'Second', last_name: 'User', user_name: 'second_user',
                    email: 'user2@test.com', password: 'please', password_confirmation: 'please')

group.users << user2

