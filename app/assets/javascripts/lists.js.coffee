$(document).ready(->
  new_list_form =
    list: ko.observable ""
    add_list: ->
      $.ajax
        dataType: "json"
        url: "/lists"
        type: "POST"
        data:
          name: @list()
        success: (data, textStatus, jqXHR) ->
          html = Mustache.render $("script#new-list").html(), {name: data.name, id: data.id}
          $(html).insertBefore("#lists ul li:last")
          @list("")

  ko.applyBindings new_list_form, $("#new-list-form")[0]

  new_pro_form = new_pro: ko.observable ""
  ko.applyBindings new_pro_form, $("#new-pro")[0]

  new_con_form = new_con: ko.observable ""
  ko.applyBindings new_con_form, $("#new-con")[0]
)
