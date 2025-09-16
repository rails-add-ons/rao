// Awesome Nested Set drag & drop functionality
// Converted from CoffeeScript to modern JavaScript

class AwesomeNestedSet {
  constructor() {
    this.initializeDraggable();
    this.initializeDroppable();
  }

  initializeDraggable() {
    document.querySelectorAll('[data-awesome-nested-set-item]').forEach((element) => {
      const $element = $(element);
      $element.draggable({
        scope: $element.attr('data-awesome-nested-set-item-scope'),
        revert: true
      });
    });
  }

  initializeDroppable() {
    document.querySelectorAll('[data-awesome-nested-set-item]').forEach((element) => {
      const $element = $(element);
      const redirectTarget = $element.attr('data-awesome-nested-set-item-on-drop-target');
      console.log(redirectTarget);
      const authenticityToken = $('meta[name="csrf-token"]').attr('content');

      $element.droppable({
        accept: '.awesome-nested-set-item',
        scope: $element.attr('data-awesome-nested-set-item-scope'),
        activeClass: 'btn-success',
        drop: (event, ui) => {
          const droppedElement = $(ui.draggable);
          const droppedElementToParam = droppedElement.attr('data-awesome-nested-set-item-uid');
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
      return new AwesomeNestedSet();
    } else {
      console.warn('AwesomeNestedSet: jQuery or jQuery UI not available');
      return null;
    }
  }
}

export default AwesomeNestedSet;
