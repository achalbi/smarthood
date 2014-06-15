# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
addresses = Address.create!([city: "Bangalore", state: "Karnataka", country: "India"])
admins = User.create!([name:     "Achal BI",
                       email:    "achal.rvce@gmail.com",
					   email_confirmation:    "achal.rvce@gmail.com",
                       password: "achalbi",
                       password_confirmation: "achalbi",
                       address_id: addresses.first.id, admin: true])
ui = UserInfo.create!([first_name: "Achal", last_name: "BI", user: admins.first])
photos = Photo.create!([pic: '', user_id: admins.first.id])
communities = Community.create!([user_id: admins.first.id, photo_id: photos.first.id, name: "Smarthood", description: "Smarthood community", privacy: 7, address: "Bangalore, Karnataka, India", latitude: 12.9715987, longitude: 77.5945627, comm_type: "organisation"])
Usercommunity.create!(community_id: communities.first.id, user_id: admins.first.id, status: "active", is_admin: true, invitation: "joined")