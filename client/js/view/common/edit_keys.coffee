key = require '../../util/key'

exports.handleEditKeys = (e) ->
  if e.keyCode is key.ESC
    e.preventDefault()
    @handleCancel e
  else if e.keyCode is key.S and e.metaKey
    e.preventDefault()
    @handleSubmit e
