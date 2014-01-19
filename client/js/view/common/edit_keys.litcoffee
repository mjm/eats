# EditKeys: Editor Mixin

EditKeys is a React component mixin for the application's editable fields.  It
provides a handler for `keyDown` events that should be handled by all our
editable fields.

This mixin assumes that the component it's mixed into defines two methods:
`handleCancel` and `handleSubmit`.

    key = require '../../util/key'

    exports.handleEditKeys = (e) ->

If the user presses the escape key, we cancel editing the field.

      if e.keyCode is key.ESC
        e.preventDefault()
        @handleCancel e

If the user presses Cmd-S, we save the changes to the field.

      else if e.keyCode is key.S and e.metaKey
        e.preventDefault()
        @handleSubmit e
