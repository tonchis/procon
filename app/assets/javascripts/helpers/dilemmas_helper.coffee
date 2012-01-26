class window.DilemmasHelper
  # To show and hide delete links
  @show_delete = -> $(@).find(".delete").show()
  @hide_delete = -> $(@).find(".delete").hide()

  @select_reasons: (reasons, type) ->
    reasons_type = []
    reasons_type = (reason for reason in reasons when reason.type is type)

  @stringify_array: (objects)->
    jsons = []
    jsons = (JSON.stringify(object) for object in objects)

  @delete_reason: (reason, reasons) -> reasons.destroy(reason)

  @build_dilemmas: (attrs) ->
    dilemmas = []
    dilemmas = (new Dilemma(dilemma_attrs) for dilemma_attrs in attrs)

