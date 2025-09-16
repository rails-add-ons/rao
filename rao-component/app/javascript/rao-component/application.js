import 'jquery';
import 'jquery-ui';
import "rao-component/acts_as_list";
import "rao-component/awesome_nested_set";

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
    
    console.log("RaoComponent initialized with drag & drop functionality");
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
