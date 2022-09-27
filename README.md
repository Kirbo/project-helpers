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
  "deploy:dev": "joku_komento millä_deployataan deviin && yarn tag:commit dev",
  "deploy:prod": "joku_komento millä_deployataan prodiin && yarn tag:commit prod"
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


## Example project

http://github.com/kirbo/project-helpers-test

Example screenshot:
![https://github.com/Kirbo/project-helpers-test/blob/master/example.png?raw=true](https://github.com/Kirbo/project-helpers-test/blob/master/example.png?raw=true)
