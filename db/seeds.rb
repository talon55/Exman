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


group = user.groups.create!(name: 'First Group')
group.owner = user
group.admin_ids = []
group.save


user2 = User.create!(first_name: 'Second', last_name: 'User', user_name: 'second_user',
                     email: 'user2@test.com', password: 'please', password_confirmation: 'please')
user3 = User.create!(first_name: 'Third', last_name: 'User', user_name: 'third_user',
                     email: 'user3@test.com', password: 'please', password_confirmation: 'please')

group.users << user2
group.users << user3

