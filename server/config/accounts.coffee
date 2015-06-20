# server/config/accounts.coffee
emailTemplates =
  from: 'TODO List <meteor-todo-list@yandex.ru>'
  siteName: 'Meteor. TODO List.'
# replace the standard settings for the mail
_.deepExtend Accounts.emailTemplates, emailTemplates
# invoke verification
Accounts.config
  sendVerificationEmail: true
# add the custom logic during the registration of users
Accounts.onCreateUser (options = {}, user) ->
  u = UsersCollection._transform(user)
  options.profile ||= {}
  # save hash addresses, so that we could get the avatar of the user
  # who has not indicated the public email address
  options.profile.emailHash = Gravatar.hash(u.getEmail() || "")
  # remember the service, via which the user has registered.
  options.service = _(user.services).keys()[0] if user.services
  # save additional parameters and return the object
  # that will be written to the database
  _.extend user, options
