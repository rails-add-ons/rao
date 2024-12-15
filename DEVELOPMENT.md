# Development guide

## How do I create a new module?

    #> rails plugin new RaoResourcesController \
       --skip-collision-check \
       --skip-action-mailer \
       --skip-action-mailbox \
       --skip-javascript=false \
       --skip-test \
       --dummy-path=spec/dummy \
       --full \
       --mountable
