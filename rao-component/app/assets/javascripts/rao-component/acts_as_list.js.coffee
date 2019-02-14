$ ->
  $('[data-acts-as-list-item]').each ->
    $(@).draggable({
      scope: $(@).attr('data-acts-as-list-item-scope'),
      revert: true
    })

$ ->
  $('[data-acts-as-list-item]').each ->
    redirect_target = $(@).attr('data-acts-as-list-item-on-drop-target')
    authenticity_token = $( 'meta[name="csrf-token"]' ).attr( 'content' );

    $(@).droppable({
      accept: '.acts-as-list-item',
      scope: $(@).attr('data-acts-as-list-item-scope'),
      activeClass: 'btn-success',
      drop: (event, ui) ->
        dropped_element = $(ui.draggable)
        dropped_element_to_param = dropped_element.attr('data-acts-as-list-item-uid')
        $.redirect(redirect_target,{ authenticity_token: authenticity_token, dropped_id: dropped_element_to_param }); 
    })