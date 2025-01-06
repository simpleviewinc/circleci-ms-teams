# CircleCI MS Teams Orb

Basic orb for sending Teams notifications in CircleCI jobs.

* [CircleCI Orb](https://circleci.com/developer/orbs/orb/simpleviewinc/circleci-ms-teams)

## Usage

* Determine the Teams webhook url
    * In MS Teams right click on the Channel (it must be a Channel and not a Chat), go to workflows, and enable a "Post to a channel when a webhook request is received".
* Add the orb to your CircleCI config
    * See the orb link in circleci for the relevant parameters.

## Development

* Push will trigger a lint and verification step.
* Create a Git tag and then push and that will auto-deploy a version at the tagged version.
