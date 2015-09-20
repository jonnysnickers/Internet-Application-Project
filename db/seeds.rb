# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user1 = User.create(firstname: "U1", lastname: "U1", pesel: "U123", address: "U123asd", username: "U1", enabled: "y", ttype: "patient", password: "qwerty", password_confirmation: "qwerty")
user2 = User.create(firstname: "U2", lastname: "U2", pesel: "U123", address: "U123asd", username: "U2", enabled: "y", ttype: "patient", password: "qwerty", password_confirmation: "qwerty")
doc1 = User.create(firstname: "D1", lastname: "D1", pesel: "D123", address: "D123asd", username: "D1", enabled: "y", ttype: "doctor", password: "qwerty", password_confirmation: "qwerty")
doc2 = User.create(firstname: "D2", lastname: "D2", pesel: "D123", address: "D123asd", username: "D2", enabled: "y", ttype: "doctor", password: "qwerty", password_confirmation: "qwerty")

admin = User.create(firstname: "admin", lastname: "admin", pesel: "admin", address: "admin", username: "admin", enabled: "y", ttype: "admin", password: "adminadmin", password_confirmation: "adminadmin")

cli1 = Clinic.create(name: "Clinic1")
cli2 = Clinic.create(name: "Clinic2")

DocCli.create(user: doc1, clinic: cli1)
DocCli.create(user: doc1, clinic: cli2)
DocCli.create(user: doc2, clinic: cli1)

d1 = Duty.create(user: doc1, clinic: cli1, date: 540)
d1 = Duty.create(user: doc1, clinic: cli2, date: 570)

app1 = Appointment.create(patient: user1, doctor: doc1, clinic: cli1, date: "2015-09-15 19:42:48", enabled: "y")
app2 = Appointment.create(patient: user1, doctor: doc1, clinic: cli1, date: "2018-09-15 20:42:48", enabled: "y)"