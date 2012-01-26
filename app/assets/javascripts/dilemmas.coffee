#= require knockout-2.0.0
#= require helpers/ko_custom_bindings
#= require helpers/dilemmas_helper

class window.Dilemma
  constructor: (attrs) ->
    attrs.reasons?= []

    @id      = attrs.id
    @name    = ko.observable attrs.name
    @pros    = ko.observableArray DilemmasHelper.select_reasons(attrs.reasons, "pro")
    @cons    = ko.observableArray DilemmasHelper.select_reasons(attrs.reasons, "con")
    @dilemma = ko.computed =>
      id: @id
      name: @name()
      reasons: $.merge(DilemmasHelper.stringify_array(@pros()),
                       DilemmasHelper.stringify_array(@cons()))

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
  delete_pro: (pro) => DilemmasHelper.delete_reason(pro, @pros)
  delete_con: (con) => DilemmasHelper.delete_reason(con, @cons)
  save_dilemma: (dilemma) ->
    $.ajax
      url: "/dilemmas/#{@dilemma().id}"
      type: "PUT"
      data: @dilemma()
      success: ->
        $("#dilemmas").slideDown()
        $("#edit-dilemma").slideUp()
  cancel_edit: (dilemma) ->
    $("#dilemmas").slideDown()
    $("#edit-dilemma").slideUp()


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

$(document).ready(->
  # Request ALL the dilemmas!
  $.ajax
    url: "/dilemmas"
    type: "GET"
    success: (data) =>
      ko.applyBindings new Dilemmas(data), $("#dilemmas")[0]
      $("#dilemmas").show()
      $("#dilemmas ul").on "mouseenter", "li", DilemmasHelper.show_delete
      $("#dilemmas ul").on "mouseleave", "li", DilemmasHelper.hide_delete
)
