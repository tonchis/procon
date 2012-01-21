$(document).ready(->
  class Dilemma
    constructor: (attrs) ->
      attrs.reasons?= []

      @id      = ko.observable attrs.id
      @name    = ko.observable attrs.name
      @pros    = ko.observableArray @select_reasons(attrs.reasons, "pro")
      @cons    = ko.observableArray @select_reasons(attrs.reasons, "con")
      @dilemma = ko.computed =>
        name: @name()
        reasons:
          pros: @pros()
          cons: @cons()
      @new_reason = ko.observable ""

    # Events
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

    # Helper functions
    select_reasons: (reasons, type) ->
      reasons_type = []
      reasons_type = (reason for reason in reasons when reason.type is type)

  class Dilemmas
    constructor: (attrs) ->
      @dilemmas = ko.observableArray @build_dilemmas(attrs)
      @new_dilemma = ko.observable ""

    # Events
    add_dilemma: ->
      $.ajax
        dataType: "json"
        url: "/dilemmas"
        type: "POST"
        data: name: @new_dilemma()
        success: (data) =>
          created_dilemma = new Dilemma(data)
          @dilemmas.push created_dilemma
          @new_dilemma ""
    edit_dilemma: (dilemma) ->
      ko.applyBindings dilemma, $("#edit-dilemma")[0]
    delete_dilemma: (dilemma) =>
      $.ajax
        url: "/dilemmas/#{dilemma.id()}"
        type: "DELETE"
        success: => @dilemmas.remove dilemma

    # Helper methods
    build_dilemmas: (attrs) ->
      dilemmas = []
      dilemmas = (new Dilemma(dilemma_attrs) for dilemma_attrs in attrs)

  $.ajax
    url: "/dilemmas"
    type: "GET"
    success: (data) =>
      ko.applyBindings new Dilemmas(data), $("#dilemmas")[0]
)