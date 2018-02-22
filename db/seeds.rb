# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
admin_pass = ENV.fetch('ADMIN_PASSWORD', "12345678")
email_admin = ENV.fetch('ADMIN_EMAIL', "yegorov0725@yandex.ru")
admin = User.create!(name: "Admin", login: "admin", email: email_admin,
             password: admin_pass, role: User::ADMIN)
admin.confirm

guest = User.create!(name: "Guest", login: "guest", email: "guest@example.com",
                     password: "guest_user_pass", banned: true)
guest.confirm
deleted = User.create!(name: "Deleted", login: "deleted", email: "deleted@example.com",
                       password: "deleted_user_pass", banned: true)
deleted.confirm
