$(document).ready(->
  # The classic js way.
  # enable_button_if_filled = ->
    # input  = $(this)
    # button = input.parent().find("input[type=submit]")
    # button.attr("disabled", "disabled")
    # button.removeAttr("disabled") if input.val().length > 0

  # $("#new-list-input").change(enable_button_if_filled)
  # $("#new-list-input").trigger("change")

  # The mindblowing knockout way.
  new_list_form =
    list: ko.observable("")

  ko.applyBindings(new_list_form, $("#new-list-form")[0])
)
