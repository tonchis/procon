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

  new_reason_form =
    new_reason: ko.observable ""
    add_pro: ->
      alert "pro"
      # adsfasdf
    add_con: ->
      alert "con"
      # asdfadsf
    add_both: ->
      alert "Both"
      # asdfasdfdsf
  ko.applyBindings new_reason_form, $("#new-reason-form")[0]
)
