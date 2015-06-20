# server/config/smtp/coffee
smtp =
  username: "meteor-todo-list@yandex.ru"
  password: "meteor-todo-list1234"
  server:   "smtp.yandex.ru"
  port:     "587"
# Escaping symbols
_(smtp).each (value, key) -> smtp[key] = encodeURIComponent(value)
# The template of url access to smtp
url = "smtp://#{smtp.username}:#{smtp.password}@#{smtp.server}:#{smtp.port}"
# Define the environment variable, Meteor will use data from it
process.env.MAIL_URL = url
