ko.bindingHandlers.executeOnEnter =
  init: (element, valueAccessor, allBindingsAccessor, viewModel) ->
    allBindings = allBindingsAccessor()
    $(element).keypress (event) ->
      keyCode = (if event.which then event.which else event.keyCode)
      if keyCode is 13
        allBindings.executeOnEnter.call viewModel
        return false
      true
