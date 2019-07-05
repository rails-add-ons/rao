$ ->
  $('[data-awesome-nested-set-item]').each ->
    $(@).draggable({
      scope: $(@).attr('data-awesome-nested-set-item-scope'),
      revert: true
    })

$ ->
  $('[data-awesome-nested-set-item]').each ->
    redirect_target = $(@).attr('data-awesome-nested-set-item-on-drop-target')
    console.log(redirect_target)
    authenticity_token = $( 'meta[name="csrf-token"]' ).attr( 'content' );

    $(@).droppable({
      accept: '.awesome-nested-set-item',
      scope: $(@).attr('data-awesome-nested-set-item-scope'),
      activeClass: 'btn-success',
      drop: (event, ui) ->
        dropped_element = $(ui.draggable)
        dropped_element_to_param = dropped_element.attr('data-awesome-nested-set-item-uid')
        $.redirect(redirect_target,{ authenticity_token: authenticity_token, dropped_id: dropped_element_to_param }); 
    })