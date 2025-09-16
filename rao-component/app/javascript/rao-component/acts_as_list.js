// Acts as List drag & drop functionality
// Converted from CoffeeScript to modern JavaScript

class ActsAsList {
  constructor() {
    this.initializeDraggable();
    this.initializeDroppable();
  }

  initializeDraggable() {
    document.querySelectorAll('[data-acts-as-list-item]').forEach((element) => {
      const $element = $(element);
      $element.draggable({
        scope: $element.attr('data-acts-as-list-item-scope'),
        revert: true
      });
    });
  }

  initializeDroppable() {
    document.querySelectorAll('[data-acts-as-list-item]').forEach((element) => {
      const $element = $(element);
      const redirectTarget = $element.attr('data-acts-as-list-item-on-drop-target');
      const authenticityToken = $('meta[name="csrf-token"]').attr('content');

      $element.droppable({
        accept: '.acts-as-list-item',
        scope: $element.attr('data-acts-as-list-item-scope'),
        activeClass: 'btn-success',
        drop: (event, ui) => {
          const droppedElement = $(ui.draggable);
          const droppedElementToParam = droppedElement.attr('data-acts-as-list-item-uid');
          $.redirect(redirectTarget, { 
            authenticity_token: authenticityToken, 
            dropped_id: droppedElementToParam 
          });
        }
      });
    });
  }

  static initialize() {
    // Only initialize if jQuery and jQuery UI are available
    if (typeof $ !== 'undefined' && $.fn.draggable && $.fn.droppable) {
      return new ActsAsList();
    } else {
      console.warn('ActsAsList: jQuery or jQuery UI not available');
      return null;
    }
  }
}

export default ActsAsList;
