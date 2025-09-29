import ActsAsList from "rao-component/acts_as_list";
import AwesomeNestedSet from "rao-component/awesome_nested_set";

// show a greeting on load (support turbo)
document.addEventListener("turbo:load", function() {
  console.log("[RaoComponent] ❤️");
});

class RaoComponent {
  constructor() {
    this.actsAsList = null;
    this.awesomeNestedSet = null;
    this.initializeComponents();
  }
  
  initializeComponents() {
    // Initialize ActsAsList functionality
    this.actsAsList = ActsAsList.initialize();
    
    // Initialize AwesomeNestedSet functionality
    this.awesomeNestedSet = AwesomeNestedSet.initialize();
    
    console.log("RaoComponent initialized with vanilla JavaScript drag & drop functionality");
  }
  
  static initialize() {
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
