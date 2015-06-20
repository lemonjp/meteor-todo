# client/lib/0.pageable_route_controller.coffee
varName = (inst, name = null) ->
  name = name && "_#{name}" || ""
  "#{inst.constructor.name}#{name}_limit"
class @PagableRouteController extends RouteController
  pageable: true # will check what kind of controller it is
  perPage: 20    # the amount of data per one page
  # the limit of requested data
  limit: (name = null) ->
    Session.get(varName(@, name)) || @perPage
  # the next page
  incLimit: (name = null, inc = null) ->
    inc ||= @perPage
    Session.set varName(@, name), (@limit(name) + inc)
  # reset the amount
  resetLimit: (name = null) ->
    Session.set varName(@, name), null
  # has all the data been loaded?
  loaded: (name = null) ->
    true
