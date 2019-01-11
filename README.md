# Pylint Action (Via linty_fresh)

A GitHub which runs linty_fresh, and specifically only pylint. This is a slim
wrapper around existing functionality, which wraps it in the necessary pieces to
leverage GitHub actions.

## Usage

```
workflow "pylint action" {
  on = "pull_request"
  resolves = ["post review on pull request"]
}

action "post review on pull request" {
  uses = "bartek/pylint-action@master"
  secrets = ["GITHUB_TOKEN"]
}
```
