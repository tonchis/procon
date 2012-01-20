$(document).ready(->
  # Behavior for "Your new dilemma" input
  new_dilemma_form =
    dilemma: ko.observable ""
    add_dilemma: ->
      $.ajax
        dataType: "json"
        url: "/dilemmas"
        type: "POST"
        data: name: @dilemma()
        success: (data) =>
          html = Mustache.render $("script#new-dilemma").html(),
                                 {name: data.name, id: data.id}
          $(html).insertBefore("#dilemmas ul li:last")
          @dilemma("")
  ko.applyBindings new_dilemma_form, $("#new-dilemma-form")[0]

  # Behavior for delete buttons. This replaces the deprecated .live() function.
  $(document).on("click", "#dilemmas ul li a.delete-link", ->
    $.ajax
      url: "/dilemmas/#{$(@).attr("data-id")}"
      type: "DELETE"
      success: => $(@).parent().remove()
  )

  new_pro_form = new_pro: ko.observable ""
  ko.applyBindings new_pro_form, $("#new-pro")[0]

  new_con_form = new_con: ko.observable ""
  ko.applyBindings new_con_form, $("#new-con")[0]
)
