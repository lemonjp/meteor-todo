# lib/simple_schema.coffee
_.extend SimpleSchema,
  # this method will collect one schema from several passed objects
  # and return it
  build: (objects...) ->
    result = {}
    for obj in objects
      _.extend result, obj
    return new SimpleSchema result
  # If we add this object to the schema,
  # the model will have two fields that will be computed
  # automatically
  timestamp:
    createdAt:
      type: Date
      denyUpdate: true
      autoValue: ->
        if @isInsert
          return new Date
        if @isUpsert
          return { $setOnInsert: new Date }
        @unset()
    updatedAt:
      type: Date
      autoValue: ->
        new Date
