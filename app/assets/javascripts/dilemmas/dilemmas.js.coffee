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
        @dilemmas.push new Dilemma(data)
        @new_dilemma ""
  edit_dilemma: (dilemma) ->
    ko.applyBindings dilemma
    $("#edit-dilemma").slideDown()
    $("#dilemmas").slideUp()
  delete_dilemma: (dilemma) =>
    $.ajax
      url: "/dilemmas/#{dilemma.id()}"
      type: "DELETE"
      success: => @dilemmas.remove dilemma

  # Helper methods
  build_dilemmas: (attrs) ->
    dilemmas = []
    dilemmas = (new Dilemma(dilemma_attrs) for dilemma_attrs in attrs)

