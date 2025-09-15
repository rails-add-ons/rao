### Component Development

- When adding UI elements, start with a new partial or component.
- Always start with a simple green path unit test for every new model, controller, or service.
- Follow Rails conventions for naming and organization.

## UI/Design Principles

- All UI must be fully responsive (mobile, tablet, desktop).
- All UI must be accessible:
  - Keyboard navigable
  - Sufficient color contrast
  - Semantic HTML
  - ARIA attributes where needed
  - Focus indicators and skip links
- Use Rails form helpers and view components for consistency
- Leverage CMOR Suite components when available

## Efficient Collaboration Workflow

### Optimized Development Process
To maximize productivity and minimize credit usage when working together:

#### 1. **Precision Over Breadth**
- Use `grep_search` instead of `codebase_search` for exact matches
- Read specific line ranges instead of entire files
- Use `file_search` instead of exploring directories
- Target specific methods/classes rather than broad exploration

#### 2. **Plan Before Execute**
- **You describe the task** (e.g., "Add user authentication to calendar")
- **I ask clarifying questions** (file locations, approach preferences)
- **You guide me** (point me to relevant files, suggest approach)
- **I implement efficiently** (targeted tool usage, single attempt)

#### 3. **Leverage Your Knowledge**
- You tell me file locations and structure
- You guide me to the right approach
- I focus on implementation, not discovery
- You provide context about existing patterns and conventions

#### 4. **Efficient Tool Usage**
- `grep_search` for exact text/patterns (fastest)
- `read_file` with specific line ranges
- `edit_file` with precise changes
- Minimal terminal commands
- Avoid multiple iterations and trial-and-error

#### 5. **Targeted Workflow**
```
1. Task Description → You describe what needs to be done
2. Context Gathering → I ask specific questions about files/approach
3. Guided Implementation → You point me to relevant code, I implement
4. Single Attempt → Get it right the first time, avoid iterations
5. Batch Changes → Combine related modifications in single commits
```

#### 6. **Credit Optimization Goals**
- **Current**: ~10-15 tool calls per task
- **Target**: ~3-5 tool calls per task
- **Time savings**: 60-70% reduction in credit usage
- **Daily pace**: Sustainable for month-long development cycles

# Coding Guidelines

This document outlines the coding standards and principles to follow when contributing to this Ruby on Rails project.

## Core Principles

### 1. Act Like a Senior Developer
- Don't write code until we have both agreed to
- Write code that is maintainable, readable, and scalable
- Consider the long-term implications of architectural decisions
- Mentor junior developers through code reviews and documentation
- Think about performance, security, and user experience
- Take ownership of code quality and technical debt

### 2. Test-Driven Development (TDD)
- Write tests before implementing functionality
- Follow the Red-Green-Refactor cycle:
  - **Red**: Write a failing test
  - **Green**: Write minimal code to make the test pass
  - **Refactor**: Improve code while keeping tests green
- Aim for high test coverage with meaningful tests
- Write unit, integration, and feature tests as appropriate
- Use RSpec for all testing
- Prefer high-level tests

### 3. Keep It Simple, Stupid (KISS)
- Prefer simple solutions over complex ones
- Avoid over-engineering and premature optimization
- Write code that is easy to understand and modify
- Break down complex problems into smaller, manageable pieces
- Choose clarity over cleverness

### 4. Don't Repeat Yourself (DRY)
- Eliminate code duplication by extracting common functionality
- Create reusable methods, modules, and concerns
- Use configuration files and constants instead of magic numbers/strings
- Abstract repeated patterns into service objects or concerns
- Maintain a single source of truth for business logic

### 5. Separation of Concerns (SOC)
- Each model, controller, or service should have a single responsibility
- Separate business logic from presentation logic
- Keep API calls separate from controllers
- Organize code into logical layers (presentation, business, data)
- Use dependency injection to reduce coupling

### 6. Respect Cyclomatic Code Complexity
- Keep methods simple with low cyclomatic complexity
- **Target**: Cyclomatic complexity ≤ 10 per method
- **Maximum**: Cyclomatic complexity ≤ 15 (requires refactoring above this)
- Break down complex methods into smaller, focused methods
- Use early returns to reduce nesting levels
- Prefer composition over deeply nested conditional logic

### 7. Respect Code Coverage
- Maintain high code coverage across the codebase
- **Target**: ≥ 80% overall code coverage
- **Minimum**: ≥ 70% for new code
- Focus on meaningful tests rather than just hitting coverage numbers
- Prioritize testing critical business logic and edge cases
- Use coverage reports to identify untested code paths

### 8. Use Conventional Commits
- Follow the Conventional Commits specification for all commit messages
- **Format**: `<type>[optional scope]: <description>`
- **Types**: feat, fix, docs, style, refactor, test, chore, ci, build, perf
- Use present tense and imperative mood ("add" not "added" or "adds")
- Keep descriptions concise but descriptive (max 50 characters for subject)
- Include breaking changes with `BREAKING CHANGE:` footer when applicable

## Implementation Guidelines

### Code Organization

#### Rails Structure
- Follow Rails conventions for file organization


### Testing Strategy
- **Unit Tests**: Test individual methods and classes in isolation
- **Integration Tests**: Test controller actions and model interactions
- **Feature Tests**: Test complete user workflows using Capybara
- **Coverage Reports**: Generate and review coverage reports regularly
- Use FactoryBot for test data creation
- Use RSpec for all testing

### Code Review Checklist
- [ ] Code follows SOLID principles
- [ ] Methods have single responsibilities
- [ ] No code duplication
- [ ] Tests are written and passing
- [ ] Code coverage meets requirements
- [ ] Cyclomatic complexity is within limits
- [ ] Code is readable and well-documented
- [ ] Performance implications considered
- [ ] Security best practices followed
- [ ] Rails conventions followed

### Tools and Automation
- Use RuboCop for code quality checks
- Use Prettier for consistent code formatting (for JavaScript/CSS)
- Set up pre-commit hooks for automated checks
- Integrate coverage tools in CI/CD pipeline
- Use complexity analysis tools

## Best Practices

### Ruby and Rails
- Keep methods small (ideally < 20 lines)
- Use descriptive names that explain what the method does
- Limit method parameters (max 3-4 parameters)
- Return early to reduce nesting
- Use pure methods when possible
- Follow Rails naming conventions

### Models
- Keep models focused on data relationships and validations
- Use scopes for common queries
- Implement business logic in service objects
- Use callbacks sparingly and document their purpose
- Follow ActiveRecord best practices

### Controllers
- Keep controllers thin
- Use strong parameters for security
- Handle errors gracefully
- Use before_action filters appropriately
- Return appropriate HTTP status codes

### Views
- Keep views simple and focused on presentation
- Use partials for reusable components
- Use helpers for complex view logic
- Follow ERB best practices
- Use semantic HTML

### Error Handling
- Handle errors gracefully and provide meaningful messages
- Use rescue blocks appropriately
- Log errors for debugging but don't expose sensitive information
- Provide fallback UI states for error conditions
- Use Rails error handling mechanisms

### Performance
- Avoid N+1 queries using includes and joins
- Use counter caches where appropriate
- Consider caching strategies
- Profile and measure before optimizing
- Use background jobs for heavy operations

### Documentation
- Write clear commit messages
- Document complex business logic
- Keep README files updated
- Comment code when the "why" isn't obvious
- Maintain API documentation
- Document CMOR Suite customizations

## Rails-Specific Guidelines

### Database
- Use PostgreSQL features appropriately
- Write efficient database queries
- Use database indexes for performance
- Follow Rails migration best practices
- Use database constraints for data integrity

### Security
- Use strong parameters in controllers
- Validate and sanitize user input
- Use Rails security features (CSRF protection, etc.)
- Follow OWASP guidelines
- Use Authlogic securely

### Background Jobs
- Use Delayed Job for background processing
- Handle job failures gracefully
- Monitor job queues and performance
- Use appropriate job priorities

## Enforcement

These guidelines are enforced through:
- Automated linting and formatting (RuboCop)
- Code review process
- CI/CD pipeline checks
- Regular code quality audits
- Team discussions and retrospectives

Remember: These guidelines exist to improve code quality, maintainability, and team productivity. They should be followed consistently but can be discussed and evolved as the project grows.
