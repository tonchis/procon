class window.Dilemmas
  constructor: (attrs) ->
    @dilemmas = ko.observableArray DilemmasHelper.build_dilemmas(attrs)
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
    ko.applyBindings dilemma, $("#edit-dilemma")[0]
    $("#edit-dilemma").slideDown()
    $("#edit-dilemma ul").on "mouseenter", "li", DilemmasHelper.show_delete
    $("#edit-dilemma ul").on "mouseleave", "li", DilemmasHelper.hide_delete
    $("#dilemmas").slideUp()
  delete_dilemma: (dilemma) =>
    $.ajax
      url: "/dilemmas/#{dilemma.id}"
      type: "DELETE"
      success: => @dilemmas.remove dilemma
