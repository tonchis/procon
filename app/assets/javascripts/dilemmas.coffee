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
          @dilemma ""
  ko.applyBindings new_dilemma_form, $("#new-dilemma-form")[0]

  # Behavior for delete buttons. This replaces the deprecated .live() function.
  $(document).on("click", "#dilemmas ul li a.delete-link", ->
    $.ajax
      url: "/dilemmas/#{$(@).attr("data-id")}"
      type: "DELETE"
      success: => $(@).parent().remove()
  )

  class Dilemma
    constructor: (attrs) ->
      @name    = ko.observable attrs.name
      @pros    = ko.observableArray @select_reasons(attrs.reasons, "pro")
      @cons    = ko.observableArray @select_reasons(attrs.reasons, "con")
      @dilemma = ko.computed =>
        name: @name()
        reasons:
          pros: @pros()
          cons: @cons()
      @new_reason = ko.observable ""

    add_pro: ->
      @pros.push text: @new_reason(), type: "pro"
      @new_reason ""
    add_con: ->
      @cons.push text: @new_reason(), type: "con"
      @new_reason ""
    add_both: ->
      @pros.push text: @new_reason(), type: "pro"
      @cons.push text: @new_reason(), type: "con"
      @new_reason ""
    save_dilemma: ->
      console.log @dilemma()

    select_reasons: (reasons, type) ->
      reasons_type = []
      reasons_type = (reason for reason in reasons when reason.type is type)

  new_dilemma =  new Dilemma({name: "dude", reasons: [{text: "asdfad", type: "pro"}, {text: "qer", type: "con"}]})
  ko.applyBindings new_dilemma, $("#edit-dilemma")[0]

)
