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
             password: admin_pass, role: :admin)
admin.confirm

guest = User.create!(name: "Guest", login: "guest", email: "guest@example.com",
                     password: "guest_user_pass", banned: true)
guest.confirm
deleted = User.create!(name: "Deleted", login: "deleted", email: "deleted@example.com",
                       password: "deleted_user_pass", banned: true)
deleted.confirm

## Fake data (needs remove in production)

user1 = User.create!(name: "User 1", login: "user1", email: "user1@example.com",
                     password: "1234567")
user1.confirm

# Create Files and Folders
# need FileManager
f = FileEntity::File.mk_file(name: "My file",
                             real_path: "hdfs://dir1/node25/file",
                             user: admin)
f.prepared = true
f.save

f1 = FileEntity::File.mk_file(name: "My file 1",
                              real_path: "hdfs://dir1/node25/file1",
                              user: admin)
f1.prepared = true
f1.save

f2 = FileEntity::File.mk_file(name: "My file 2",
                              real_path: "hdfs://dir1/node25/file2",
                              user: admin)
f2.prepared = true
f2.save

d = FileEntity::Folder.mk_dir(name: "My folder test",
                              real_path: "hdfs://dir1/node25/folder",
                              user: admin)
d.prepared = true
d.save

f3 = FileEntity::File.mk_file(name: "My file 2",
                              real_path: "hdfs://dir1/node25/file3",
                              user: admin,
                              parent: d)
f3.prepared = true
f3.save

# need PermitManager
DocumentPermission.create!(document: f, user: user1, action: Action::Read)
DocumentPermission.create!(document: f, user: user1, action: Action::Update)
DocumentPermission.create!(document: f1, user: user1, action: Action::Write)

s = admin.scripts.create!(name: "Map reduce world splitter")

# need TaskManager
admin.tasks.create!(name: "My Task 1", script: s)


