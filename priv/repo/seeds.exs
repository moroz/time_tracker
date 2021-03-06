# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TimeTracker.Repo.insert!(%TimeTracker.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
#
alias TimeTracker.Users

Users.create_user(%{
  display_name: "John Cena",
  email: "user@example.com",
  password: "foobar",
  password_confirmation: "foobar"
})
