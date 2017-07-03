const assert = require('assert')
const {promisify} = require('util')
const fs = require('fs')
const parseArgs = require('minimist')
const watch = require('node-watch')

const stat = promisify(fs.stat)

const log = (fn, msg) => {
  var d = new Date()
  console.log(`${d.toISOString()} ${fn} ${msg}`)
}

const checkDir = async (label, dir) => {
  assert(dir, `${label} not set`)
  const stats = await stat(dir)
  assert(stats.isDirectory(), `${label} is not a directory`)
}

const work = (src, dest) => {
  if (!src.endsWith('/')) {
    src = src + '/'
  }
  if (!dest.endsWith('/')) {
    dest = dest + '/'
  }
  watch(src, { recursive: true }, (evt, fn) => {
    if (evt === 'update') {
      const destFile = dest + fn.substr(src.length)
      fs.createReadStream(fn)
      .pipe(fs.createWriteStream(destFile))
      .on('error', (err) => log(fn, `sync ko(${err})`))
      .on('finish', () => log(fn, 'sync ok'))
    } else {
      log(fn, evt)
    }
  })
}

const main = async () => {
  const args = parseArgs(process.argv.slice(2))
  const src = args.s
  try {
    await checkDir('source', src)
  } catch (err) {
    log('check', err.message)
    setTimeout(() => {
      process.exit(1)
    }, 3000)
    return
  }
  const dest = args.d
  try {
    await checkDir('destination', dest)
  } catch (err) {
    log('check', err.message)
    setTimeout(() => {
      process.exit(1)
    }, 3000)
    return
  }
  work(src, dest)
}

main()
