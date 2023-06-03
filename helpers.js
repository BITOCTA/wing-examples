const uuid = require('uuid')

exports.makeId = async function () {
  return uuid.v4()
}

exports.getIdFromPath = async function (path) {
  return path.split('/')[path.split('/').length - 1]
}

exports.isUndefined = async function (t) {
  return typeof t === 'undefined'
}
