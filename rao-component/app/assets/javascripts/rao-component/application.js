class RaoComponent {
  constructor() {
    console.log("Hello world!");
  }
  
  static initialize() {
    console.log("RaoComponent initialized - Hello world!");
    return new RaoComponent();
  }
}

// Auto-initialize on DOM load
document.addEventListener('DOMContentLoaded', function() {
  RaoComponent.initialize();
});

// Also initialize on Turbo load for Rails apps
document.addEventListener('turbo:load', function() {
  RaoComponent.initialize();
});

export default RaoComponent;
