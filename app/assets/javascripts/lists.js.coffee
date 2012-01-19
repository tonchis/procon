$(document).ready(->
  # Behavior for "Your new dilemma" input
  new_list_form =
    list: ko.observable ""
    add_list: ->
      self = this
      $.ajax
        dataType: "json"
        url: "/lists"
        type: "POST"
        data:
          name: @list()
        success: (data, textStatus, jqXHR) ->
          html = Mustache.render $("script#new-list").html(),
                                 {name: data.name, id: data.id}
          $(html).insertBefore("#lists ul li:last")
          self.list("")
  ko.applyBindings new_list_form, $("#new-list-form")[0]

  # Behavior for delete buttons
  $("#lists ul li a.delete-link").live("click", ->
    self = this
    $.ajax
      url: "/lists/#{$(self).attr("data-id")}"
      type: "DELETE"
      success: ->
        $(self).parent().remove()
  )

  new_pro_form = new_pro: ko.observable ""
  ko.applyBindings new_pro_form, $("#new-pro")[0]

  new_con_form = new_con: ko.observable ""
  ko.applyBindings new_con_form, $("#new-con")[0]
)
