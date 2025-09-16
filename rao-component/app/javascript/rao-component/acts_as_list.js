// Acts as List drag & drop functionality
// Modern vanilla JavaScript implementation using HTML5 Drag and Drop API

class ActsAsList {
  constructor() {
    this.draggedElement = null;
    this.initializeDragAndDrop();
  }

  initializeDragAndDrop() {
    const items = document.querySelectorAll('[data-acts-as-list-item]');
    
    items.forEach((element) => {
      this.makeDraggable(element);
      this.makeDroppable(element);
    });
  }

  makeDraggable(element) {
    element.draggable = true;
    element.style.cursor = 'grab';
    
    element.addEventListener('dragstart', (e) => {
      this.draggedElement = element;
      element.style.opacity = '0.5';
      element.style.cursor = 'grabbing';
      
      // Store the element's data for the drop handler
      e.dataTransfer.setData('text/plain', element.getAttribute('data-acts-as-list-item-uid'));
      e.dataTransfer.effectAllowed = 'move';
    });

    element.addEventListener('dragend', (e) => {
      element.style.opacity = '1';
      element.style.cursor = 'grab';
      this.draggedElement = null;
    });
  }

  makeDroppable(element) {
    const redirectTarget = element.getAttribute('data-acts-as-list-item-on-drop-target');
    const scope = element.getAttribute('data-acts-as-list-item-scope');

    element.addEventListener('dragover', (e) => {
      e.preventDefault(); // Allow drop
      
      // Check if the dragged element has the same scope
      if (this.draggedElement && this.isValidDrop(this.draggedElement, element, scope)) {
        element.classList.add('btn-success');
        e.dataTransfer.dropEffect = 'move';
      }
    });

    element.addEventListener('dragleave', (e) => {
      // Only remove class if we're actually leaving the element (not entering a child)
      if (!element.contains(e.relatedTarget)) {
        element.classList.remove('btn-success');
      }
    });

    element.addEventListener('drop', (e) => {
      e.preventDefault();
      element.classList.remove('btn-success');
      
      if (this.draggedElement && this.isValidDrop(this.draggedElement, element, scope)) {
        const droppedElementUid = e.dataTransfer.getData('text/plain');
        this.handleDrop(redirectTarget, droppedElementUid);
      }
    });
  }

  isValidDrop(draggedElement, dropTarget, scope) {
    // Check if both elements have the same scope
    const draggedScope = draggedElement.getAttribute('data-acts-as-list-item-scope');
    return draggedScope === scope && draggedElement !== dropTarget;
  }

  handleDrop(redirectTarget, droppedElementUid) {
    const authenticityToken = this.getCSRFToken();
    
    if (redirectTarget && droppedElementUid) {
      this.redirect(redirectTarget, {
        authenticity_token: authenticityToken,
        dropped_id: droppedElementUid
      });
    }
  }

  getCSRFToken() {
    const metaTag = document.querySelector('meta[name="csrf-token"]');
    return metaTag ? metaTag.getAttribute('content') : null;
  }

  redirect(url, params) {
    // Create a form to submit the data via POST
    const form = document.createElement('form');
    form.method = 'POST';
    form.action = url;
    form.style.display = 'none';

    // Add parameters as hidden inputs
    Object.keys(params).forEach(key => {
      const input = document.createElement('input');
      input.type = 'hidden';
      input.name = key;
      input.value = params[key];
      form.appendChild(input);
    });

    document.body.appendChild(form);
    form.submit();
  }

  static initialize() {
    // No external dependencies required - always initialize
    return new ActsAsList();
  }
}

export default ActsAsList;
