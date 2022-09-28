# Project Helpers

## Installation

```
yarn add https://github.com/Kirbo/project-helpers#master
```

Add new scripts to `pacakge.json` file:
```
"scripts": {
  "tag:list": "tag-list",
  "tag:commit": "tag-commit",
  "deploy:dev": "some_command/that_will_deploy_to dev && yarn tag:commit dev",
  "deploy:prod": "some_command/that_will_deploy_to prod && yarn tag:commit prod"
}
```


## Usage

From now on, deploy with command:
```
yarn deploy:dev
```

...and if you want to check what has been deployed before, use:
```
yarn tag:list
```

## Predefined stages

There are hard coded pre-defined stages:
- `dev`
- `test`
- `qa`
- `prod`

The `tag:list` will group the tags into following sections:
- `DEV`
- `TEST`
- `QA`
- `PROD`
- `OTHER`

## Example project

http://github.com/kirbo/project-helpers-test

Example screenshot:
![https://github.com/Kirbo/project-helpers-test/blob/master/example.png?raw=true](https://github.com/Kirbo/project-helpers-test/blob/master/example.png?raw=true)
